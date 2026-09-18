import { getApps, initializeApp } from "firebase-admin/app";
import { getAuth } from "firebase-admin/auth";
import { getFirestore } from "firebase-admin/firestore";
import { HttpsError, onCall } from "firebase-functions/v2/https";

const adminRoles = new Set(["owner", "admin"]);
const staffRoles = new Set(["cashier", "supervisor", "manager", "admin"]);

interface ProvisionStaffClaimsRequest {
  uid?: unknown;
  organizationId?: unknown;
  role?: unknown;
}

interface ProvisionStaffClaimsResponse {
  uid: string;
  organizationId: string;
  role: string;
}

if (getApps().length === 0) {
  initializeApp();
}

export const provisionStaffClaims = onCall<
  ProvisionStaffClaimsRequest,
  Promise<ProvisionStaffClaimsResponse>
>({ region: "europe-west1" }, async (request) => {
  const callerToken = request.auth?.token;
  if (!callerToken) {
    throw new HttpsError("unauthenticated", "Authentication is required.");
  }

  if (typeof callerToken.role !== "string" || !adminRoles.has(callerToken.role)) {
    throw new HttpsError(
      "permission-denied",
      "Only organization owners and admins can provision staff claims.",
    );
  }

  const data = request.data as ProvisionStaffClaimsRequest;
  if (
    typeof data.uid !== "string" ||
    data.uid.trim().length === 0 ||
    typeof data.organizationId !== "string" ||
    data.organizationId.trim().length === 0 ||
    typeof data.role !== "string" ||
    !staffRoles.has(data.role)
  ) {
    throw new HttpsError(
      "invalid-argument",
      "uid, organizationId, and a valid staff role are required.",
    );
  }

  const uid = data.uid.trim();
  const organizationId = data.organizationId.trim();
  const role = data.role;

  if (callerToken.organizationId !== organizationId) {
    throw new HttpsError(
      "permission-denied",
      "The caller can only provision staff in their organization.",
    );
  }

  const staffSnapshot = await getFirestore()
    .doc(`organizations/${organizationId}/staff/${uid}`)
    .get();
  if (!staffSnapshot.exists) {
    throw new HttpsError(
      "not-found",
      "The target staff member does not exist in this organization.",
    );
  }

  const staffData = staffSnapshot.data();
  if (staffData?.organizationId !== organizationId) {
    throw new HttpsError(
      "failed-precondition",
      "The target staff record belongs to a different organization.",
    );
  }

  try {
    const user = await getAuth().getUser(uid);
    await getAuth().setCustomUserClaims(uid, {
      ...user.customClaims,
      organizationId,
      role,
    });
  } catch (error) {
    if (error instanceof HttpsError) {
      throw error;
    }
    throw new HttpsError(
      "internal",
      "The staff claims could not be provisioned.",
    );
  }

  return { uid, organizationId, role };
});
