import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mboa_pos/features/auth/presentation/screens/login_screen.dart';
import 'package:mboa_pos/l10n/app_localizations.dart';

void main() {
  testWidgets('login screen renders staff and owner authentication controls',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(550, 700));
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('fr'),
        home: LoginScreen(),
      ),
    );

    expect(find.text('Bienvenue sur MboaPOS'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Identifiant staff'),
        findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'PIN sécurisé'), findsOneWidget);
    expect(find.text('Créer un compte entreprise'), findsOneWidget);
  });
}
