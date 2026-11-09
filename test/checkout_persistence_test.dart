import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mboa_pos/features/sales/data/checkout_persistence.dart';
import 'package:mboa_pos/features/sales/domain/models/receipt.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('persists receipts, movements, and idempotent pending checkouts',
      () async {
    final store = LocalCheckoutStore();
    final receipt = ReceiptData(
      receiptNumber: 'sale-1',
      issuedAt: DateTime.utc(2026, 1, 1),
      organizationName: 'MboaPOS',
      organizationNiu: 'NIU',
      organizationAddress: 'Douala',
      cashierName: 'cashier-1',
      items: const [
        ReceiptLine(
          name: 'Water',
          quantity: 2,
          unitPriceFCFA: 350,
          subtotalFCFA: 700,
        ),
      ],
      subtotalFCFA: 700,
      discountFCFA: 0,
      deliveryFCFA: 0,
      taxFCFA: 0,
      taxRate: 0,
      totalFCFA: 700,
      paymentMethod: 'Cash',
    );
    final pending = PendingCheckout(
      idempotencyKey: 'sale-1',
      payload: {
        'idempotencyKey': 'sale-1',
        'lines': [
          {'productId': 'water', 'quantity': 2},
        ],
      },
      queuedAt: DateTime.utc(2026, 1, 1),
    );

    await store.saveReceipt(receipt);
    await store.enqueue(pending);
    await store.enqueue(pending);
    await store.saveStockMovements([
      {'id': 'movement-1', 'syncStatus': 'pending'},
    ]);
    await store.saveStockMovements([
      {'id': 'movement-1', 'syncStatus': 'synced'},
    ]);

    expect((await store.storedReceipts()).single.receiptNumber, 'sale-1');
    expect((await store.pendingCheckouts()).length, 1);
    expect((await store.stockMovements()).single['syncStatus'], 'synced');
  });
}
