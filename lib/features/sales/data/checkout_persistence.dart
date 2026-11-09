import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/models/receipt.dart';

class PendingCheckout {
  final String idempotencyKey;
  final Map<String, dynamic> payload;
  final DateTime queuedAt;

  const PendingCheckout({
    required this.idempotencyKey,
    required this.payload,
    required this.queuedAt,
  });

  factory PendingCheckout.fromJson(Map<String, dynamic> json) {
    return PendingCheckout(
      idempotencyKey: json['idempotencyKey'] as String,
      payload: Map<String, dynamic>.from(json['payload'] as Map),
      queuedAt: DateTime.parse(json['queuedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'idempotencyKey': idempotencyKey,
        'payload': payload,
        'queuedAt': queuedAt.toIso8601String(),
      };
}

class LocalCheckoutStore {
  static const _pendingKey = 'mboapos.pending_checkouts.v1';
  static const _receiptsKey = 'mboapos.receipts.v1';
  static const _movementsKey = 'mboapos.stock_movements.v1';

  Future<SharedPreferences> get _preferences => SharedPreferences.getInstance();

  Future<List<PendingCheckout>> pendingCheckouts() async {
    final values = (await _preferences).getStringList(_pendingKey) ?? const [];
    return values
        .map((value) => PendingCheckout.fromJson(
            Map<String, dynamic>.from(jsonDecode(value) as Map)))
        .toList(growable: false);
  }

  Future<void> enqueue(PendingCheckout checkout) async {
    final preferences = await _preferences;
    final current = await pendingCheckouts();
    if (current.any((item) => item.idempotencyKey == checkout.idempotencyKey)) {
      return;
    }
    await preferences.setStringList(
      _pendingKey,
      [
        ...current,
        checkout,
      ].map((item) => jsonEncode(item.toJson())).toList(),
    );
  }

  Future<void> removePending(String idempotencyKey) async {
    final preferences = await _preferences;
    final remaining = (await pendingCheckouts())
        .where((item) => item.idempotencyKey != idempotencyKey)
        .map((item) => jsonEncode(item.toJson()))
        .toList();
    await preferences.setStringList(_pendingKey, remaining);
  }

  Future<void> saveReceipt(ReceiptData receipt) async {
    final preferences = await _preferences;
    final receipts = await storedReceipts();
    final updated = [
      for (final item in receipts)
        if (item.receiptNumber != receipt.receiptNumber) item,
      receipt,
    ];
    await preferences.setStringList(
      _receiptsKey,
      updated.map((item) => jsonEncode(item.toJson())).toList(),
    );
  }

  Future<List<ReceiptData>> storedReceipts() async {
    final values = (await _preferences).getStringList(_receiptsKey) ?? const [];
    return values
        .map((value) => ReceiptData.fromJson(
            Map<String, dynamic>.from(jsonDecode(value) as Map)))
        .toList(growable: false);
  }

  Future<void> saveStockMovements(List<Map<String, dynamic>> movements) async {
    if (movements.isEmpty) return;
    final preferences = await _preferences;
    final current =
        (await _preferences).getStringList(_movementsKey) ?? const [];
    final known = current
        .map((value) => Map<String, dynamic>.from(jsonDecode(value) as Map))
        .toList();
    for (final movement in movements) {
      final index = known.indexWhere((item) => item['id'] == movement['id']);
      if (index < 0) {
        known.add(movement);
      } else {
        known[index] = movement;
      }
    }
    await preferences.setStringList(
      _movementsKey,
      known.map(jsonEncode).toList(),
    );
  }

  Future<List<Map<String, dynamic>>> stockMovements() async {
    final values =
        (await _preferences).getStringList(_movementsKey) ?? const [];
    return values
        .map((value) => Map<String, dynamic>.from(jsonDecode(value) as Map))
        .toList(growable: false);
  }
}

final localCheckoutStore = LocalCheckoutStore();
