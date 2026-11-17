import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mboa_pos/core/router/app_router.dart';
import 'package:mboa_pos/features/auth/domain/models/staff_user.dart';
import 'package:mboa_pos/features/auth/presentation/providers/auth_provider.dart';
import 'package:mboa_pos/features/auth/presentation/providers/entry_flow_provider.dart';
import 'package:mboa_pos/features/auth/presentation/screens/entry_flow_screens.dart';
import 'package:mboa_pos/features/auth/presentation/screens/login_screen.dart';
import 'package:mboa_pos/l10n/app_localizations.dart';

class _DeferredAuthNotifier extends AuthNotifier {
  _DeferredAuthNotifier(this.result);

  final Future<StaffUser?> result;

  @override
  Future<StaffUser?> build() => result;
}

class _DeferredWelcomeNotifier extends FirstRunWelcomeNotifier {
  _DeferredWelcomeNotifier(this.result);

  final Future<bool> result;

  @override
  Future<bool> build() => result;
}

void main() {
  testWidgets('login screen renders staff and owner authentication controls',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(550, 700));
    await tester.pumpWidget(
      ProviderScope(
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('fr'),
          home: EntryFlowLocalizations(child: LoginScreen()),
        ),
      ),
    );

    expect(find.text('Bienvenue sur MboaPOS'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Identifiant staff'),
        findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'PIN sécurisé'), findsOneWidget);
    expect(find.text('Créer un compte entreprise'), findsOneWidget);
  });

  testWidgets('login screen switches between French and English',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(550, 700));
    await tester.pumpWidget(
      ProviderScope(
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('fr'),
          home: EntryFlowLocalizations(child: LoginScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Anglais'));
    await tester.tap(find.text('Anglais'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome to MboaPOS'), findsOneWidget);
    expect(find.text('Staff ID'), findsOneWidget);
    expect(find.text('Secure PIN'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);

    await tester.ensureVisible(find.text('French'));
    await tester.tap(find.text('French'));
    await tester.pumpAndSettle();
    expect(find.text('Bienvenue sur MboaPOS'), findsOneWidget);
    expect(find.text('Identifiant staff'), findsOneWidget);
  });

  testWidgets('welcome screen presents the first-run introduction',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(550, 700));
    await tester.pumpWidget(
      ProviderScope(
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('fr'),
          home: EntryFlowLocalizations(child: WelcomeScreen()),
        ),
      ),
    );

    expect(find.text('Bienvenue sur MboaPOS'), findsOneWidget);
    expect(find.text('Gérez vos ventes et votre stock, même hors ligne.'),
        findsOneWidget);
    expect(find.text('Continuer'), findsOneWidget);
    expect(find.text('Langue'), findsOneWidget);
  });

  testWidgets('startup reaches welcome after auth and welcome state resolve',
      (tester) async {
    final authResult = Completer<StaffUser?>();
    final welcomeResult = Completer<bool>();
    final container = ProviderContainer(
      overrides: [
        authProvider
            .overrideWith(() => _DeferredAuthNotifier(authResult.future)),
        firstRunWelcomeProvider
            .overrideWith(() => _DeferredWelcomeNotifier(welcomeResult.future)),
      ],
    );
    addTearDown(container.dispose);

    final router = container.read(appRouterProvider);
    await tester.binding.setSurfaceSize(const Size(550, 700));
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('fr'),
          routerConfig: router,
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(EntryStartupScreen), findsOneWidget);

    authResult.complete(null);
    welcomeResult.complete(false);
    await tester.pumpAndSettle();

    expect(container.read(appRouterProvider), same(router));
    expect(find.text('Bienvenue sur MboaPOS'), findsOneWidget);
    expect(find.text('Continuer'), findsOneWidget);
  });
}
