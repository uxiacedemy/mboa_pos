import { getApps, initializeApp } from "firebase-admin/app";
import { getAuth } from "firebase-admin/auth";
import { FieldValue, Timestamp, getFirestore } from "firebase-admin/firestore";
import { HttpsError, onCall } from "firebase-functions/v2/https";
import { createHash } from "node:crypto";

const adminRoles = new Set(["owner", "admin"]);
const staffRoles = new Set(["owner", "cashier", "supervisor", "manager", "admin"]);
const defaultTaxRateBasisPoints = 1925;

function cameroonDayKey(date: Date): string {
  const parts = new Intl.DateTimeFormat("en", {
    timeZone: "Africa/Douala",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  }).formatToParts(date);
  const value = Object.fromEntries(parts.map((part) => [part.type, part.value]));
  return `${value.year}${value.month}${value.day}`;
}

export function formatReceiptNumber(
  date: Date,
  terminalId: string,
  sequence: number,
): string {
  if (!/^[A-Za-z0-9_-]{1,80}$/.test(terminalId)) {
    throw new Error("A valid terminal ID is required.");
  }
  if (!Number.isSafeInteger(sequence) || sequence < 1) {
    throw new Error("The receipt sequence must be a positive integer.");
  }
  return `${cameroonDayKey(date)}-${terminalId}-${String(sequence).padStart(5, "0")}`;
}

interface ProvisionStaffClaimsRequest { uid?: unknown; organizationId?: unknown; role?: unknown; }
interface ProvisionStaffClaimsResponse { uid: string; organizationId: string; role: string; }

if (getApps().length === 0) initializeApp();

