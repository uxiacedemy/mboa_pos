const assert = require('node:assert/strict');
const { aggregateCheckoutLines, checkoutRequestFingerprint } = require('../lib/index.js');

const lines = aggregateCheckoutLines([
  { productId: 'water', quantity: 2 },
  { productId: 'water', quantity: 3 },
  { productId: 'bread', quantity: 1 },
]);
assert.deepEqual(lines, [
  { productId: 'water', quantity: 5 },
  { productId: 'bread', quantity: 1 },
]);

const first = checkoutRequestFingerprint({
  schemaVersion: 1,
  idempotencyKey: 'sale-1',
  deviceId: 'device-1',
  lines: [{ productId: 'water', quantity: 2 }],
  discountFCFA: 0,
  deliveryFCFA: 0,
  taxFCFA: 0,
  taxRateBasisPoints: 1925,
  totalFCFA: 200,
  paymentMethod: 'cash',
  paymentReference: null,
});
const reordered = checkoutRequestFingerprint({
  paymentReference: null,
  paymentMethod: 'cash',
  totalFCFA: 200,
  taxRateBasisPoints: 1925,
  taxFCFA: 0,
  deliveryFCFA: 0,
  discountFCFA: 0,
  lines: [{ quantity: 2, productId: 'water' }],
  deviceId: 'device-1',
  idempotencyKey: 'sale-1',
  schemaVersion: 1,
});
const changed = checkoutRequestFingerprint({
  schemaVersion: 1,
  idempotencyKey: 'sale-1',
  deviceId: 'device-1',
  lines: [{ productId: 'water', quantity: 2 }],
  discountFCFA: 0,
  deliveryFCFA: 0,
  taxFCFA: 0,
  taxRateBasisPoints: 1925,
  totalFCFA: 300,
  paymentMethod: 'cash',
  paymentReference: null,
});
assert.equal(first, reordered);
assert.notEqual(first, changed);
console.log('Functions integrity unit tests passed');
