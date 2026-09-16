import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/design/design_tokens.dart';
import 'core/router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Object? firebaseInitializationError;
  try {
    await Firebase.initializeApp();
  } catch (error) {
    firebaseInitializationError = error;
  }
  runApp(
    ProviderScope(
      child: MboaPOSApp(firebaseInitializationError: firebaseInitializationError),
    ),
  );
}

class MboaPOSApp extends ConsumerWidget {
  final Object? firebaseInitializationError;

  const MboaPOSApp({
    super.key,
    this.firebaseInitializationError,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (firebaseInitializationError != null) {
      return MaterialApp(
        title: 'MboaPOS',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: FirebaseStartupErrorScreen(error: firebaseInitializationError!),
      );
    }

    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'MboaPOS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr'),
        Locale('en'),
      ],
      locale: const Locale('fr'),
      routerConfig: router,
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
