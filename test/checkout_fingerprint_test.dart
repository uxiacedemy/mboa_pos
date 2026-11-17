import 'package:flutter_test/flutter_test.dart';
import 'package:mboa_pos/features/sales/domain/checkout_fingerprint.dart';

void main() {
  test('fingerprint is stable for equivalent checkout payloads', () {
    final first = checkoutRequestFingerprint({
      'schemaVersion': 1,
      'idempotencyKey': 'sale-1',
      'deviceId': 'device-1',
      'lines': [
        {'productId': 'water', 'quantity': 2},
      ],
      'discountFCFA': 0,
      'deliveryFCFA': 0,
      'taxFCFA': 0,
      'taxRateBasisPoints': 1925,
      'totalFCFA': 700,
      'paymentMethod': 'cash',
      'paymentReference': null,
    });
    final second = checkoutRequestFingerprint({
      'paymentReference': null,
      'paymentMethod': 'cash',
      'totalFCFA': 700,
      'taxRateBasisPoints': 1925,
      'taxFCFA': 0,
      'deliveryFCFA': 0,
      'discountFCFA': 0,
      'lines': [
        {'quantity': 2, 'productId': 'water'},
      ],
      'deviceId': 'device-1',
      'idempotencyKey': 'sale-1',
      'schemaVersion': 1,
    });

    expect(first, second);
  });
}
