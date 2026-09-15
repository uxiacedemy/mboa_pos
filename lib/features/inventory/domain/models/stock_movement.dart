import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'stock_movement.freezed.dart';

enum StockMovementType {
  saleDeduction,
  purchaseAddition,
  manualAdjustment,
  wasteWriteOff,
  transferOut,
  transferIn,
  openingBalance,
}

@freezed
abstract class StockMovement with _$StockMovement {
  const StockMovement._();

  const factory StockMovement({
    required String id,
    required String organizationId,
    required String productId,
    required int quantity,
    required StockMovementType type,
    required String actorId,
    required String deviceId,
    required DateTime occurredAt,
  }) = _StockMovement;

  Map<String, dynamic> toFirestore() => {
        'id': id,
        'organizationId': organizationId,
        'productId': productId,
        'quantity': quantity,
        'type': type.name,
        'actorId': actorId,
        'deviceId': deviceId,
        'occurredAt': Timestamp.fromDate(occurredAt),
      };
}