import 'package:freezed_annotation/freezed_annotation.dart';

part 'staff_user.freezed.dart';

enum StaffRole {
  cashier,
  supervisor,
  manager,
  admin,
}

@freezed
abstract class StaffUser with _$StaffUser {
  const factory StaffUser({
    required String uid,
    required String organizationId,
    @Default(StaffRole.cashier) StaffRole role,
  }) = _StaffUser;
}