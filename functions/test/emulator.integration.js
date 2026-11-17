const assert = require('node:assert/strict');
const admin = require('firebase-admin');
const { checkoutRequestFingerprint } = require('../lib/index.js');

const projectId = 'mboapos';
const authPort = 9099;
const firestorePort = 8080;
const functionsPort = 5001;
const authApiKey = 'fake-api-key';

process.env.GCLOUD_PROJECT = projectId;
process.env.FIREBASE_CONFIG = JSON.stringify({ projectId });
process.env.FIREBASE_AUTH_EMULATOR_HOST = `127.0.0.1:${authPort}`;
process.env.FIRESTORE_EMULATOR_HOST = `127.0.0.1:${firestorePort}`;

if (admin.apps.length === 0) admin.initializeApp({ projectId });
const auth = admin.auth();
const db = admin.firestore();

async function signIn(email, password) {
  const response = await fetch(
    `http://127.0.0.1:${authPort}/identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${authApiKey}`,
    {
      method: 'POST',
      headers: { 'content-type': 'application/json' },
      body: JSON.stringify({ email, password, returnSecureToken: true }),
    },
  );
  const body = await response.text();
  assert.equal(response.ok, true, body);
  return JSON.parse(body).idToken;
}

async function call(name, token, data) {
  const response = await fetch(
    `http://127.0.0.1:${functionsPort}/${projectId}/europe-west1/${name}`,
    {
      method: 'POST',
      headers: {
        authorization: `Bearer ${token}`,
        'content-type': 'application/json',
      },
      body: JSON.stringify({ data }),
    },
  );
  const body = await response.json();
  return { response, body };
}

async function firestoreRequest(method, path, token, options = {}) {
  return fetch(
    `http://127.0.0.1:${firestorePort}/v1/projects/${projectId}/databases/(default)/documents/${path}${options.query ?? ''}`,
    {
      method,
      headers: {
        authorization: `Bearer ${token}`,
        ...(options.body ? { 'content-type': 'application/json' } : {}),
      },
      ...(options.body ? { body: JSON.stringify(options.body) } : {}),
    },
  );
}

function firestoreValue(value) {
  if (typeof value === 'boolean') return { booleanValue: value };
  if (typeof value === 'number') return { integerValue: String(value) };
  if (value === null) return { nullValue: null };
  return { stringValue: value };
}

async function patchFirestore(token, path, values) {
  const query = new URLSearchParams();
  for (const field of Object.keys(values)) query.append('updateMask.fieldPaths', field);
  return firestoreRequest('PATCH', path, token, {
    query: `?${query.toString()}`,
    body: { fields: Object.fromEntries(
      Object.entries(values).map(([field, value]) => [field, firestoreValue(value)]),
    ) },
  });
}

function payload({ key, deviceId, org, lines, subtotal, total, discount = 0 }) {
  const value = {
    schemaVersion: 1,
    idempotencyKey: key,
    deviceId,
    organizationId: org,
    actorId: 'cashier-uid',
    lines,
    subtotalFCFA: subtotal,
    discountFCFA: discount,
    deliveryFCFA: 0,
    taxFCFA: 0,
    taxRateBasisPoints: 1925,
    totalFCFA: total,
    paymentMethod: 'cash',
    paymentReference: null,
  };
  value.requestFingerprint = checkoutRequestFingerprint(value);
  return value;
}

async function provisionUser(uid, email, password) {
  const user = await auth.createUser({ uid, email, password });
  const token = await signIn(email, password);
  return { user, token };
}

