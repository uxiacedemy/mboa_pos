import 'package:cloud_functions/cloud_functions.dart';

import 'checkout_persistence.dart';
import '../domain/models/receipt.dart';

class CheckoutSyncService {
  final LocalCheckoutStore store;

  CheckoutSyncService({LocalCheckoutStore? store})
      : store = store ?? localCheckoutStore;

  Future<int> syncPending({
    required String organizationId,
    required String actorId,
    required String deviceId,
  }) async {
    final pending = await store.pendingCheckouts(
      organizationId: organizationId,
      actorId: actorId,
      deviceId: deviceId,
    );
    if (pending.isEmpty) return 0;

    final callable = FirebaseFunctions.instanceFor(region: 'europe-west1')
        .httpsCallable('commitCheckout');
    var completed = 0;
    for (final checkout in pending) {
      try {
        if (checkout.organizationId != organizationId ||
            checkout.actorId != actorId ||
            checkout.deviceId != deviceId) {
          continue;
        }
        final response = await callable.call<Map<String, dynamic>>(
          checkout.payload,
        );
        final receipt = _receiptFromCheckout(
          checkout.payload,
          response.data,
        );
        await store.completeCheckout(
          idempotencyKey: checkout.idempotencyKey,
          organizationId: organizationId,
          receipt: receipt,
          movements: _movementsFromPayload(
            checkout.payload,
            synced: true,
            occurredAt: receipt.issuedAt.toIso8601String(),
          ),
        );
        completed++;
      } on FirebaseFunctionsException catch (error) {
        if (_isRetryable(error.code)) break;
        await store.markNeedsReview(checkout.idempotencyKey, error);
        break;
      } on Object catch (error) {
        await store.markNeedsReview(checkout.idempotencyKey, error);
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
    final issuedAtValue = response['issuedAt'];
    final receiptNumber = response['receiptNumber'];
    final organizationId = response['organizationId'];
    final organizationName = response['organizationName'];
    final organizationNiu = response['organizationNiu'];
    final organizationAddress = response['organizationAddress'];
    final cashierId = response['cashierId'];
    final paymentMethod = response['paymentMethod'];
    final paymentReference = response['paymentReference'];
    final taxRate = response['taxRateBasisPoints'];
    final isFiscal = response['isFiscal'];
    if (issuedAtValue is! String ||
        receiptNumber is! String ||
        organizationId is! String ||
        organizationId != local.organizationId ||
        organizationName is! String ||
        organizationNiu is! String ||
        organizationAddress is! String ||
        cashierId != local.cashierName ||
        paymentMethod != payload['paymentMethod'] ||
        (paymentReference != null && paymentReference is! String) ||
        taxRate is! int ||
        taxRate < 0 ||
        taxRate > 10000 ||
        isFiscal is! bool) {
      throw StateError('The server did not return authoritative receipt data.');
    }
    final issuedAt = DateTime.tryParse(issuedAtValue);
    if (issuedAt == null || receiptNumber.isEmpty) {
      throw StateError('The server returned invalid receipt data.');
    }
    final lines = _receiptLines(response['lines']);
    if (lines.isEmpty) {
      throw StateError('The server returned no receipt lines.');
    }
    return ReceiptData(
      receiptNumber: receiptNumber,
      issuedAt: issuedAt,
      organizationId: organizationId,
      organizationName: organizationName,
      organizationNiu: organizationNiu,
      organizationAddress: organizationAddress,
      cashierName: local.cashierName,
      items: lines,
      subtotalFCFA: _requiredAmount(response, 'subtotalFCFA'),
      discountFCFA: _requiredAmount(response, 'discountFCFA'),
      deliveryFCFA: _requiredAmount(response, 'deliveryFCFA'),
      taxFCFA: _requiredAmount(response, 'taxFCFA'),
      taxRate: taxRate / 10000,
      totalFCFA: _requiredAmount(response, 'totalFCFA'),
      paymentMethod: local.paymentMethod,
      paymentReference: paymentReference as String?,
      isFiscal: isFiscal,
      isProvisional: false,
      issuedAtIsServer: true,
      syncStatus: 'synced',
    );
  }

  static int _requiredAmount(Map<String, dynamic> response, String field) {
    final value = response[field];
    if (value is! int || value < 0) {
      throw StateError('The server returned an invalid $field.');
    }
    return value;
  }

  static List<ReceiptLine> _receiptLines(Object? raw) {
    if (raw is! List || raw.isEmpty) {
      throw StateError('The server returned invalid receipt lines.');
    }
    return [
      for (final item in raw)
        if (item is Map &&
            item['name'] is String &&
            (item['name'] as String).isNotEmpty &&
            item['quantity'] is int &&
            (item['quantity'] as int) > 0 &&
            item['unitPriceFCFA'] is int &&
            (item['unitPriceFCFA'] as int) >= 0 &&
            item['subtotalFCFA'] is int &&
            (item['subtotalFCFA'] as int) >= 0)
          ReceiptLine(
            name: item['name'] as String,
            quantity: item['quantity'] as int,
            unitPriceFCFA: item['unitPriceFCFA'] as int,
            subtotalFCFA: item['subtotalFCFA'] as int,
          )
        else
          throw StateError('The server returned invalid receipt lines.'),
    ];
  }

  static List<Map<String, dynamic>> _movementsFromPayload(
    Map<String, dynamic> payload, {
    required bool synced,
    String? occurredAt,
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
          'occurredAt': occurredAt ??
              (payload['localReceipt'] is Map
                  ? (payload['localReceipt'] as Map)['issuedAt']
                  : null),
          'syncStatus': synced ? 'synced' : 'pending',
        },
    ];
  }
}