export const provisionStaffClaims = onCall<ProvisionStaffClaimsRequest, Promise<ProvisionStaffClaimsResponse>>(
  { region: "europe-west1" }, async (request) => {
    const callerToken = request.auth?.token;
    const callerUid = request.auth?.uid;
    if (!callerToken || !callerUid) throw new HttpsError("unauthenticated", "Authentication is required.");
    if (callerToken.active !== true) throw new HttpsError("permission-denied", "The caller account is inactive.");
    if (typeof callerToken.role !== "string" || !adminRoles.has(callerToken.role)) {
      throw new HttpsError("permission-denied", "Only organization owners and admins can provision staff claims.");
    }
    const data = request.data;
    if (typeof data.uid !== "string" || !data.uid.trim() || typeof data.organizationId !== "string" || !data.organizationId.trim() || typeof data.role !== "string" || !staffRoles.has(data.role)) {
      throw new HttpsError("invalid-argument", "uid, organizationId, and a valid staff role are required.");
    }
    const uid = data.uid.trim(); const organizationId = data.organizationId.trim(); const role = data.role;
    if (callerToken.organizationId !== organizationId) throw new HttpsError("permission-denied", "The caller can only provision staff in their organization.");
    const db = getFirestore();
    const [callerSnapshot, staffSnapshot] = await Promise.all([
      db.doc(`organizations/${organizationId}/staff/${callerUid}`).get(),
      db.doc(`organizations/${organizationId}/staff/${uid}`).get(),
    ]);
    const caller = callerSnapshot.data() ?? {};
    if (
      !callerSnapshot.exists ||
      caller.organizationId !== organizationId ||
      caller.role !== callerToken.role ||
      caller.active !== true
    ) {
      throw new HttpsError("permission-denied", "The caller membership is inactive or invalid.");
    }
    if (!staffSnapshot.exists) throw new HttpsError("not-found", "The target staff member does not exist in this organization.");
    if (staffSnapshot.data()?.organizationId !== organizationId) throw new HttpsError("failed-precondition", "The target staff record belongs to a different organization.");
    if (staffSnapshot.data()?.role !== role) throw new HttpsError("failed-precondition", "The requested role does not match the staff record.");
    const active = staffSnapshot.data()?.active === true;
    if (!active) throw new HttpsError("failed-precondition", "The target staff member is inactive.");
    try {
      const user = await getAuth().getUser(uid);
      await getAuth().setCustomUserClaims(uid, { ...(user.customClaims ?? {}), organizationId, role, active });
    } catch {
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
    // The UID-derived key makes provisioning resumable. A retry after a
    // failed claim update addresses the same organization and staff record.
    const organizationId = `owner_${uid}`;
    const db = getFirestore();
    const organizationRef = db.doc(`organizations/${organizationId}`);
    const staffRef = organizationRef.collection("staff").doc(uid);
    const settingsRef = organizationRef.collection("settings").doc("general");
    const provisioningRef = db.doc(`owner_provisioning/${uid}`);
    await db.runTransaction(async (transaction) => {
      const [organizationSnapshot, staffSnapshot, provisioningSnapshot, settingsSnapshot] = await Promise.all([
        transaction.get(organizationRef),
        transaction.get(staffRef),
        transaction.get(provisioningRef),
        transaction.get(settingsRef),
      ]);
      if (provisioningSnapshot.exists && provisioningSnapshot.data()?.organizationId !== organizationId) {
        throw new HttpsError("failed-precondition", "This owner already has another organization.");
      }
      if (!organizationSnapshot.exists) {
        transaction.create(organizationRef, { id: organizationId, name: businessName, ownerUid: uid, createdAt: FieldValue.serverTimestamp() });
      } else if (organizationSnapshot.data()?.ownerUid !== uid) {
        throw new HttpsError("permission-denied", "The organization owner does not match this account.");
      }
      if (!staffSnapshot.exists) {
        transaction.create(staffRef, { uid, email, organizationId, role: "owner", active: true, displayName: email.split("@")[0], createdAt: FieldValue.serverTimestamp() });
      } else if (staffSnapshot.data()?.organizationId !== organizationId || staffSnapshot.data()?.role !== "owner") {
        throw new HttpsError("failed-precondition", "The owner membership is not valid.");
      }
      if (!settingsSnapshot.exists) {
        transaction.create(settingsRef, {
          organizationId,
          businessName,
          organizationNiu: null,
          address: null,
          taxEnabled: false,
          taxRateBasisPoints: defaultTaxRateBasisPoints,
          fiscalProfileVerified: false,
          updatedAt: FieldValue.serverTimestamp(),
        });
      }
      const provisioning = { uid, email, organizationId, businessName, stage: "claimsPending", updatedAt: FieldValue.serverTimestamp() };
      if (provisioningSnapshot.exists) transaction.set(provisioningRef, provisioning, { merge: true });
      else transaction.create(provisioningRef, { ...provisioning, createdAt: FieldValue.serverTimestamp() });
    });
    const user = await getAuth().getUser(uid);
    await getAuth().setCustomUserClaims(uid, { ...(user.customClaims ?? {}), organizationId, role: "owner", active: true });
    await provisioningRef.set({ stage: "ready", updatedAt: FieldValue.serverTimestamp() }, { merge: true });
    return { organizationId };
  },
);

interface CheckoutLineRequest { productId?: unknown; quantity?: unknown; }
interface CommitCheckoutRequest {
  idempotencyKey?: unknown; requestFingerprint?: unknown; deviceId?: unknown; organizationId?: unknown; actorId?: unknown; lines?: unknown; subtotalFCFA?: unknown; discountFCFA?: unknown;
  deliveryFCFA?: unknown; taxFCFA?: unknown; taxRateBasisPoints?: unknown; totalFCFA?: unknown;
  paymentMethod?: unknown; paymentReference?: unknown;
}
function integerField(value: unknown, field: string, minimum = 0): number {
  if (typeof value !== "number" || !Number.isSafeInteger(value) || value < minimum) throw new HttpsError("invalid-argument", `${field} must be an integer.`);
  return value;
}

function canonicalJson(value: unknown): string {
  if (Array.isArray(value)) return `[${value.map(canonicalJson).join(",")}]`;
  if (value !== null && typeof value === "object") {
    return `{${Object.keys(value as Record<string, unknown>).sort().map((key) => `${JSON.stringify(key)}:${canonicalJson((value as Record<string, unknown>)[key])}`).join(",")}}`;
  }
  return JSON.stringify(value);
}

function fingerprint(value: unknown): string {
  return createHash("sha256").update(canonicalJson(value)).digest("hex");
}

export function aggregateCheckoutLines(requests: CheckoutLineRequest[]): Array<{ productId: string; quantity: number }> {
  const quantities = new Map<string, number>();
  for (const line of requests) {
    if (typeof line.productId !== "string" || !line.productId.trim()) throw new Error("Every line needs a productId.");
    const productId = line.productId.trim();
    const quantity = integerField(line.quantity, "quantity", 1);
    const aggregate = (quantities.get(productId) ?? 0) + quantity;
    if (!Number.isSafeInteger(aggregate)) throw new Error("The requested quantity is too large.");
    quantities.set(productId, aggregate);
  }
  return [...quantities.entries()].map(([productId, quantity]) => ({ productId, quantity }));
}

export function checkoutRequestFingerprint(value: unknown): string {
  const payload = value as Record<string, unknown>;
  const quantities = new Map<string, number>();
  for (const line of (payload.lines as CheckoutLineRequest[])) {
    if (typeof line.productId === "string" && typeof line.quantity === "number") {
      quantities.set(line.productId, (quantities.get(line.productId) ?? 0) + line.quantity);
    }
  }
  return fingerprint({
    schemaVersion: payload.schemaVersion,
    idempotencyKey: payload.idempotencyKey,
    deviceId: payload.deviceId,
    lines: [...quantities.entries()].map(([productId, quantity]) => ({ productId, quantity })),
    discountFCFA: payload.discountFCFA,
    deliveryFCFA: payload.deliveryFCFA,
    taxFCFA: payload.taxFCFA,
    taxRateBasisPoints: payload.taxRateBasisPoints,
    totalFCFA: payload.totalFCFA,
    paymentMethod: payload.paymentMethod,
    paymentReference: payload.paymentReference,
  });
}

export const commitCheckout = onCall<CommitCheckoutRequest, Promise<Record<string, unknown>>>(
  { region: "europe-west1" }, async (request) => {
    const token = request.auth?.token;
    if (!token || typeof token.organizationId !== "string") throw new HttpsError("unauthenticated", "Authentication is required.");
    if (token.active !== true) throw new HttpsError("permission-denied", "The signed-in account is inactive.");
    if (typeof token.role !== "string" || !staffRoles.has(token.role)) throw new HttpsError("permission-denied", "A staff role is required.");
    const data = request.data;
    if (data.organizationId !== undefined && data.organizationId !== token.organizationId) throw new HttpsError("permission-denied", "The checkout organization does not match the signed-in organization.");
    if (data.actorId !== undefined && data.actorId !== request.auth!.uid) throw new HttpsError("permission-denied", "The checkout actor does not match the signed-in user.");
    if (typeof data.idempotencyKey !== "string" || !data.idempotencyKey.trim()) throw new HttpsError("invalid-argument", "idempotencyKey is required.");
    if (typeof data.requestFingerprint !== "string" || !/^[a-f0-9]{64}$/.test(data.requestFingerprint)) throw new HttpsError("invalid-argument", "requestFingerprint is required.");
    if (typeof data.deviceId !== "string" || !data.deviceId.trim()) throw new HttpsError("invalid-argument", "deviceId is required.");
    if (!/^[A-Za-z0-9_-]{1,80}$/.test(data.deviceId.trim())) throw new HttpsError("invalid-argument", "deviceId contains unsupported characters.");
    if (!Array.isArray(data.lines) || data.lines.length === 0 || data.lines.length > 100) throw new HttpsError("invalid-argument", "One to 100 sale lines are required.");
    const organizationId = token.organizationId;
    const idempotencyKey = data.idempotencyKey.trim(); const deviceId = data.deviceId.trim();
    const methods = new Set(["cash", "mtn", "orange", "other"]);
    if (typeof data.paymentMethod !== "string" || !methods.has(data.paymentMethod)) throw new HttpsError("invalid-argument", "A valid payment method is required.");
    if (data.paymentMethod !== "cash" && (typeof data.paymentReference !== "string" || !data.paymentReference.trim())) throw new HttpsError("invalid-argument", "A payment reference is required.");
    const submittedSubtotalFCFA = integerField(data.subtotalFCFA, "subtotalFCFA");
    const discountFCFA = integerField(data.discountFCFA, "discountFCFA");
    const deliveryFCFA = integerField(data.deliveryFCFA, "deliveryFCFA");
    const taxFCFA = integerField(data.taxFCFA, "taxFCFA");
    const taxRateBasisPoints = integerField(data.taxRateBasisPoints, "taxRateBasisPoints");
    const submittedTotalFCFA = integerField(data.totalFCFA, "totalFCFA");
    const db = getFirestore();
    const transactionRef = db.doc(`organizations/${organizationId}/transactions/${idempotencyKey}`);
    const idempotencyRef = db.doc(`organizations/${organizationId}/checkout_idempotency/${idempotencyKey}`);
    const settingsRef = db.doc(`organizations/${organizationId}/settings/general`);
    const staffRef = db.doc(`organizations/${organizationId}/staff/${request.auth!.uid}`);
    const issuedAt = Timestamp.now();
    const dayKey = cameroonDayKey(issuedAt.toDate());
    const counterRef = db.doc(`organizations/${organizationId}/receipt_counters/${dayKey}_${deviceId}`);
    const requests = data.lines as CheckoutLineRequest[];
    let lines: Array<{ productId: string; quantity: number }>;
    try {
      lines = aggregateCheckoutLines(requests);
    } catch (error) {
      throw new HttpsError("invalid-argument", error instanceof Error ? error.message : "Invalid checkout lines.");
    }
    const requestFingerprint = checkoutRequestFingerprint({
      schemaVersion: 1,
      idempotencyKey,
      deviceId,
      lines,
      discountFCFA,
      deliveryFCFA,
      taxFCFA,
      taxRateBasisPoints,
      totalFCFA: submittedTotalFCFA,
      paymentMethod: data.paymentMethod,
      paymentReference: data.paymentMethod === "cash" ? null : data.paymentReference,
    });
    if (data.requestFingerprint !== requestFingerprint) throw new HttpsError("invalid-argument", "The checkout request fingerprint is invalid.");
    try {
      return await db.runTransaction(async (transaction) => {
        const [existing, staffSnapshot] = await Promise.all([
          transaction.get(idempotencyRef),
          transaction.get(staffRef),
        ]);
        const staff = staffSnapshot.data() ?? {};
        if (
          !staffSnapshot.exists ||
          staff.organizationId !== organizationId ||
          staff.role !== token.role ||
          staff.active !== true
        ) {
          throw new HttpsError("permission-denied", "The staff membership is inactive or invalid.");
        }
        if (existing.exists) {
          const existingData = existing.data() ?? {};
          if (existingData.requestFingerprint !== requestFingerprint) throw new HttpsError("already-exists", "This checkout key was already used for different sale data.");
          return existingData.receipt as Record<string, unknown>;
        }
        const [settingsSnapshot, counterSnapshot] = await Promise.all([
          transaction.get(settingsRef),
          transaction.get(counterRef),
        ]);
        if (!settingsSnapshot.exists) {
          throw new HttpsError("failed-precondition", "Shop settings are not configured.");
        }
        const settings = settingsSnapshot.data() ?? {};
        const taxEnabled = settings.taxEnabled === true;
        const configuredTaxRate = settings.taxRateBasisPoints;
        if (
          configuredTaxRate !== null
          && (typeof configuredTaxRate !== "number" || !Number.isSafeInteger(configuredTaxRate) || configuredTaxRate < 0 || configuredTaxRate > 10000)
        ) {
          throw new HttpsError("failed-precondition", "The configured tax rate is invalid.");
        }
        const taxRateBasisPoints = configuredTaxRate === null || configuredTaxRate === undefined
          ? defaultTaxRateBasisPoints
          : configuredTaxRate as number;
        if (data.taxRateBasisPoints !== taxRateBasisPoints) {
          throw new HttpsError("failed-precondition", "The configured tax rate changed. Refresh checkout and try again.");
        }
        const snapshots = [];
        for (const line of lines) snapshots.push(await transaction.get(db.doc(`organizations/${organizationId}/products/${line.productId}`)));
        const receiptLines: Record<string, unknown>[] = [];
        let calculatedSubtotalFCFA = 0;
        const movementWrites: Array<{ productRef: FirebaseFirestore.DocumentReference; movementRef: FirebaseFirestore.DocumentReference; line: { productId: string; quantity: number } }> = [];
        for (let index = 0; index < lines.length; index += 1) {
          const line = lines[index]; const snapshot = snapshots[index];
          if (!snapshot.exists) throw new HttpsError("not-found", `Product ${line.productId} was not found.`);
          const product = snapshot.data() ?? {}; const stock = product.stockQty; const price = product.priceXAF;
          if (product.active === false) throw new HttpsError("failed-precondition", `Product ${line.productId} is inactive.`);
          if (typeof stock !== "number" || !Number.isInteger(stock) || typeof price !== "number" || !Number.isInteger(price)) throw new HttpsError("failed-precondition", `Product ${line.productId} has invalid data.`);
          if (stock < line.quantity) throw new HttpsError("failed-precondition", `Insufficient stock for ${line.productId}.`);
          movementWrites.push({ productRef: snapshot.ref, movementRef: db.collection(`organizations/${organizationId}/inventory_adjustments`).doc(), line });
          const lineSubtotalFCFA = price * line.quantity;
          if (!Number.isSafeInteger(lineSubtotalFCFA)) throw new HttpsError("invalid-argument", "The checkout line total is too large.");
          calculatedSubtotalFCFA += lineSubtotalFCFA;
          receiptLines.push({ productId: line.productId, name: typeof product.name === "string" ? product.name : line.productId, quantity: line.quantity, unitPriceFCFA: price, subtotalFCFA: lineSubtotalFCFA });
        }
        if (submittedSubtotalFCFA !== calculatedSubtotalFCFA) {
          throw new HttpsError("invalid-argument", "The checkout subtotal does not match current product prices.");
        }
        if (discountFCFA > calculatedSubtotalFCFA) {
          throw new HttpsError("invalid-argument", "The discount cannot exceed the subtotal.");
        }
        const taxableFCFA = Math.max(0, calculatedSubtotalFCFA - discountFCFA);
        const calculatedTaxFCFA = taxEnabled
          ? Math.floor((taxableFCFA * taxRateBasisPoints + 5000) / 10000)
          : 0;
        const calculatedTotalFCFA = taxableFCFA + deliveryFCFA + calculatedTaxFCFA;
        if (taxFCFA !== calculatedTaxFCFA) {
          throw new HttpsError("invalid-argument", "The checkout tax does not match the configured rate.");
        }
        if (submittedTotalFCFA !== calculatedTotalFCFA) {
          throw new HttpsError("invalid-argument", "The checkout total is invalid.");
        }
        const nextSequence = (counterSnapshot.data()?.nextSequence as number | undefined ?? 0) + 1;
        if (!Number.isSafeInteger(nextSequence) || nextSequence < 1) {
          throw new HttpsError("failed-precondition", "The receipt sequence is invalid.");
        }
        const receiptNumber = formatReceiptNumber(issuedAt.toDate(), deviceId, nextSequence);
        for (const write of movementWrites) {
          transaction.update(write.productRef, { stockQty: FieldValue.increment(-write.line.quantity) });
          transaction.set(write.movementRef, { id: write.movementRef.id, organizationId, productId: write.line.productId, quantity: -write.line.quantity, type: "saleDeduction", actorId: request.auth!.uid, deviceId, occurredAt: FieldValue.serverTimestamp() });
        }
        transaction.set(counterRef, {
          organizationId,
          terminalId: deviceId,
          businessDay: dayKey,
          nextSequence,
          updatedAt: FieldValue.serverTimestamp(),
        });
        const receipt = {
          saleId: idempotencyKey,
          receiptNumber,
          issuedAt: issuedAt.toDate().toISOString(),
          organizationId,
          organizationName: settings.businessName ?? "",
          organizationNiu: settings.organizationNiu ?? "",
          organizationAddress: settings.address ?? "",
          fiscalProfileVerified: settings.fiscalProfileVerified === true,
          isFiscal: settings.fiscalProfileVerified === true,
          cashierId: request.auth!.uid,
          deviceId,
          status: "completed",
          subtotalFCFA: calculatedSubtotalFCFA,
          discountFCFA,
          deliveryFCFA,
          taxFCFA: calculatedTaxFCFA,
          taxRateBasisPoints: taxEnabled ? taxRateBasisPoints : 0,
          totalFCFA: calculatedTotalFCFA,
          paymentMethod: data.paymentMethod,
          paymentReference: data.paymentMethod === "cash" ? null : data.paymentReference,
          lines: receiptLines,
        };
        transaction.create(transactionRef, {
          ...receipt,
          issuedAt: issuedAt,
          createdAt: FieldValue.serverTimestamp(),
        });
        transaction.create(idempotencyRef, { receipt, requestFingerprint, schemaVersion: 1, createdAt: FieldValue.serverTimestamp() });
        return receipt;
      });
    } catch (error) {
      if (error instanceof HttpsError) throw error;
      throw new HttpsError("internal", "Checkout could not be completed.");
    }
  },
);

