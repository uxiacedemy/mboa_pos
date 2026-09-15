// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'MboaPOS';

  @override
  String get posTitle => 'Nouvelle Vente';

  @override
  String get searchHint => 'Rechercher ou scanner...';

  @override
  String get encaisser => 'Encaisser';

  @override
  String get cartEmpty => 'Panier vide';

  @override
  String get noProducts => 'Aucun produit disponible';

  @override
  String noResults(String query) {
    return 'Aucun résultat pour \"$query\"';
  }

  @override
  String articles(int count) {
    return '$count article(s)';
  }

  @override
  String get synced => 'Synchronisé';

  @override
  String get pending => 'En attente';

  @override
  String get offline => 'Hors ligne';

  @override
  String get conflict => 'Conflit';

  @override
  String get navSales => 'Ventes';

  @override
  String get navInventory => 'Inventaire';

  @override
  String get navReports => 'Rapports';

  @override
  String get navSettings => 'Paramètres';

  @override
  String get loginTitle => 'Connexion';

  @override
  String get loginSubtitle => 'Point de Vente Intelligent';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get loginButton => 'Se connecter';

  @override
  String get comingSoon => 'Bientôt disponible';

  @override
  String get paymentComingSoon => 'Paiement — bientôt disponible';
}
