import { getApps, initializeApp } from "firebase-admin/app";
import { getAuth } from "firebase-admin/auth";
import { FieldValue, getFirestore } from "firebase-admin/firestore";
import { HttpsError, onCall } from "firebase-functions/v2/https";
import { randomUUID } from "node:crypto";

const adminRoles = new Set(["owner", "admin"]);
const staffRoles = new Set(["cashier", "supervisor", "manager", "admin"]);

interface ProvisionStaffClaimsRequest { uid?: unknown; organizationId?: unknown; role?: unknown; }
interface ProvisionStaffClaimsResponse { uid: string; organizationId: string; role: string; }

if (getApps().length === 0) initializeApp();

export const provisionStaffClaims = onCall<ProvisionStaffClaimsRequest, Promise<ProvisionStaffClaimsResponse>>(
  { region: "europe-west1" }, async (request) => {
    const callerToken = request.auth?.token;
    if (!callerToken) throw new HttpsError("unauthenticated", "Authentication is required.");
    if (typeof callerToken.role !== "string" || !adminRoles.has(callerToken.role)) {
      throw new HttpsError("permission-denied", "Only organization owners and admins can provision staff claims.");
    }
    const data = request.data;
    if (typeof data.uid !== "string" || !data.uid.trim() || typeof data.organizationId !== "string" || !data.organizationId.trim() || typeof data.role !== "string" || !staffRoles.has(data.role)) {
      throw new HttpsError("invalid-argument", "uid, organizationId, and a valid staff role are required.");
    }
    const uid = data.uid.trim(); const organizationId = data.organizationId.trim(); const role = data.role;
    if (callerToken.organizationId !== organizationId) throw new HttpsError("permission-denied", "The caller can only provision staff in their organization.");
    const staffSnapshot = await getFirestore().doc(`organizations/${organizationId}/staff/${uid}`).get();
    if (!staffSnapshot.exists) throw new HttpsError("not-found", "The target staff member does not exist in this organization.");
    if (staffSnapshot.data()?.organizationId !== organizationId) throw new HttpsError("failed-precondition", "The target staff record belongs to a different organization.");
    const active = staffSnapshot.data()?.active !== false;
    try {
      const user = await getAuth().getUser(uid);
      await getAuth().setCustomUserClaims(uid, { ...(user.customClaims ?? {}), organizationId, role, active });
    } catch (_) {
      throw new HttpsError("internal", "The staff claims could not be provisioned.");
    }
    return { uid, organizationId, role };
  },
);

interface CreateOrganizationOwnerRequest { businessName?: unknown; }
export const createOrganizationOwner = onCall<CreateOrganizationOwnerRequest, Promise<{ organizationId: string }>>(
  { region: "europe-west1" }, async (request) => {
    const uid = request.auth?.uid;
    const email = request.auth?.token.email;
    if (!uid || typeof email !== "string" || !email.includes("@")) throw new HttpsError("unauthenticated", "Authentication is required.");
    const businessName = typeof request.data.businessName === "string" ? request.data.businessName.trim() : "";
    if (businessName.length < 2 || businessName.length > 120) throw new HttpsError("invalid-argument", "A valid business name is required.");
    const organizationId = randomUUID();
    const db = getFirestore();
    const organizationRef = db.doc(`organizations/${organizationId}`);
    const staffRef = organizationRef.collection("staff").doc(uid);
    await db.runTransaction(async (transaction) => {
      transaction.create(organizationRef, { id: organizationId, name: businessName, ownerUid: uid, createdAt: FieldValue.serverTimestamp() });
      transaction.create(staffRef, { uid, email, organizationId, role: "owner", active: true, displayName: email.split("@")[0], createdAt: FieldValue.serverTimestamp() });
    });
    const user = await getAuth().getUser(uid);
    await getAuth().setCustomUserClaims(uid, { ...(user.customClaims ?? {}), organizationId, role: "owner", active: true });
    return { organizationId };
  },
);

interface CheckoutLineRequest { productId?: unknown; quantity?: unknown; }
interface CommitCheckoutRequest {
  idempotencyKey?: unknown; deviceId?: unknown; lines?: unknown; subtotalFCFA?: unknown; discountFCFA?: unknown;
  deliveryFCFA?: unknown; taxFCFA?: unknown; taxRateBasisPoints?: unknown; totalFCFA?: unknown;
  paymentMethod?: unknown; paymentReference?: unknown;
}
function integerField(value: unknown, field: string, minimum = 0): number {
  if (typeof value !== "number" || !Number.isSafeInteger(value) || value < minimum) throw new HttpsError("invalid-argument", `${field} must be an integer.`);
  return value;
}

