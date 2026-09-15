// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'MboaPOS';

  @override
  String get posTitle => 'New Sale';

  @override
  String get searchHint => 'Search or scan...';

  @override
  String get encaisser => 'Checkout';

  @override
  String get cartEmpty => 'Empty cart';

  @override
  String get noProducts => 'No products available';

  @override
  String noResults(String query) {
    return 'No results for \"$query\"';
  }

  @override
  String articles(int count) {
    return '$count item(s)';
  }

  @override
  String get synced => 'Synced';

  @override
  String get pending => 'Pending';

  @override
  String get offline => 'Offline';

  @override
  String get conflict => 'Conflict';

  @override
  String get navSales => 'Sales';

  @override
  String get navInventory => 'Inventory';

  @override
  String get navReports => 'Reports';

  @override
  String get navSettings => 'Settings';

  @override
  String get loginTitle => 'Login';

  @override
  String get loginSubtitle => 'Smart Point of Sale';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get loginButton => 'Sign in';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get paymentComingSoon => 'Payment — coming soon';
}
