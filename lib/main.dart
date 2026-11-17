import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'core/design/design_tokens.dart';
import 'core/router/app_router.dart';
import 'firebase_options.dart';
import 'core/design/theme_provider.dart';
import 'features/auth/presentation/providers/entry_flow_provider.dart';
import 'l10n/app_localizations.dart';

const _emulatorHost = String.fromEnvironment(
  'FIREBASE_EMULATOR_HOST',
  defaultValue: '127.0.0.1',
);
const _useFirebaseEmulators = bool.fromEnvironment(
  'USE_FIREBASE_EMULATORS',
  defaultValue: false,
);
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _logStartup('App startup started');
  final container = ProviderContainer();
  container.read(firstRunWelcomeProvider);
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: MboaPOSApp(
        firebaseInitialization: _initializeFirebase,
      ),
    ),
  );
}

Future<Object?> _initializeFirebase() async {
  _logStartup('Firebase initialization started');
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    if (kDebugMode && _useFirebaseEmulators) {
      await _connectToFirebaseEmulators();
    }
    _logStartup('Firebase initialization completed');
    return null;
  } on Object catch (error, stackTrace) {
    developer.log(
      'Firebase initialization failed',
      name: 'mboapos.startup',
      error: error,
      stackTrace: stackTrace,
    );
    return error;
  }
}

void _logStartup(String message) {
  if (kDebugMode) {
    developer.log(message, name: 'mboapos.startup');
    debugPrint('[mboapos.startup] $message');
  }
}

Future<void> _connectToFirebaseEmulators() async {
  final auth = FirebaseAuth.instance;
  if (kIsWeb) {
    await auth.useAuthEmulator(
      '127.0.0.1',
      9099,
      automaticHostMapping: false,
    );
  } else {
    await auth.useAuthEmulator(_emulatorHost, 9099);
  }
  FirebaseFirestore.instance.useFirestoreEmulator(_emulatorHost, 8080);
  FirebaseFunctions.instanceFor(region: 'europe-west1')
      .useFunctionsEmulator(_emulatorHost, 5001);
}

class MboaPOSApp extends ConsumerStatefulWidget {
  final Future<Object?> Function() firebaseInitialization;

  const MboaPOSApp({
    super.key,
    required this.firebaseInitialization,
  });

  @override
  ConsumerState<MboaPOSApp> createState() => _MboaPOSAppState();
}

class _MboaPOSAppState extends ConsumerState<MboaPOSApp> {
  late Future<Object?> _firebaseInitialization;

  @override
  void initState() {
    super.initState();
    _firebaseInitialization = widget.firebaseInitialization();
  }

  void _retryFirebaseInitialization() {
    setState(() {
      _firebaseInitialization = widget.firebaseInitialization();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object?>(
      future: _firebaseInitialization,
      builder: (context, snapshot) {
        if (snapshot.hasError || snapshot.data is Object) {
          _logStartup('Showing Firebase startup error screen');
          return MaterialApp(
            title: 'MboaPOS',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('fr'),
            home: FirebaseStartupErrorScreen(
              error: snapshot.error ?? snapshot.data as Object,
              onRetry: _retryFirebaseInitialization,
            ),
          );
        }

        if (snapshot.connectionState != ConnectionState.done) {
          _logStartup('Waiting for Firebase initialization');
          return MaterialApp(
            title: 'MboaPOS',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('fr'),
            home: const Scaffold(
              backgroundColor: AppColors.checkoutCanvas,
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        _logStartup('Firebase is ready; building app router');
        final router = ref.watch(appRouterProvider);

        return MaterialApp.router(
          title: 'MboaPOS',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: ref.watch(themeModeProvider),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('fr'),
          routerConfig: router,
        );
      },
    );
  }
}

class FirebaseStartupErrorScreen extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;

  const FirebaseStartupErrorScreen({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.cloud_off_outlined,
                size: AppSpacing.xxl,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.firebaseSetupTitle,
                style: AppTypography.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.firebaseSetupBody,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall,
              ),
              const SizedBox(height: AppSpacing.md),
              FilledButton(
                onPressed: onRetry,
                child: Text(l10n.entryRetry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
