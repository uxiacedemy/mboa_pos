// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'staff_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StaffUser {
  String get uid;
  String get organizationId;
  StaffRole get role;

  /// Create a copy of StaffUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StaffUserCopyWith<StaffUser> get copyWith =>
      _$StaffUserCopyWithImpl<StaffUser>(this as StaffUser, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StaffUser &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.role, role) || other.role == role));
  }

  @override
  int get hashCode => Object.hash(runtimeType, uid, organizationId, role);

  @override
  String toString() {
    return 'StaffUser(uid: $uid, organizationId: $organizationId, role: $role)';
  }
}

/// @nodoc
abstract mixin class $StaffUserCopyWith<$Res> {
  factory $StaffUserCopyWith(StaffUser value, $Res Function(StaffUser) _then) =
      _$StaffUserCopyWithImpl;
  @useResult
  $Res call({String uid, String organizationId, StaffRole role});
}

/// @nodoc
class _$StaffUserCopyWithImpl<$Res> implements $StaffUserCopyWith<$Res> {
  _$StaffUserCopyWithImpl(this._self, this._then);

  final StaffUser _self;
  final $Res Function(StaffUser) _then;

  /// Create a copy of StaffUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? organizationId = null,
    Object? role = null,
  }) {
    return _then(_self.copyWith(
      uid: null == uid
          ? _self.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      organizationId: null == organizationId
          ? _self.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as StaffRole,
    ));
  }
}

/// Adds pattern-matching-related methods to [StaffUser].
extension StaffUserPatterns on StaffUser {
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
    TResult Function(_StaffUser value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StaffUser() when $default != null:
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
    TResult Function(_StaffUser value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StaffUser():
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
    TResult? Function(_StaffUser value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StaffUser() when $default != null:
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
    TResult Function(String uid, String organizationId, StaffRole role)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StaffUser() when $default != null:
        return $default(_that.uid, _that.organizationId, _that.role);
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
    TResult Function(String uid, String organizationId, StaffRole role)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StaffUser():
        return $default(_that.uid, _that.organizationId, _that.role);
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
    TResult? Function(String uid, String organizationId, StaffRole role)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StaffUser() when $default != null:
        return $default(_that.uid, _that.organizationId, _that.role);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _StaffUser implements StaffUser {
  const _StaffUser(
      {required this.uid,
      required this.organizationId,
      this.role = StaffRole.cashier});

  @override
  final String uid;
  @override
  final String organizationId;
  @override
  @JsonKey()
  final StaffRole role;

  /// Create a copy of StaffUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$StaffUserCopyWith<_StaffUser> get copyWith =>
      __$StaffUserCopyWithImpl<_StaffUser>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _StaffUser &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.role, role) || other.role == role));
  }

  @override
  int get hashCode => Object.hash(runtimeType, uid, organizationId, role);

  @override
  String toString() {
    return 'StaffUser(uid: $uid, organizationId: $organizationId, role: $role)';
  }
}

/// @nodoc
abstract mixin class _$StaffUserCopyWith<$Res>
    implements $StaffUserCopyWith<$Res> {
  factory _$StaffUserCopyWith(
          _StaffUser value, $Res Function(_StaffUser) _then) =
      __$StaffUserCopyWithImpl;
  @override
  @useResult
  $Res call({String uid, String organizationId, StaffRole role});
}

/// @nodoc
class __$StaffUserCopyWithImpl<$Res> implements _$StaffUserCopyWith<$Res> {
  __$StaffUserCopyWithImpl(this._self, this._then);

  final _StaffUser _self;
  final $Res Function(_StaffUser) _then;

  /// Create a copy of StaffUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? uid = null,
    Object? organizationId = null,
    Object? role = null,
  }) {
    return _then(_StaffUser(
      uid: null == uid
          ? _self.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      organizationId: null == organizationId
          ? _self.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as StaffRole,
    ));
  }
}

// dart format on
