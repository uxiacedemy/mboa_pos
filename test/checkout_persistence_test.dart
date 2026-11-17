import 'package:flutter_test/flutter_test.dart';

import 'package:mboa_pos/core/storage/local_database.dart';
import 'package:mboa_pos/features/sales/data/checkout_persistence.dart';
import 'package:mboa_pos/features/sales/domain/models/product.dart';
import 'package:mboa_pos/features/sales/domain/models/receipt.dart';

void main() {
  late LocalDatabase database;
  late LocalCheckoutStore store;

  setUp(() {
    database = LocalDatabase.forTesting();
    store = LocalCheckoutStore(database: database);
  });

  tearDown(() => database.close());

  ReceiptData receipt(String id) => ReceiptData(
        receiptNumber: id,
        issuedAt: DateTime.utc(2026, 1, 1),
        organizationName: 'MboaPOS',
        organizationNiu: 'NIU',
        organizationAddress: 'Douala',
        organizationId: 'org-1',
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
        isProvisional: true,
        syncStatus: 'pending',
      );

  PendingCheckout pending(String id, {String? fingerprint}) {
    final requestFingerprint = fingerprint ?? 'fingerprint-$id';
    final localReceipt = receipt(id);
    final payload = <String, dynamic>{
      'schemaVersion': 1,
      'idempotencyKey': id,
      'organizationId': 'org-1',
      'actorId': 'cashier-1',
      'deviceId': 'device-1',
      'requestFingerprint': requestFingerprint,
      'lines': [
        {'productId': 'water', 'quantity': 2},
      ],
      'localReceipt': localReceipt.toJson(),
    };
    return PendingCheckout(
      idempotencyKey: id,
      payload: payload,
      queuedAt: DateTime.utc(2026, 1, 1),
      organizationId: 'org-1',
      actorId: 'cashier-1',
      deviceId: 'device-1',
      requestFingerprint: requestFingerprint,
    );
  }

  test('persists receipts, movements, and idempotent pending checkouts',
      () async {
    final localReceipt = receipt('sale-1');
    final checkout = pending('sale-1');
    await store.saveReceipt(localReceipt);
    await store.enqueue(checkout);
    await store.enqueue(checkout);
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

  test('records an offline checkout and decrements cached stock once',
      () async {
    await database.cacheProducts('org-1', const [
      Product(
        id: 'water',
        name: 'Water',
        nameEn: 'Water',
        priceFCFA: 350,
        category: 'drinks',
        stockQty: 2,
      ),
    ]);
    final checkout = pending('sale-1');
    final localReceipt = receipt('sale-1');
    final movements = [
      {
        'id': 'sale-1:water',
        'organizationId': 'org-1',
        'productId': 'water',
        'quantity': -2,
        'syncStatus': 'pending',
      },
    ];

    await store.recordOfflineCheckout(
      checkout: checkout,
      receipt: localReceipt,
      lines: const [(productId: 'water', quantity: 2)],
      movements: movements,
    );
    await store.recordOfflineCheckout(
      checkout: checkout,
      receipt: localReceipt,
      lines: const [(productId: 'water', quantity: 2)],
      movements: movements,
    );

    expect((await database.productsFor('org-1')).single.stockQty, 0);
    await database.cacheProducts('org-1', const [
      Product(
        id: 'water',
        name: 'Water',
        nameEn: 'Water',
        priceFCFA: 350,
        category: 'drinks',
        stockQty: 2,
      ),
    ]);
    expect((await database.productsFor('org-1')).single.stockQty, 0);
    expect((await store.pendingCheckouts()).single.idempotencyKey, 'sale-1');
    expect((await store.storedReceipts()).single.isProvisional, isTrue);
  });

  test('rolls back checkout and stock when local stock is insufficient',
      () async {
    await database.cacheProducts('org-1', const [
      Product(
        id: 'water',
        name: 'Water',
        nameEn: 'Water',
        priceFCFA: 350,
        category: 'drinks',
        stockQty: 1,
      ),
    ]);
    final checkout = pending('sale-1');

    await expectLater(
      store.recordOfflineCheckout(
        checkout: checkout,
        receipt: receipt('sale-1'),
        lines: const [(productId: 'water', quantity: 2)],
        movements: const [],
      ),
      throwsStateError,
    );

    expect((await database.productsFor('org-1')).single.stockQty, 1);
    expect(await store.pendingCheckouts(), isEmpty);
    expect(await store.storedReceipts(), isEmpty);
  });

  test('scopes pending checkouts to organization, actor, and device', () async {
    PendingCheckout scoped(
      String key,
      String org,
      String actor,
      String device,
    ) {
      final checkout = pending(key);
      return PendingCheckout(
        idempotencyKey: key,
        payload: {
          ...checkout.payload,
          'organizationId': org,
          'actorId': actor,
          'deviceId': device,
        },
        queuedAt: checkout.queuedAt,
        organizationId: org,
        actorId: actor,
        deviceId: device,
        requestFingerprint: checkout.requestFingerprint,
      );
    }

    await store.enqueue(scoped('a', 'org-a', 'cashier-a', 'device-a'));
    await store.enqueue(scoped('b', 'org-b', 'cashier-b', 'device-b'));

    final orgA = await store.pendingCheckouts(
      organizationId: 'org-a',
      actorId: 'cashier-a',
      deviceId: 'device-a',
    );
    final wrongActor = await store.pendingCheckouts(
      organizationId: 'org-a',
      actorId: 'cashier-b',
      deviceId: 'device-a',
    );

    expect(orgA.map((item) => item.idempotencyKey), ['a']);
    expect(wrongActor, isEmpty);
  });
}
