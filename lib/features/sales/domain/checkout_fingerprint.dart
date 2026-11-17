import 'dart:convert';

import 'package:crypto/crypto.dart';

String _canonicalJson(Object? value) {
  if (value is List) {
    return '[${value.map(_canonicalJson).join(',')}]';
  }
  if (value is Map) {
    final keys = value.keys.map((key) => key.toString()).toList()..sort();
    return '{${keys.map((key) => '${jsonEncode(key)}:${_canonicalJson(value[key])}').join(',')}}';
  }
  return jsonEncode(value);
}

String checkoutRequestFingerprint(Map<String, dynamic> payload) {
  final quantities = <String, int>{};
  for (final rawLine in (payload['lines'] as List<dynamic>)) {
    final line = Map<String, dynamic>.from(rawLine as Map);
    final productId = line['productId'] as String;
    final quantity = line['quantity'] as int;
    quantities[productId] = (quantities[productId] ?? 0) + quantity;
  }
  final normalizedLines = quantities.entries
      .map((entry) => {'productId': entry.key, 'quantity': entry.value})
      .toList(growable: false);
  final canonical = {
    'schemaVersion': payload['schemaVersion'],
    'idempotencyKey': payload['idempotencyKey'],
    'deviceId': payload['deviceId'],
    'lines': normalizedLines,
    'discountFCFA': payload['discountFCFA'],
    'deliveryFCFA': payload['deliveryFCFA'],
    'taxFCFA': payload['taxFCFA'],
    'taxRateBasisPoints': payload['taxRateBasisPoints'],
    'totalFCFA': payload['totalFCFA'],
    'paymentMethod': payload['paymentMethod'],
    'paymentReference': payload['paymentReference'],
  };
  return sha256.convert(utf8.encode(_canonicalJson(canonical))).toString();
}
