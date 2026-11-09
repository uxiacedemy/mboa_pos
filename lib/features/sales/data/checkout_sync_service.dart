import 'package:cloud_functions/cloud_functions.dart';

import 'checkout_persistence.dart';
import '../domain/models/receipt.dart';

class CheckoutSyncService {
  final LocalCheckoutStore store;

  CheckoutSyncService({LocalCheckoutStore? store})
      : store = store ?? localCheckoutStore;

  Future<int> syncPending({required String organizationId}) async {
    final pending = await store.pendingCheckouts();
    if (pending.isEmpty) return 0;

    final callable = FirebaseFunctions.instanceFor(region: 'europe-west1')
        .httpsCallable('commitCheckout');
    var completed = 0;
    for (final checkout in pending) {
      try {
        final response = await callable.call<Map<String, dynamic>>(
          checkout.payload,
        );
        final receipt = _receiptFromCheckout(
          checkout.payload,
          response.data,
        );
        await store.saveReceipt(receipt);
        await store.saveStockMovements(
          _movementsFromPayload(checkout.payload, synced: true),
        );
        await store.removePending(checkout.idempotencyKey);
        completed++;
      } on FirebaseFunctionsException catch (error) {
        if (_isRetryable(error.code)) break;
        break;
      } catch (_) {
        break;
      }
    }
    return completed;
  }

  static bool _isRetryable(String code) => switch (code) {
        'unavailable' ||
        'deadline-exceeded' ||
        'internal' ||
        'aborted' ||
        'cancelled' =>
          true,
        _ => false,
      };

  static ReceiptData _receiptFromCheckout(
    Map<String, dynamic> payload,
    Map<String, dynamic> response,
  ) {
    final local = ReceiptData.fromJson(
      Map<String, dynamic>.from(payload['localReceipt'] as Map),
    );
    return ReceiptData(
      receiptNumber:
          response['receiptNumber'] as String? ?? local.receiptNumber,
      issuedAt: DateTime.tryParse(response['issuedAt'] as String? ?? '') ??
          local.issuedAt,
      organizationName: local.organizationName,
      organizationNiu: local.organizationNiu,
      organizationAddress: local.organizationAddress,
      cashierName: local.cashierName,
      items: local.items,
      subtotalFCFA: local.subtotalFCFA,
      discountFCFA: local.discountFCFA,
      deliveryFCFA: local.deliveryFCFA,
      taxFCFA: local.taxFCFA,
      taxRate: local.taxRate,
      totalFCFA: local.totalFCFA,
      paymentMethod: local.paymentMethod,
      paymentReference: local.paymentReference,
    );
  }

  static List<Map<String, dynamic>> _movementsFromPayload(
    Map<String, dynamic> payload, {
    required bool synced,
  }) {
    final lines = (payload['lines'] as List).cast<Map>();
    return [
      for (final line in lines)
        {
          'id': '${payload['idempotencyKey']}:${line['productId']}',
          'organizationId': payload['organizationId'],
          'productId': line['productId'],
          'quantity': -(line['quantity'] as int),
          'type': 'saleDeduction',
          'actorId': payload['actorId'],
          'deviceId': payload['deviceId'],
          'occurredAt': payload['localReceipt'] is Map
              ? (payload['localReceipt'] as Map)['issuedAt']
              : DateTime.now().toIso8601String(),
          'syncStatus': synced ? 'synced' : 'pending',
        },
    ];
  }
}
