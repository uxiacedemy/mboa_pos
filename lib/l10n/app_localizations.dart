import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In fr, this message translates to:
  /// **'MboaPOS'**
  String get appTitle;

  /// No description provided for @posTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle Vente'**
  String get posTitle;

  /// No description provided for @searchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher ou scanner...'**
  String get searchHint;

  /// No description provided for @encaisser.
  ///
  /// In fr, this message translates to:
  /// **'Encaisser'**
  String get encaisser;

  /// No description provided for @cartEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Panier vide'**
  String get cartEmpty;

  /// No description provided for @noProducts.
  ///
  /// In fr, this message translates to:
  /// **'Aucun produit disponible'**
  String get noProducts;

  /// No description provided for @noResults.
  ///
  /// In fr, this message translates to:
  /// **'Aucun rÃ©sultat pour \"{query}\"'**
  String noResults(String query);

  /// No description provided for @articles.
  ///
  /// In fr, this message translates to:
  /// **'{count} article(s)'**
  String articles(int count);

  /// No description provided for @synced.
  ///
  /// In fr, this message translates to:
  /// **'SynchronisÃ©'**
  String get synced;

  /// No description provided for @pending.
  ///
  /// In fr, this message translates to:
  /// **'En attente'**
  String get pending;

  /// No description provided for @offline.
  ///
  /// In fr, this message translates to:
  /// **'Hors ligne'**
  String get offline;

  /// No description provided for @conflict.
  ///
  /// In fr, this message translates to:
  /// **'Conflit'**
  String get conflict;

  /// No description provided for @navSales.
  ///
  /// In fr, this message translates to:
  /// **'Ventes'**
  String get navSales;

  /// No description provided for @navInventory.
  ///
  /// In fr, this message translates to:
  /// **'Inventaire'**
  String get navInventory;

  /// No description provided for @navReports.
  ///
  /// In fr, this message translates to:
  /// **'Rapports'**
  String get navReports;

  /// No description provided for @navSettings.
  ///
  /// In fr, this message translates to:
  /// **'ParamÃ¨tres'**
  String get navSettings;

  /// No description provided for @loginTitle.
  ///
  /// In fr, this message translates to:
  /// **'Connexion'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Point de Vente Intelligent'**
  String get loginSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In fr, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get passwordLabel;

  /// No description provided for @loginButton.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get loginButton;

  /// No description provided for @comingSoon.
  ///
  /// In fr, this message translates to:
  /// **'BientÃ´t disponible'**
  String get comingSoon;

  /// No description provided for @paymentComingSoon.
  ///
  /// In fr, this message translates to:
  /// **'Paiement â€” bientÃ´t disponible'**
  String get paymentComingSoon;

  /// No description provided for @storeSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Caisse et inventaire'**
  String get storeSubtitle;

  /// No description provided for @clear.
  ///
  /// In fr, this message translates to:
  /// **'Effacer'**
  String get clear;

  /// No description provided for @scanner.
  ///
  /// In fr, this message translates to:
  /// **'Scanner'**
  String get scanner;

  /// No description provided for @products.
  ///
  /// In fr, this message translates to:
  /// **'Produits'**
  String get products;

  /// No description provided for @availableProducts.
  ///
  /// In fr, this message translates to:
  /// **'{count} disponibles'**
  String availableProducts(int count);

  /// No description provided for @allCategories.
  ///
  /// In fr, this message translates to:
  /// **'Toutes les catégories'**
  String get allCategories;

  /// No description provided for @addProduct.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter'**
  String get addProduct;

  /// No description provided for @outOfStock.
  ///
  /// In fr, this message translates to:
  /// **'Rupture de stock'**
  String get outOfStock;

  /// No description provided for @cart.
  ///
  /// In fr, this message translates to:
  /// **'Panier'**
  String get cart;

  /// No description provided for @emptyCart.
  ///
  /// In fr, this message translates to:
  /// **'Votre panier est vide'**
  String get emptyCart;

  /// No description provided for @proceedPayment.
  ///
  /// In fr, this message translates to:
  /// **'Procéder au paiement'**
  String get proceedPayment;

  /// No description provided for @remove.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get remove;

  /// No description provided for @decrease.
  ///
  /// In fr, this message translates to:
  /// **'Diminuer la quantité'**
  String get decrease;

  /// No description provided for @increase.
  ///
  /// In fr, this message translates to:
  /// **'Augmenter la quantité'**
  String get increase;

  /// No description provided for @receiptTitle.
  ///
  /// In fr, this message translates to:
  /// **'Reçu'**
  String get receiptTitle;

  /// No description provided for @shareReceipt.
  ///
  /// In fr, this message translates to:
  /// **'Partager le reçu'**
  String get shareReceipt;

  /// No description provided for @printReceipt.
  ///
  /// In fr, this message translates to:
  /// **'Imprimer le reçu'**
  String get printReceipt;

  /// No description provided for @sharePdf.
  ///
  /// In fr, this message translates to:
  /// **'Partager le PDF'**
  String get sharePdf;

  /// No description provided for @newSale.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle vente'**
  String get newSale;

  /// No description provided for @receiptNumber.
  ///
  /// In fr, this message translates to:
  /// **'Reçu N°'**
  String get receiptNumber;

  /// No description provided for @date.
  ///
  /// In fr, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @cashier.
  ///
  /// In fr, this message translates to:
  /// **'Caissier'**
  String get cashier;

  /// No description provided for @subtotal.
  ///
  /// In fr, this message translates to:
  /// **'Sous-total HT'**
  String get subtotal;

  /// No description provided for @discount.
  ///
  /// In fr, this message translates to:
  /// **'Remise'**
  String get discount;

  /// No description provided for @delivery.
  ///
  /// In fr, this message translates to:
  /// **'Livraison'**
  String get delivery;

  /// No description provided for @tax.
  ///
  /// In fr, this message translates to:
  /// **'Taxe ({rate}%)'**
  String tax(String rate);

  /// No description provided for @total.
  ///
  /// In fr, this message translates to:
  /// **'TOTAL TTC'**
  String get total;

  /// No description provided for @payment.
  ///
  /// In fr, this message translates to:
  /// **'Paiement'**
  String get payment;

  /// No description provided for @paymentReference.
  ///
  /// In fr, this message translates to:
  /// **'Référence'**
  String get paymentReference;

  /// No description provided for @receiptShared.
  ///
  /// In fr, this message translates to:
  /// **'Reçu PDF prêt à être partagé.'**
  String get receiptShared;

  /// No description provided for @receiptPrinted.
  ///
  /// In fr, this message translates to:
  /// **'Reçu envoyé à l\'impression.'**
  String get receiptPrinted;

  /// No description provided for @receiptActionFailed.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de traiter le reçu : {error}'**
  String receiptActionFailed(String error);

  /// No description provided for @organizationNiu.
  ///
  /// In fr, this message translates to:
  /// **'NIU'**
  String get organizationNiu;

  /// No description provided for @organizationAddress.
  ///
  /// In fr, this message translates to:
  /// **'Adresse non configurée'**
  String get organizationAddress;

  /// No description provided for @scannerUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'Scanner indisponible sur cet appareil'**
  String get scannerUnavailable;

  /// No description provided for @thankYou.
  ///
  /// In fr, this message translates to:
  /// **'Merci de votre visite !'**
  String get thankYou;

  /// No description provided for @authStaff.
  ///
  /// In fr, this message translates to:
  /// **'Équipe'**
  String get authStaff;

  /// No description provided for @authOwner.
  ///
  /// In fr, this message translates to:
  /// **'Propriétaire'**
  String get authOwner;

  /// No description provided for @authWelcome.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue sur MboaPOS'**
  String get authWelcome;

  /// No description provided for @authSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'La caisse simple pour garder votre activité sous contrôle.'**
  String get authSubtitle;

  /// No description provided for @authStaffHint.
  ///
  /// In fr, this message translates to:
  /// **'Connectez-vous avec votre identifiant et votre PIN.'**
  String get authStaffHint;

  /// No description provided for @authOwnerHint.
  ///
  /// In fr, this message translates to:
  /// **'Accédez à votre espace de gestion.'**
  String get authOwnerHint;

  /// No description provided for @staffId.
  ///
  /// In fr, this message translates to:
  /// **'Identifiant staff'**
  String get staffId;

  /// No description provided for @pin.
  ///
  /// In fr, this message translates to:
  /// **'PIN sécurisé'**
  String get pin;

  /// No description provided for @email.
  ///
  /// In fr, this message translates to:
  /// **'Adresse e-mail'**
  String get email;

  /// No description provided for @password.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get password;

  /// No description provided for @showPin.
  ///
  /// In fr, this message translates to:
  /// **'Afficher le PIN'**
  String get showPin;

  /// No description provided for @hidePin.
  ///
  /// In fr, this message translates to:
  /// **'Masquer le PIN'**
  String get hidePin;

  /// No description provided for @showPassword.
  ///
  /// In fr, this message translates to:
  /// **'Afficher le mot de passe'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In fr, this message translates to:
  /// **'Masquer le mot de passe'**
  String get hidePassword;

  /// No description provided for @signIn.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get signIn;

  /// No description provided for @signingIn.
  ///
  /// In fr, this message translates to:
  /// **'Connexion…'**
  String get signingIn;

  /// No description provided for @forgotPin.
  ///
  /// In fr, this message translates to:
  /// **'PIN oublié ? Contactez votre administrateur.'**
  String get forgotPin;

  /// No description provided for @forgotPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié ?'**
  String get forgotPassword;

  /// No description provided for @resetSent.
  ///
  /// In fr, this message translates to:
  /// **'Si ce compte existe, un e-mail de réinitialisation a été envoyé.'**
  String get resetSent;

  /// No description provided for @createBusiness.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte entreprise'**
  String get createBusiness;

  /// No description provided for @businessName.
  ///
  /// In fr, this message translates to:
  /// **'Nom de l’entreprise'**
  String get businessName;

  /// No description provided for @createAccount.
  ///
  /// In fr, this message translates to:
  /// **'Créer le compte'**
  String get createAccount;

  /// No description provided for @creatingAccount.
  ///
  /// In fr, this message translates to:
  /// **'Création…'**
  String get creatingAccount;

  /// No description provided for @verificationSent.
  ///
  /// In fr, this message translates to:
  /// **'Compte créé. Vérifiez votre e-mail avant de vous connecter.'**
  String get verificationSent;

  /// No description provided for @backToLogin.
  ///
  /// In fr, this message translates to:
  /// **'Retour à la connexion'**
  String get backToLogin;

  /// No description provided for @passwordRequirement.
  ///
  /// In fr, this message translates to:
  /// **'8 caractères minimum'**
  String get passwordRequirement;

  /// No description provided for @brandPromise.
  ///
  /// In fr, this message translates to:
  /// **'Vendez vite. Suivez votre stock. Gardez le contrôle.'**
  String get brandPromise;

  /// No description provided for @brandBenefitOne.
  ///
  /// In fr, this message translates to:
  /// **'Une caisse claire et rapide'**
  String get brandBenefitOne;

  /// No description provided for @brandBenefitTwo.
  ///
  /// In fr, this message translates to:
  /// **'Stock visible à chaque vente'**
  String get brandBenefitTwo;

  /// No description provided for @brandBenefitThree.
  ///
  /// In fr, this message translates to:
  /// **'Conçu pour les commerces locaux'**
  String get brandBenefitThree;

  /// No description provided for @authInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Vérifiez vos informations et réessayez.'**
  String get authInvalid;

  /// No description provided for @authNetwork.
  ///
  /// In fr, this message translates to:
  /// **'Connexion réseau indisponible.'**
  String get authNetwork;

  /// No description provided for @authDisabled.
  ///
  /// In fr, this message translates to:
  /// **'Ce compte est désactivé.'**
  String get authDisabled;

  /// No description provided for @authGeneric.
  ///
  /// In fr, this message translates to:
  /// **'Connexion impossible. Réessayez.'**
  String get authGeneric;

  /// No description provided for @authClose.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get authClose;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