export const commitCheckout = onCall<CommitCheckoutRequest, Promise<Record<string, unknown>>>(
  { region: "europe-west1" }, async (request) => {
    const token = request.auth?.token;
    if (!token || typeof token.organizationId !== "string") throw new HttpsError("unauthenticated", "Authentication is required.");
    if (typeof token.role !== "string" || !staffRoles.has(token.role)) throw new HttpsError("permission-denied", "A staff role is required.");
    const data = request.data;
    if (typeof data.idempotencyKey !== "string" || !data.idempotencyKey.trim()) throw new HttpsError("invalid-argument", "idempotencyKey is required.");
    if (typeof data.deviceId !== "string" || !data.deviceId.trim()) throw new HttpsError("invalid-argument", "deviceId is required.");
    if (!Array.isArray(data.lines) || data.lines.length === 0 || data.lines.length > 100) throw new HttpsError("invalid-argument", "One to 100 sale lines are required.");
    const organizationId = token.organizationId;
    const idempotencyKey = data.idempotencyKey.trim(); const deviceId = data.deviceId.trim();
    const methods = new Set(["cash", "mtn", "orange", "other"]);
    if (typeof data.paymentMethod !== "string" || !methods.has(data.paymentMethod)) throw new HttpsError("invalid-argument", "A valid payment method is required.");
    if (data.paymentMethod !== "cash" && (typeof data.paymentReference !== "string" || !data.paymentReference.trim())) throw new HttpsError("invalid-argument", "A payment reference is required.");
    const subtotalFCFA = integerField(data.subtotalFCFA, "subtotalFCFA");
    const discountFCFA = integerField(data.discountFCFA, "discountFCFA");
    const deliveryFCFA = integerField(data.deliveryFCFA, "deliveryFCFA");
    const taxFCFA = integerField(data.taxFCFA, "taxFCFA");
    const taxRateBasisPoints = integerField(data.taxRateBasisPoints, "taxRateBasisPoints");
    const totalFCFA = integerField(data.totalFCFA, "totalFCFA");
    const db = getFirestore();
    const transactionRef = db.doc(`organizations/${organizationId}/transactions/${idempotencyKey}`);
    const idempotencyRef = db.doc(`organizations/${organizationId}/checkout_idempotency/${idempotencyKey}`);
    const requests = data.lines as CheckoutLineRequest[];
    const lines = requests.map((line) => {
      if (typeof line.productId !== "string" || !line.productId.trim()) throw new HttpsError("invalid-argument", "Every line needs a productId.");
      return { productId: line.productId.trim(), quantity: integerField(line.quantity, "quantity", 1) };
    });
    try {
      return await db.runTransaction(async (transaction) => {
        const existing = await transaction.get(idempotencyRef);
        if (existing.exists) return existing.data()?.receipt as Record<string, unknown>;
        const snapshots = [];
        for (const line of lines) snapshots.push(await transaction.get(db.doc(`organizations/${organizationId}/products/${line.productId}`)));
        const receiptLines: Record<string, unknown>[] = [];
        const movementWrites: Array<{ productRef: FirebaseFirestore.DocumentReference; movementRef: FirebaseFirestore.DocumentReference; line: { productId: string; quantity: number } }> = [];
        for (let index = 0; index < lines.length; index += 1) {
          const line = lines[index]; const snapshot = snapshots[index];
          if (!snapshot.exists) throw new HttpsError("not-found", `Product ${line.productId} was not found.`);
          const product = snapshot.data() ?? {}; const stock = product.stockQty; const price = product.priceXAF;
          if (typeof stock !== "number" || !Number.isInteger(stock) || typeof price !== "number" || !Number.isInteger(price)) throw new HttpsError("failed-precondition", `Product ${line.productId} has invalid data.`);
          if (stock < line.quantity) throw new HttpsError("failed-precondition", `Insufficient stock for ${line.productId}.`);
          movementWrites.push({ productRef: snapshot.ref, movementRef: db.collection(`organizations/${organizationId}/inventory_adjustments`).doc(), line });
          receiptLines.push({ productId: line.productId, name: typeof product.name === "string" ? product.name : line.productId, quantity: line.quantity, unitPriceFCFA: price, subtotalFCFA: price * line.quantity });
        }
        for (const write of movementWrites) {
          transaction.update(write.productRef, { stockQty: FieldValue.increment(-write.line.quantity) });
          transaction.set(write.movementRef, { id: write.movementRef.id, organizationId, productId: write.line.productId, quantity: -write.line.quantity, type: "saleDeduction", actorId: request.auth!.uid, deviceId, occurredAt: FieldValue.serverTimestamp() });
        }
        const receipt = { saleId: idempotencyKey, receiptNumber: idempotencyKey, issuedAt: new Date().toISOString(), organizationId, cashierId: request.auth!.uid, deviceId, status: "completed", subtotalFCFA, discountFCFA, deliveryFCFA, taxFCFA, taxRateBasisPoints, totalFCFA, paymentMethod: data.paymentMethod, paymentReference: data.paymentMethod === "cash" ? null : data.paymentReference, lines: receiptLines };
        transaction.create(transactionRef, { ...receipt, createdAt: FieldValue.serverTimestamp() });
        transaction.create(idempotencyRef, { receipt, createdAt: FieldValue.serverTimestamp() });
        return receipt;
      });
    } catch (error) {
      if (error instanceof HttpsError) throw error;
      throw new HttpsError("internal", "Checkout could not be completed.");
    }
  },
);

