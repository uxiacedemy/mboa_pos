import 'dart:async';
import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/models/staff_user.dart';
import '../../../sales/data/checkout_sync_service.dart';

enum AuthStatus { unknown, unauthenticated, authenticated }

final authProvider =
    AsyncNotifierProvider<AuthNotifier, StaffUser?>(AuthNotifier.new);

final authStatusProvider = Provider<AuthStatus>((ref) {
  final auth = ref.watch(authProvider);
  return auth.when(
    loading: () => AuthStatus.unknown,
    error: (_, __) => AuthStatus.unauthenticated,
    data: (user) =>
        user == null ? AuthStatus.unauthenticated : AuthStatus.authenticated,
  );
});

typedef DeviceIdRead = Future<String?> Function(String key);
typedef DeviceIdWrite = Future<void> Function(String key, String value);

const deviceIdStorageKey = 'mboa_pos_device_id';

Future<String> loadOrCreateDeviceId({
  required DeviceIdRead read,
  required DeviceIdWrite write,
  Uuid uuid = const Uuid(),
}) async {
  final existing = await read(deviceIdStorageKey);
  if (existing != null && existing.isNotEmpty) return existing;
  final deviceId = uuid.v4();
  await write(deviceIdStorageKey, deviceId);
  return deviceId;
}

final deviceIdProvider = FutureProvider<String>((ref) async {
  const storage = FlutterSecureStorage();
  return loadOrCreateDeviceId(
    read: (key) => storage.read(key: key),
    write: (key, value) => storage.write(key: key, value: value),
  );
});

enum AuthFailureCode {
  inputRequired,
  invalidCredentials,
  disabled,
  networkUnavailable,
  tooManyAttempts,
  accountExists,
  weakPassword,
  invalidEmail,
  verifyEmail,
  businessUnlinked,
  ownerRequired,
  businessSetupUnavailable,
  businessDetailsInvalid,
  businessSetupRetry,
  businessCreateFailed,
  generic,
}

class AuthFailure implements Exception {
  final AuthFailureCode code;
  const AuthFailure(this.code);

  String localizedMessage(AppLocalizations l10n) => switch (code) {
        AuthFailureCode.inputRequired => l10n.authInputRequired,
        AuthFailureCode.invalidCredentials => l10n.authInvalid,
        AuthFailureCode.disabled => l10n.authDisabled,
        AuthFailureCode.networkUnavailable => l10n.authNetwork,
        AuthFailureCode.tooManyAttempts => l10n.authTooManyAttempts,
        AuthFailureCode.accountExists => l10n.authAccountExists,
        AuthFailureCode.weakPassword => l10n.authWeakPassword,
        AuthFailureCode.invalidEmail => l10n.authInvalidEmail,
        AuthFailureCode.verifyEmail => l10n.authVerifyEmail,
        AuthFailureCode.businessUnlinked => l10n.authBusinessUnlinked,
        AuthFailureCode.ownerRequired => l10n.authOwnerRequired,
        AuthFailureCode.businessSetupUnavailable =>
          l10n.businessSetupUnavailable,
        AuthFailureCode.businessDetailsInvalid => l10n.businessSetupInvalid,
        AuthFailureCode.businessSetupRetry => l10n.businessSetupRetry,
        AuthFailureCode.businessCreateFailed => l10n.businessCreateFailed,
        AuthFailureCode.generic => l10n.authGeneric,
      };

  @override
  String toString() => code.name;
}

class AuthNotifier extends AsyncNotifier<StaffUser?> {
  FirebaseAuth get _auth => FirebaseAuth.instance;
  static const _authRequestTimeout = Duration(seconds: 20);