async function main() {
  const suffix = `${Date.now()}`;
  const ownerEmail = `owner-${suffix}@example.test`;
  const ownerPassword = 'CorrectHorseBatteryStaple1!';
  const { user: owner, token: ownerToken } = await provisionUser(
    `owner-${suffix}`,
    ownerEmail,
    ownerPassword,
  );

  const firstOwner = await call('createOrganizationOwner', ownerToken, {
    businessName: 'Recovery Shop',
  });
  assert.equal(firstOwner.response.ok, true, JSON.stringify(firstOwner.body));
  const secondOwner = await call('createOrganizationOwner', ownerToken, {
    businessName: 'Recovery Shop',
  });
  assert.equal(secondOwner.response.ok, true, JSON.stringify(secondOwner.body));
  assert.equal(secondOwner.body.result.organizationId, firstOwner.body.result.organizationId);
  const organizationId = firstOwner.body.result.organizationId;
  assert.equal((await db.doc(`organizations/${organizationId}`).get()).exists, true);
  assert.equal((await db.doc(`organizations/${organizationId}/staff/${owner.uid}`).get()).exists, true);
  assert.equal((await db.doc(`owner_provisioning/${owner.uid}`).get()).data().stage, 'ready');

  const cashierUid = 'cashier-uid';
  const cashierEmail = `cashier-${suffix}@example.test`;
  const { token: cashierToken } = await provisionUser(cashierUid, cashierEmail, 'CashierPassword1!');
  await auth.setCustomUserClaims(cashierUid, {
    organizationId,
    role: 'cashier',
    active: true,
  });
  await db.doc(`organizations/${organizationId}/staff/${cashierUid}`).set({
    uid: cashierUid,
    organizationId,
    role: 'cashier',
    active: true,
  });
  const activeOwnerToken = await signIn(ownerEmail, ownerPassword);
  const provisionClaims = await call('provisionStaffClaims', activeOwnerToken, {
    uid: cashierUid,
    organizationId,
    role: 'cashier',
  });
  assert.equal(provisionClaims.response.ok, true, JSON.stringify(provisionClaims.body));
  const mismatchedRoleClaims = await call('provisionStaffClaims', activeOwnerToken, {
    uid: cashierUid,
    organizationId,
    role: 'manager',
  });
  assert.equal(mismatchedRoleClaims.response.ok, false);
  assert.equal(mismatchedRoleClaims.body.error.status, 'FAILED_PRECONDITION');
  await db.doc(`organizations/${organizationId}/staff/${owner.uid}`).update({
    active: false,
  });
  const inactiveOwnerClaims = await call('provisionStaffClaims', activeOwnerToken, {
    uid: cashierUid,
    organizationId,
    role: 'cashier',
  });
  assert.equal(inactiveOwnerClaims.response.ok, false);
  assert.equal(inactiveOwnerClaims.body.error.status, 'PERMISSION_DENIED');
  await db.doc(`organizations/${organizationId}/staff/${owner.uid}`).update({
    active: true,
  });
  const refreshedCashierToken = await signIn(cashierEmail, 'CashierPassword1!');

  const product = db.doc(`organizations/${organizationId}/products/water`);
  await product.set({
    id: 'water',
    organizationId,
    name: 'Water',
    priceXAF: 100,
    stockQty: 10,
    active: true,
  });
  const secondProduct = db.doc(`organizations/${organizationId}/products/bread`);
  await secondProduct.set({
    id: 'bread',
    organizationId,
    name: 'Bread',
    priceXAF: 200,
    stockQty: 10,
    active: true,
  });

  const settingsPath = `organizations/${organizationId}/settings/general`;
  const cashierTaxUpdate = await patchFirestore(refreshedCashierToken, settingsPath, {
    taxEnabled: true,
    taxRateBasisPoints: 2500,
  });
  assert.equal(cashierTaxUpdate.status, 200);
  const cashierProfileUpdate = await patchFirestore(refreshedCashierToken, settingsPath, {
    businessName: 'Unauthorized Name',
  });
  assert.equal(cashierProfileUpdate.status, 403);
  const cashierFiscalUpdate = await patchFirestore(refreshedCashierToken, settingsPath, {
    fiscalProfileVerified: true,
  });
  assert.equal(cashierFiscalUpdate.status, 403);
  const cashierMixedUpdate = await patchFirestore(refreshedCashierToken, settingsPath, {
    taxEnabled: true,
    taxRateBasisPoints: 2500,
    organizationNiu: 'UNAUTHORIZED',
  });
  assert.equal(cashierMixedUpdate.status, 403);
  const managerProductUpdate = await patchFirestore(
    refreshedCashierToken,
    `organizations/${organizationId}/products/water`,
    { priceXAF: 101 },
  );
  assert.equal(managerProductUpdate.status, 403);
  const resetTax = await patchFirestore(refreshedCashierToken, settingsPath, {
    taxEnabled: false,
    taxRateBasisPoints: 1925,
  });
  assert.equal(resetTax.status, 200);

  const duplicate = payload({
    key: `duplicate-${suffix}`,
    deviceId: 'device-a',
    org: organizationId,
    lines: [
      { productId: 'water', quantity: 2 },
      { productId: 'water', quantity: 3 },
    ],
    subtotal: 500,
    total: 500,
  });
  const duplicateResult = await call('commitCheckout', refreshedCashierToken, duplicate);
  assert.equal(duplicateResult.response.ok, true, JSON.stringify(duplicateResult.body));
  assert.match(duplicateResult.body.result.receiptNumber, /^\d{8}-device-a-00001$/);
  assert.equal(Number.isNaN(Date.parse(duplicateResult.body.result.issuedAt)), false);
  assert.equal((await product.get()).data().stockQty, 5);
  const replay = await call('commitCheckout', refreshedCashierToken, duplicate);
  assert.equal(replay.response.ok, true);
  assert.equal((await product.get()).data().stockQty, 5);
  const changed = { ...duplicate, totalFCFA: 400 };
  changed.requestFingerprint = checkoutRequestFingerprint(changed);
  const conflict = await call('commitCheckout', refreshedCashierToken, changed);
  assert.equal(conflict.response.ok, false);
  assert.equal(conflict.body.error.status, 'ALREADY_EXISTS');

  const insufficient = payload({
    key: `insufficient-${suffix}`,
    deviceId: 'device-a',
    org: organizationId,
    lines: [
      { productId: 'water', quantity: 3 },
      { productId: 'water', quantity: 3 },
    ],
    subtotal: 600,
    total: 600,
  });
  const insufficientResult = await call('commitCheckout', refreshedCashierToken, insufficient);
  assert.equal(insufficientResult.response.ok, false);
  assert.equal((await product.get()).data().stockQty, 5);

  const multipleProducts = payload({
    key: `multiple-${suffix}`,
    deviceId: 'device-a',
    org: organizationId,
    lines: [
      { productId: 'water', quantity: 1 },
      { productId: 'bread', quantity: 2 },
    ],
    subtotal: 500,
    total: 500,
  });
  const multipleProductsResult = await call('commitCheckout', refreshedCashierToken, multipleProducts);
  assert.equal(multipleProductsResult.response.ok, true, JSON.stringify(multipleProductsResult.body));
  assert.equal((await product.get()).data().stockQty, 4);
  assert.equal((await secondProduct.get()).data().stockQty, 8);

  const stalePrice = payload({
    key: `stale-price-${suffix}`,
    deviceId: 'device-a',
    org: organizationId,
    lines: [{ productId: 'water', quantity: 1 }],
    subtotal: 99,
    total: 99,
  });
  const stalePriceResult = await call('commitCheckout', refreshedCashierToken, stalePrice);
  assert.equal(stalePriceResult.response.ok, false);
  assert.equal((await product.get()).data().stockQty, 4);

  const invalidDiscount = payload({
    key: `invalid-discount-${suffix}`,
    deviceId: 'device-a',
    org: organizationId,
    lines: [{ productId: 'water', quantity: 1 }],
    subtotal: 100,
    total: -1,
    discount: 101,
  });
  const invalidDiscountResult = await call('commitCheckout', refreshedCashierToken, invalidDiscount);
  assert.equal(invalidDiscountResult.response.ok, false);

  const invalidTax = payload({
    key: `invalid-tax-${suffix}`,
    deviceId: 'device-a',
    org: organizationId,
    lines: [{ productId: 'water', quantity: 1 }],
    subtotal: 100,
    total: 101,
  });
  invalidTax.taxFCFA = 1;
  invalidTax.requestFingerprint = checkoutRequestFingerprint(invalidTax);
  const invalidTaxResult = await call('commitCheckout', refreshedCashierToken, invalidTax);
  assert.equal(invalidTaxResult.response.ok, false);
  assert.equal((await product.get()).data().stockQty, 4);

  const enableTax = await patchFirestore(refreshedCashierToken, settingsPath, {
    taxEnabled: true,
    taxRateBasisPoints: 2500,
  });
  assert.equal(enableTax.status, 200);
  const authoritativeTax = payload({
    key: `tax-${suffix}`,
    deviceId: 'device-a',
    org: organizationId,
    lines: [{ productId: 'water', quantity: 1 }],
    subtotal: 100,
    total: 125,
  });
  authoritativeTax.taxFCFA = 25;
  authoritativeTax.taxRateBasisPoints = 2500;
  authoritativeTax.requestFingerprint = checkoutRequestFingerprint(authoritativeTax);
  const authoritativeTaxResult = await call(
    'commitCheckout',
    refreshedCashierToken,
    authoritativeTax,
  );
  assert.equal(authoritativeTaxResult.response.ok, true);
  assert.equal(authoritativeTaxResult.body.result.taxFCFA, 25);
  assert.equal(authoritativeTaxResult.body.result.taxRateBasisPoints, 2500);
  assert.equal(authoritativeTaxResult.body.result.isFiscal, false);
  const disableTax = await patchFirestore(refreshedCashierToken, settingsPath, {
    taxEnabled: false,
    taxRateBasisPoints: 1925,
  });
  assert.equal(disableTax.status, 200);

  await product.update({ stockQty: 10 });
  const concurrentA = payload({ key: `concurrent-a-${suffix}`, deviceId: 'device-a', org: organizationId, lines: [{ productId: 'water', quantity: 6 }], subtotal: 600, total: 600 });
  const concurrentB = payload({ key: `concurrent-b-${suffix}`, deviceId: 'device-b', org: organizationId, lines: [{ productId: 'water', quantity: 6 }], subtotal: 600, total: 600 });
  const concurrentResults = await Promise.all([
    call('commitCheckout', refreshedCashierToken, concurrentA),
    call('commitCheckout', refreshedCashierToken, concurrentB),
  ]);
  assert.equal(concurrentResults.filter((item) => item.response.ok).length, 1);
  assert.equal((await product.get()).data().stockQty, 4);

  const crossTenant = payload({ key: `cross-${suffix}`, deviceId: 'device-a', org: 'other-org', lines: [{ productId: 'water', quantity: 1 }], subtotal: 100, total: 100 });
  const crossTenantResult = await call('commitCheckout', refreshedCashierToken, crossTenant);
  assert.equal(crossTenantResult.response.ok, false);
  assert.equal(crossTenantResult.body.error.status, 'PERMISSION_DENIED');

  const crossTenantRead = await firestoreRequest(
    'GET',
    'organizations/other-org/products/water',
    refreshedCashierToken,
  );
  assert.equal(crossTenantRead.status, 403);
  const deleteCompletedSale = await firestoreRequest(
    'DELETE',
    `organizations/${organizationId}/transactions/${duplicate.idempotencyKey}`,
    refreshedCashierToken,
  );
  assert.equal(deleteCompletedSale.status, 403);

  await db.doc(`organizations/${organizationId}/staff/${cashierUid}`).update({
    active: false,
  });
  const staleActiveCheckout = await call(
    'commitCheckout',
    refreshedCashierToken,
    duplicate,
  );
  assert.equal(staleActiveCheckout.response.ok, false);
  assert.equal(staleActiveCheckout.body.error.status, 'PERMISSION_DENIED');
  const staleActiveRead = await firestoreRequest(
    'GET',
    `organizations/${organizationId}/products/water`,
    refreshedCashierToken,
  );
  assert.equal(staleActiveRead.status, 403);
  await db.doc(`organizations/${organizationId}/staff/${cashierUid}`).update({
    active: true,
  });

  await auth.setCustomUserClaims(cashierUid, {
    organizationId,
    role: 'cashier',
    active: false,
  });
  const inactiveToken = await signIn(cashierEmail, 'CashierPassword1!');
  const inactiveCheckout = await call('commitCheckout', inactiveToken, duplicate);
  assert.equal(inactiveCheckout.response.ok, false);
  assert.equal(inactiveCheckout.body.error.status, 'PERMISSION_DENIED');
  const inactiveRead = await firestoreRequest(
    'GET',
    `organizations/${organizationId}/products/water`,
    inactiveToken,
  );
  assert.equal(inactiveRead.status, 403);

  await auth.setCustomUserClaims(cashierUid, {
    organizationId,
    role: 'customer',
    active: true,
  });
  const invalidRoleToken = await signIn(cashierEmail, 'CashierPassword1!');
  const invalidRoleRead = await firestoreRequest(
    'GET',
    `organizations/${organizationId}/products/water`,
    invalidRoleToken,
  );
  assert.equal(invalidRoleRead.status, 403);
  const invalidRoleCheckout = await call('commitCheckout', invalidRoleToken, duplicate);
  assert.equal(invalidRoleCheckout.response.ok, false);
  assert.equal(invalidRoleCheckout.body.error.status, 'PERMISSION_DENIED');

  console.log('Firebase Emulator Gate 1B integration tests passed');
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
