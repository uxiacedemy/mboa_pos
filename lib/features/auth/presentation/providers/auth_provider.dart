import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';
import '../../domain/models/staff_user.dart';

final authProvider = NotifierProvider<AuthNotifier, StaffUser?>
    (AuthNotifier.new);

final deviceIdProvider = FutureProvider<String>((ref) async {
  const storage = FlutterSecureStorage();
  const key = 'mboa_pos_device_id';
  final existing = await storage.read(key: key);
  if (existing != null && existing.isNotEmpty) return existing;

  final deviceId = const Uuid().v4();
  await storage.write(key: key, value: deviceId);
  return deviceId;
});

class AuthNotifier extends Notifier<StaffUser?> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  StaffUser? build() => null;

  Future<void> signIn({
    required String staffId,
    required String pin,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: '$staffId@mboapos.internal',
      password: pin,
    );
    final token = await credential.user!.getIdTokenResult(true);
    final claims = token.claims ?? const <String, dynamic>{};
    final organizationId = claims['organizationId'] as String?;
    if (organizationId == null || organizationId.isEmpty) {
      await _auth.signOut();
      throw StateError('Authenticated staff has no organizationId claim.');
    }

    final roleName = claims['role'] as String?;
    final role = StaffRole.values.firstWhere(
      (value) => value.name == roleName,
      orElse: () => StaffRole.cashier,
    );
    state = StaffUser(
      uid: credential.user!.uid,
      organizationId: organizationId,
      role: role,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
    state = null;
  }
}
