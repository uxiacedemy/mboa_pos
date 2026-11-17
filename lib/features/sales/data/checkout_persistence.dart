import 'dart:convert';

import '../../../core/storage/local_database.dart';
import '../domain/models/receipt.dart';

class PendingCheckout {
  final String idempotencyKey;
  final Map<String, dynamic> payload;
  final DateTime queuedAt;
  final int schemaVersion;
  final String? organizationId;
  final String? actorId;
  final String? deviceId;
  final String? requestFingerprint;

  const PendingCheckout({
    required this.idempotencyKey,
    required this.payload,
    required this.queuedAt,
    this.schemaVersion = 1,
    this.organizationId,
    this.actorId,
    this.deviceId,
    this.requestFingerprint,
  });

  factory PendingCheckout.fromJson(Map<String, dynamic> json) {
    return PendingCheckout(
      idempotencyKey: json['idempotencyKey'] as String,
      payload: Map<String, dynamic>.from(json['payload'] as Map),
      queuedAt: DateTime.parse(json['queuedAt'] as String),
      schemaVersion: json['schemaVersion'] as int? ??
          (json['payload'] as Map)['schemaVersion'] as int? ??
          0,
      organizationId: json['organizationId'] as String? ??
          (json['payload'] as Map)['organizationId'] as String?,
      actorId: json['actorId'] as String? ??
          (json['payload'] as Map)['actorId'] as String?,
      deviceId: json['deviceId'] as String? ??
          (json['payload'] as Map)['deviceId'] as String?,
      requestFingerprint: json['requestFingerprint'] as String? ??
          (json['payload'] as Map)['requestFingerprint'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'idempotencyKey': idempotencyKey,
        'payload': payload,
        'queuedAt': queuedAt.toIso8601String(),
        'schemaVersion': schemaVersion,
        'organizationId': organizationId ?? payload['organizationId'],
        'actorId': actorId ?? payload['actorId'],
        'deviceId': deviceId ?? payload['deviceId'],
        'requestFingerprint':
            requestFingerprint ?? payload['requestFingerprint'],
      };
}

class LocalCheckoutStore {
  final LocalDatabase database;

  LocalCheckoutStore({LocalDatabase? database})
      : database = database ?? localDatabase;

  Future<List<PendingCheckout>> pendingCheckouts({
    String? organizationId,
    String? actorId,
    String? deviceId,
  }) async {
    final rows = await database.pendingCheckouts(
      organizationId: organizationId,
      actorId: actorId,
      deviceId: deviceId,
    );
    return rows.map((row) {
      final decodedPayload = jsonDecode(row.payloadJson);
      if (decodedPayload is! Map) {
        throw StateError('A pending checkout has an invalid payload.');
      }
      final payload = Map<String, dynamic>.from(decodedPayload);
      return PendingCheckout(
        idempotencyKey: row.checkoutId,
        payload: payload,
        queuedAt: DateTime.fromMillisecondsSinceEpoch(row.queuedAtMillis),
        schemaVersion: payload['schemaVersion'] as int? ?? 0,
        organizationId: row.organizationId,
        actorId: row.actorId,
        deviceId: row.deviceId,
        requestFingerprint: row.requestFingerprint,
      );
    }).toList(growable: false);
  }

  Future<void> enqueue(PendingCheckout checkout) async {
    if (checkout.schemaVersion < 1 ||
        checkout.organizationId == null ||
        checkout.actorId == null ||
        checkout.deviceId == null ||
        checkout.requestFingerprint == null) {
      throw ArgumentError('Pending checkout identity metadata is required.');
    }
    await database.enqueuePendingCheckout(
      checkoutId: checkout.idempotencyKey,
      organizationId: checkout.organizationId!,
      actorId: checkout.actorId!,
      deviceId: checkout.deviceId!,
      requestFingerprint: checkout.requestFingerprint!,
      payload: checkout.payload,
      queuedAtMillis: checkout.queuedAt.millisecondsSinceEpoch,
    );
  }

  Future<void> removePending(String idempotencyKey) =>
      database.removePendingCheckout(idempotencyKey);

  Future<void> saveReceipt(
    ReceiptData receipt, {
    String? checkoutId,
  }) =>
      database.saveReceipt(
        receipt.toJson(),
        checkoutId: checkoutId,
        organizationId: receipt.organizationId,
      );

  Future<List<ReceiptData>> storedReceipts() async {
    final receipts = await database.storedReceipts();
    return receipts.map(ReceiptData.fromJson).toList(growable: false);
  }

  Future<void> saveStockMovements(List<Map<String, dynamic>> movements) =>
      database.saveStockMovements(movements);

  Future<List<Map<String, dynamic>>> stockMovements() =>
      database.stockMovements();

  Future<void> recordOfflineCheckout({
    required PendingCheckout checkout,
    required ReceiptData receipt,
    required List<({String productId, int quantity})> lines,
    required List<Map<String, dynamic>> movements,
  }) =>
      database.recordPendingCheckout(
        checkoutId: checkout.idempotencyKey,
        organizationId: checkout.organizationId!,
        actorId: checkout.actorId!,
        deviceId: checkout.deviceId!,
        requestFingerprint: checkout.requestFingerprint!,
        payload: checkout.payload,
        receipt: receipt.toJson(),
        lines: lines,
        movements: movements,
        queuedAtMillis: checkout.queuedAt.millisecondsSinceEpoch,
      );

  Future<void> completeCheckout({
    required String idempotencyKey,
    required String organizationId,
    required ReceiptData receipt,
    required List<Map<String, dynamic>> movements,
  }) =>
      database.completeCheckout(
        checkoutId: idempotencyKey,
        organizationId: organizationId,
        receipt: receipt.toJson(),
        movements: movements,
      );

  Future<void> markNeedsReview(String idempotencyKey, Object error) =>
      database.setCheckoutNeedsReview(idempotencyKey, error.toString());
}

final localCheckoutStore = LocalCheckoutStore();
