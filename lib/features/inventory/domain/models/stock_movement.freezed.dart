// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_movement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StockMovement {
  String get id;
  String get productId;
  int get quantity;
  StockMovementType get type;
  String get actorId;
  String get deviceId;
  DateTime get occurredAt;

  /// Create a copy of StockMovement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StockMovementCopyWith<StockMovement> get copyWith =>
      _$StockMovementCopyWithImpl<StockMovement>(
          this as StockMovement, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StockMovement &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.actorId, actorId) || other.actorId == actorId) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.occurredAt, occurredAt) ||
                other.occurredAt == occurredAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, productId, quantity, type,
      actorId, deviceId, occurredAt);

  @override
  String toString() {
    return 'StockMovement(id: $id, productId: $productId, quantity: $quantity, type: $type, actorId: $actorId, deviceId: $deviceId, occurredAt: $occurredAt)';
  }
}

/// @nodoc
abstract mixin class $StockMovementCopyWith<$Res> {
  factory $StockMovementCopyWith(
          StockMovement value, $Res Function(StockMovement) _then) =
      _$StockMovementCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String productId,
      int quantity,
      StockMovementType type,
      String actorId,
      String deviceId,
      DateTime occurredAt});
}

/// @nodoc
class _$StockMovementCopyWithImpl<$Res>
    implements $StockMovementCopyWith<$Res> {
  _$StockMovementCopyWithImpl(this._self, this._then);

  final StockMovement _self;
  final $Res Function(StockMovement) _then;

  /// Create a copy of StockMovement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? quantity = null,
    Object? type = null,
    Object? actorId = null,
    Object? deviceId = null,
    Object? occurredAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _self.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as StockMovementType,
      actorId: null == actorId
          ? _self.actorId
          : actorId // ignore: cast_nullable_to_non_nullable
              as String,
      deviceId: null == deviceId
          ? _self.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      occurredAt: null == occurredAt
          ? _self.occurredAt
          : occurredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [StockMovement].
extension StockMovementPatterns on StockMovement {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_StockMovement value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StockMovement() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_StockMovement value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StockMovement():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_StockMovement value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StockMovement() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            String productId,
            int quantity,
            StockMovementType type,
            String actorId,
            String deviceId,
            DateTime occurredAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StockMovement() when $default != null:
        return $default(_that.id, _that.productId, _that.quantity, _that.type,
            _that.actorId, _that.deviceId, _that.occurredAt);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            String productId,
            int quantity,
            StockMovementType type,
            String actorId,
            String deviceId,
            DateTime occurredAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StockMovement():
        return $default(_that.id, _that.productId, _that.quantity, _that.type,
            _that.actorId, _that.deviceId, _that.occurredAt);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            String productId,
            int quantity,
            StockMovementType type,
            String actorId,
            String deviceId,
            DateTime occurredAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StockMovement() when $default != null:
        return $default(_that.id, _that.productId, _that.quantity, _that.type,
            _that.actorId, _that.deviceId, _that.occurredAt);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _StockMovement extends StockMovement {
  const _StockMovement(
      {required this.id,
      required this.productId,
      required this.quantity,
      required this.type,
      required this.actorId,
      required this.deviceId,
      required this.occurredAt})
      : super._();

  @override
  final String id;
  @override
  final String productId;
  @override
  final int quantity;
  @override
  final StockMovementType type;
  @override
  final String actorId;
  @override
  final String deviceId;
  @override
  final DateTime occurredAt;

  /// Create a copy of StockMovement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$StockMovementCopyWith<_StockMovement> get copyWith =>
      __$StockMovementCopyWithImpl<_StockMovement>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _StockMovement &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.actorId, actorId) || other.actorId == actorId) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.occurredAt, occurredAt) ||
                other.occurredAt == occurredAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, productId, quantity, type,
      actorId, deviceId, occurredAt);

  @override
  String toString() {
    return 'StockMovement(id: $id, productId: $productId, quantity: $quantity, type: $type, actorId: $actorId, deviceId: $deviceId, occurredAt: $occurredAt)';
  }
}

/// @nodoc
abstract mixin class _$StockMovementCopyWith<$Res>
    implements $StockMovementCopyWith<$Res> {
  factory _$StockMovementCopyWith(
          _StockMovement value, $Res Function(_StockMovement) _then) =
      __$StockMovementCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String productId,
      int quantity,
      StockMovementType type,
      String actorId,
      String deviceId,
      DateTime occurredAt});
}

/// @nodoc
class __$StockMovementCopyWithImpl<$Res>
    implements _$StockMovementCopyWith<$Res> {
  __$StockMovementCopyWithImpl(this._self, this._then);

  final _StockMovement _self;
  final $Res Function(_StockMovement) _then;

  /// Create a copy of StockMovement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? quantity = null,
    Object? type = null,
    Object? actorId = null,
    Object? deviceId = null,
    Object? occurredAt = null,
  }) {
    return _then(_StockMovement(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _self.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as StockMovementType,
      actorId: null == actorId
          ? _self.actorId
          : actorId // ignore: cast_nullable_to_non_nullable
              as String,
      deviceId: null == deviceId
          ? _self.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      occurredAt: null == occurredAt
          ? _self.occurredAt
          : occurredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