  @override
  Future<StaffUser?> build() async {
    try {
      final user =
          await _auth.authStateChanges().first.timeout(_authRequestTimeout);
      if (user == null) return null;
      return await _sessionForUser(user).timeout(_authRequestTimeout);
    } on TimeoutException catch (error, stackTrace) {
      developer.log(
        'Timed out restoring the authentication session',
        name: 'mboapos.auth',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    } on AuthFailure catch (error, stackTrace) {
      developer.log(
        'Could not restore the authentication session',
        name: 'mboapos.auth',
        error: error,
        stackTrace: stackTrace,
      );
      // Keep an incomplete owner registration signed in so it can be resumed
      // from the registration screen. Protected routes remain unavailable
      // until the backend provisions and verifies the organization membership.
      return null;
    } on Object catch (error, stackTrace) {
      developer.log(
        'Unexpected authentication session restoration failure',
        name: 'mboapos.auth',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<void> signIn({required String staffId, required String pin}) async {
    final id = staffId.trim();
    if (id.isEmpty || pin.length < 4) {
      throw const AuthFailure(AuthFailureCode.inputRequired);
    }
    try {
      final credential = await _auth
          .signInWithEmailAndPassword(
            email: '$id@mboapos.internal',
            password: pin,
          )
          .timeout(_authRequestTimeout);
      final session =
          await _sessionForUser(credential.user!).timeout(_authRequestTimeout);
      state = AsyncData(session);
    } on TimeoutException {
      throw const AuthFailure(AuthFailureCode.networkUnavailable);
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(_failureFor(error));
    }
  }

  Future<void> signInOwner(
      {required String email, required String password}) async {
    if (email.trim().isEmpty || password.isEmpty) {
      throw const AuthFailure(AuthFailureCode.inputRequired);
    }
    try {
      final credential = await _auth
          .signInWithEmailAndPassword(
            email: email.trim(),
            password: password,
          )
          .timeout(_authRequestTimeout);
      final user = credential.user!;
      if (!user.emailVerified) {
        await _auth.signOut();
        throw const AuthFailure(AuthFailureCode.verifyEmail);
      }
      final session = await _sessionForUser(user, ownerOnly: true)
          .timeout(_authRequestTimeout);
      state = AsyncData(session);
    } on TimeoutException {
      throw const AuthFailure(AuthFailureCode.networkUnavailable);
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(_failureFor(error));
    }
  }

  Future<void> registerOwner({
    required String email,
    required String password,
    required String businessName,
  }) async {
    try {
      final normalizedEmail = email.trim();
      final current = _auth.currentUser;
      final user = current != null && current.email == normalizedEmail
          ? current
          : (await _auth
                  .createUserWithEmailAndPassword(
                    email: normalizedEmail,
                    password: password,
                  )
                  .timeout(_authRequestTimeout))
              .user!;
      final callable = FirebaseFunctions.instanceFor(region: 'europe-west1')
          .httpsCallable('createOrganizationOwner');
      await callable.call({'businessName': businessName.trim()}).timeout(
          _authRequestTimeout);
      await user.sendEmailVerification().timeout(_authRequestTimeout);
      await _auth.signOut();
    } on TimeoutException {
      throw const AuthFailure(AuthFailureCode.businessSetupRetry);
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(_failureFor(error));
    } on FirebaseFunctionsException catch (error) {
      throw AuthFailure(switch (error.code) {
        'not-found' => AuthFailureCode.businessSetupUnavailable,
        'invalid-argument' ||
        'permission-denied' ||
        'failed-precondition' =>
          AuthFailureCode.businessDetailsInvalid,
        'unavailable' ||
        'deadline-exceeded' ||
        'internal' ||
        'aborted' =>
          AuthFailureCode.businessSetupRetry,
        _ => AuthFailureCode.businessCreateFailed,
      });
    }
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth
          .sendPasswordResetEmail(email: email.trim())
          .timeout(_authRequestTimeout);
    } on TimeoutException {
      throw const AuthFailure(AuthFailureCode.networkUnavailable);
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(_failureFor(error));
    }
  }

  Future<StaffUser> _sessionForUser(
    User user, {
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
      throw const AuthFailure(AuthFailureCode.businessUnlinked);
    }
    if (ownerOnly && roleName != 'owner' && roleName != 'admin') {
      await _auth.signOut();
      throw const AuthFailure(AuthFailureCode.ownerRequired);
    }
    if (claims['active'] != true) {
      await _auth.signOut();
      throw const AuthFailure(AuthFailureCode.disabled);
    }
    final role = StaffRole.values.firstWhere((value) => value.name == roleName);
    await _verifyMembership(user.uid, organizationId, role);
    final session =
        StaffUser(uid: user.uid, organizationId: organizationId, role: role);
    final deviceId = await ref.read(deviceIdProvider.future);
    unawaited(CheckoutSyncService().syncPending(
      organizationId: organizationId,
      actorId: user.uid,
      deviceId: deviceId,
    ));
    return session;
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
        data?['active'] != true ||
        data?['role'] != role.name) {
      throw const AuthFailure(AuthFailureCode.businessUnlinked);
    }
  }

  AuthFailureCode _failureFor(FirebaseAuthException error) =>
      switch (error.code) {
        'invalid-credential' ||
        'wrong-password' ||
        'user-not-found' =>
          AuthFailureCode.invalidCredentials,
        'user-disabled' => AuthFailureCode.disabled,
        'network-request-failed' => AuthFailureCode.networkUnavailable,
        'too-many-requests' => AuthFailureCode.tooManyAttempts,
        'email-already-in-use' => AuthFailureCode.accountExists,
        'weak-password' => AuthFailureCode.weakPassword,
        'invalid-email' => AuthFailureCode.invalidEmail,
        _ => AuthFailureCode.generic,
      };

  Future<void> signOut() async {
    await _auth.signOut();
    state = const AsyncData(null);
  }
}
