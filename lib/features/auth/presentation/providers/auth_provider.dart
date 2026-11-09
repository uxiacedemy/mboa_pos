import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';
import '../../domain/models/staff_user.dart';
import '../../../sales/data/checkout_sync_service.dart';

enum AuthStatus { restoring, signedOut, authenticated }

final authStatusProvider =
    NotifierProvider<AuthStatusNotifier, AuthStatus>(AuthStatusNotifier.new);

class AuthStatusNotifier extends Notifier<AuthStatus> {
  @override
  AuthStatus build() => AuthStatus.restoring;

  void setStatus(AuthStatus value) => state = value;
}

final authProvider =
    NotifierProvider<AuthNotifier, StaffUser?>(AuthNotifier.new);

final deviceIdProvider = FutureProvider<String>((ref) async {
  const storage = FlutterSecureStorage();
  const key = 'mboa_pos_device_id';
  final existing = await storage.read(key: key);
  if (existing != null && existing.isNotEmpty) return existing;
  final deviceId = const Uuid().v4();
  await storage.write(key: deviceId, value: deviceId);
  return deviceId;
});

class AuthFailure implements Exception {
  final String message;
  const AuthFailure(this.message);
  @override
  String toString() => message;
}

class AuthNotifier extends Notifier<StaffUser?> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription<User?>? _authSubscription;

  @override
  StaffUser? build() {
    ref.onDispose(() => _authSubscription?.cancel());
    ref.read(authStatusProvider.notifier).setStatus(AuthStatus.restoring);
    _authSubscription = _auth.authStateChanges().listen(_restoreSession);
    return null;
  }

  Future<void> _restoreSession(User? user) async {
    if (user == null) {
      state = null;
      ref.read(authStatusProvider.notifier).setStatus(AuthStatus.signedOut);
      return;
    }
    try {
      await _setUserFromClaims(user, requireOwnerOrStaff: false);
    } catch (_) {
      await _auth.signOut();
      state = null;
      ref.read(authStatusProvider.notifier).setStatus(AuthStatus.signedOut);
    }
  }

  Future<void> signIn({required String staffId, required String pin}) async {
    final id = staffId.trim();
    if (id.isEmpty || pin.length < 4) {
      throw const AuthFailure('Enter your staff ID and PIN.');
    }
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: '$id@mboapos.internal',
        password: pin,
      );
      await _setUserFromClaims(credential.user!, requireOwnerOrStaff: true);
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(_messageFor(error));
    }
  }

  Future<void> signInOwner(
      {required String email, required String password}) async {
    if (email.trim().isEmpty || password.isEmpty) {
      throw const AuthFailure('Enter your email and password.');
    }
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user!;
      if (!user.emailVerified) {
        await _auth.signOut();
        throw const AuthFailure('Verify your email before signing in.');
      }
      await _setUserFromClaims(user,
          requireOwnerOrStaff: true, ownerOnly: true);
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(_messageFor(error));
    }
  }

  Future<void> registerOwner({
    required String email,
    required String password,
    required String businessName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user!;
      final callable = FirebaseFunctions.instanceFor(region: 'europe-west1')
          .httpsCallable('createOrganizationOwner');
      await callable.call({'businessName': businessName.trim()});
      await user.sendEmailVerification();
      await _auth.signOut();
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(_messageFor(error));
    } on FirebaseFunctionsException catch (_) {
      await _auth.signOut();
      throw const AuthFailure(
          'We could not create your business account. Try again.');
    }
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(_messageFor(error));
    }
  }

  Future<void> _setUserFromClaims(
    User user, {
    required bool requireOwnerOrStaff,
    bool ownerOnly = false,
  }) async {
    final token = await user.getIdTokenResult(true);
    final claims = token.claims ?? const <String, dynamic>{};
    final organizationId = claims['organizationId'] as String?;
    final roleName = claims['role'] as String?;
    final validRoles = {'owner', 'admin', 'manager', 'supervisor', 'cashier'};
    if (organizationId == null ||
        organizationId.isEmpty ||
        !validRoles.contains(roleName)) {
      throw const AuthFailure(
          'This account is not linked to an active MboaPOS business.');
    }
    if (ownerOnly && roleName != 'owner' && roleName != 'admin') {
      await _auth.signOut();
      throw const AuthFailure('Owner access is required for this sign-in.');
    }
    if (claims['active'] == false) {
      await _auth.signOut();
      throw const AuthFailure(
          'This account has been disabled. Contact your administrator.');
    }
    final role = StaffRole.values.firstWhere((value) => value.name == roleName);
    await _verifyMembership(user.uid, organizationId, role);
    state =
        StaffUser(uid: user.uid, organizationId: organizationId, role: role);
    ref.read(authStatusProvider.notifier).setStatus(AuthStatus.authenticated);
    unawaited(
        CheckoutSyncService().syncPending(organizationId: organizationId));
    if (requireOwnerOrStaff) return;
  }

  Future<void> _verifyMembership(
    String uid,
    String organizationId,
    StaffRole role,
  ) async {
    final snapshot = await FirebaseFirestore.instance
        .doc('organizations/$organizationId/staff/$uid')
        .get();
    final data = snapshot.data();
    if (!snapshot.exists ||
        data?['organizationId'] != organizationId ||
        data?['active'] == false ||
        data?['role'] != role.name) {
      throw const AuthFailure(
        'This account is not an active member of this business.',
      );
    }
  }

  String _messageFor(FirebaseAuthException error) => switch (error.code) {
        'invalid-credential' ||
        'wrong-password' ||
        'user-not-found' =>
          'The credentials are not valid.',
        'user-disabled' => 'This account has been disabled.',
        'network-request-failed' =>
          'Network unavailable. Check your connection.',
        'too-many-requests' => 'Too many attempts. Please wait and try again.',
        'email-already-in-use' => 'An account already exists for this email.',
        'weak-password' =>
          'Choose a stronger password of at least 8 characters.',
        'invalid-email' => 'Enter a valid email address.',
        _ => 'Authentication could not be completed. Try again.',
      };

  Future<void> signOut() async {
    await _auth.signOut();
    state = null;
  }
}
