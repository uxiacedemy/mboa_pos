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
  runApp(
    ProviderScope(
      child: MboaPOSApp(
        firebaseInitialization: _initializeFirebase(),
      ),
    ),
  );
}

Future<Object?> _initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    if (kDebugMode && _useFirebaseEmulators) {
      await _connectToFirebaseEmulators();
    }
    return null;
  } on Object catch (error) {
    return error;
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

class MboaPOSApp extends ConsumerWidget {
  final Future<Object?> firebaseInitialization;

  const MboaPOSApp({
    super.key,
    required this.firebaseInitialization,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<Object?>(
      future: firebaseInitialization,
      builder: (context, snapshot) {
        if (snapshot.hasError || snapshot.data is Object) {
          return MaterialApp(
            title: 'MboaPOS',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            home: FirebaseStartupErrorScreen(
              error: snapshot.error ?? snapshot.data as Object,
            ),
          );
        }

        if (snapshot.connectionState != ConnectionState.done) {
          return MaterialApp(
            title: 'MboaPOS',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            home: const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

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

  const FirebaseStartupErrorScreen({
    super.key,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
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
                'Firebase n\'est pas configure',
                style: AppTypography.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Ajoutez la configuration Firebase de cette plateforme, puis relancez l\'application.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
