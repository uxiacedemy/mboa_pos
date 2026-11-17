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
  /// **'Aucun résultat pour \"{query}\"'**
  String noResults(String query);

  /// No description provided for @articles.
  ///
  /// In fr, this message translates to:
  /// **'{count} article(s)'**
  String articles(int count);

  /// No description provided for @synced.
  ///
  /// In fr, this message translates to:
  /// **'Synchronisé'**
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
  /// **'Paramètres'**
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
  /// **'Bientôt disponible'**
  String get comingSoon;

  /// No description provided for @paymentComingSoon.
  ///
  /// In fr, this message translates to:
  /// **'Paiement — bientôt disponible'**
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

  /// No description provided for @quantity.
  ///
  /// In fr, this message translates to:
  /// **'Qté'**
  String get quantity;

  /// No description provided for @unitPrice.
  ///
  /// In fr, this message translates to:
  /// **'Prix'**
  String get unitPrice;

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

  /// No description provided for @loginLanguageLabel.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get loginLanguageLabel;

  /// No description provided for @languageFrench.
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// No description provided for @languageEnglish.
  ///
  /// In fr, this message translates to:
  /// **'Anglais'**
  String get languageEnglish;

  /// No description provided for @welcomeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue sur MboaPOS'**
  String get welcomeTitle;

  /// No description provided for @welcomeBody.
  ///
  /// In fr, this message translates to:
  /// **'Gérez vos ventes et votre stock, même hors ligne.'**
  String get welcomeBody;

  /// No description provided for @welcomeStart.
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get welcomeStart;

  /// No description provided for @welcomeContinueError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d’enregistrer votre choix. Réessayez.'**
  String get welcomeContinueError;

  /// No description provided for @entryChoiceTitle.
  ///
  /// In fr, this message translates to:
  /// **'Comment souhaitez-vous continuer ?'**
  String get entryChoiceTitle;

  /// No description provided for @entryChoiceDescription.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez votre espace.'**
  String get entryChoiceDescription;

  /// No description provided for @staffLoginChoice.
  ///
  /// In fr, this message translates to:
  /// **'Connexion de l’équipe'**
  String get staffLoginChoice;

  /// No description provided for @ownerLoginChoice.
  ///
  /// In fr, this message translates to:
  /// **'Connexion du propriétaire'**
  String get ownerLoginChoice;

  /// No description provided for @backToEntry.
  ///
  /// In fr, this message translates to:
  /// **'Changer de méthode'**
  String get backToEntry;

  /// No description provided for @entryLoadingError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de préparer le démarrage. Vérifiez la connexion ou le stockage, puis réessayez.'**
  String get entryLoadingError;

  /// No description provided for @entryRetry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get entryRetry;

  /// No description provided for @entryContinueToSignIn.
  ///
  /// In fr, this message translates to:
  /// **'Continuer vers la connexion'**
  String get entryContinueToSignIn;

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

  /// No description provided for @firebaseSetupTitle.
  ///
  /// In fr, this message translates to:
  /// **'Firebase n’est pas configuré'**
  String get firebaseSetupTitle;

  /// No description provided for @firebaseSetupBody.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez la configuration Firebase de cette plateforme, puis relancez l’application.'**
  String get firebaseSetupBody;

  /// No description provided for @settingsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get settingsTitle;

  /// No description provided for @appearance.
  ///
  /// In fr, this message translates to:
  /// **'Apparence'**
  String get appearance;

  /// No description provided for @appearanceDescription.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez l’affichage le plus confortable pour votre caisse.'**
  String get appearanceDescription;

  /// No description provided for @lightTheme.
  ///
  /// In fr, this message translates to:
  /// **'Écran blanc'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In fr, this message translates to:
  /// **'Écran noir'**
  String get darkTheme;

  /// No description provided for @account.
  ///
  /// In fr, this message translates to:
  /// **'Compte'**
  String get account;

  /// No description provided for @signOut.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get signOut;

  /// No description provided for @signOutDescription.
  ///
  /// In fr, this message translates to:
  /// **'Fermer la session sur cet appareil'**
  String get signOutDescription;

  /// No description provided for @businessProfile.
  ///
  /// In fr, this message translates to:
  /// **'Informations de l’entreprise'**
  String get businessProfile;

  /// No description provided for @businessNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom de l’entreprise'**
  String get businessNameLabel;

  /// No description provided for @organizationNiuLabel.
  ///
  /// In fr, this message translates to:
  /// **'NIU (facultatif)'**
  String get organizationNiuLabel;

  /// No description provided for @businessAddressLabel.
  ///
  /// In fr, this message translates to:
  /// **'Adresse (facultatif)'**
  String get businessAddressLabel;

  /// No description provided for @saveBusinessProfile.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer les informations'**
  String get saveBusinessProfile;

  /// No description provided for @taxSettings.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres de TVA'**
  String get taxSettings;

  /// No description provided for @taxEnabled.
  ///
  /// In fr, this message translates to:
  /// **'Appliquer la TVA aux ventes'**
  String get taxEnabled;

  /// No description provided for @taxRateLabel.
  ///
  /// In fr, this message translates to:
  /// **'Taux de TVA (%)'**
  String get taxRateLabel;

  /// No description provided for @taxRateOptional.
  ///
  /// In fr, this message translates to:
  /// **'Laisser vide pour désactiver la TVA'**
  String get taxRateOptional;

  /// No description provided for @saveTaxSettings.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer la TVA'**
  String get saveTaxSettings;

  /// No description provided for @settingsSaved.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres enregistrés.'**
  String get settingsSaved;

  /// No description provided for @settingsSaveFailed.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d’enregistrer : {error}'**
  String settingsSaveFailed(String error);

  /// No description provided for @settingsUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres du commerce indisponibles.'**
  String get settingsUnavailable;

  /// No description provided for @settingsRetry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get settingsRetry;

  /// No description provided for @inventoryTitle.
  ///
  /// In fr, this message translates to:
  /// **'Inventaire'**
  String get inventoryTitle;

  /// No description provided for @inventoryComingSoon.
  ///
  /// In fr, this message translates to:
  /// **'La gestion de l’inventaire sera bientôt disponible.'**
  String get inventoryComingSoon;

  /// No description provided for @reportsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Rapports'**
  String get reportsTitle;

  /// No description provided for @reportsComingSoon.
  ///
  /// In fr, this message translates to:
  /// **'Les rapports seront bientôt disponibles.'**
  String get reportsComingSoon;

  /// No description provided for @posSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Caisse MboaPOS'**
  String get posSubtitle;

  /// No description provided for @catalogSearch.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un produit ou un code-barres'**
  String get catalogSearch;

  /// No description provided for @productsHeading.
  ///
  /// In fr, this message translates to:
  /// **'Produits'**
  String get productsHeading;

  /// No description provided for @availableCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} disponibles'**
  String availableCount(int count);

  /// No description provided for @stockCount.
  ///
  /// In fr, this message translates to:
  /// **'Stock {count}'**
  String stockCount(int count);

  /// No description provided for @outOfStockShort.
  ///
  /// In fr, this message translates to:
  /// **'Épuisé'**
  String get outOfStockShort;

  /// No description provided for @addToCart.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter'**
  String get addToCart;

  /// No description provided for @cartTitle.
  ///
  /// In fr, this message translates to:
  /// **'Panier'**
  String get cartTitle;

  /// No description provided for @cartItemCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} article(s)'**
  String cartItemCount(int count);

  /// No description provided for @emptyCartMessage.
  ///
  /// In fr, this message translates to:
  /// **'Votre panier est vide.'**
  String get emptyCartMessage;

  /// No description provided for @totalLabel.
  ///
  /// In fr, this message translates to:
  /// **'Total'**
  String get totalLabel;

  /// No description provided for @proceedToPayment.
  ///
  /// In fr, this message translates to:
  /// **'Passer au paiement'**
  String get proceedToPayment;

  /// No description provided for @checkout.
  ///
  /// In fr, this message translates to:
  /// **'Encaisser'**
  String get checkout;

  /// No description provided for @noMatchingProducts.
  ///
  /// In fr, this message translates to:
  /// **'Aucun produit ne correspond à votre recherche.'**
  String get noMatchingProducts;

  /// No description provided for @catalogLoadFailed.
  ///
  /// In fr, this message translates to:
  /// **'Le catalogue n’a pas pu être actualisé. Les produits enregistrés hors ligne restent disponibles.'**
  String get catalogLoadFailed;

  /// No description provided for @paymentTitle.
  ///
  /// In fr, this message translates to:
  /// **'Encaissement'**
  String get paymentTitle;

  /// No description provided for @cartSummary.
  ///
  /// In fr, this message translates to:
  /// **'Articles ({count})'**
  String cartSummary(int count);

  /// No description provided for @subtotalLabel.
  ///
  /// In fr, this message translates to:
  /// **'Sous-total'**
  String get subtotalLabel;

  /// No description provided for @adjustments.
  ///
  /// In fr, this message translates to:
  /// **'Ajustements'**
  String get adjustments;

  /// No description provided for @discountFCFA.
  ///
  /// In fr, this message translates to:
  /// **'Remise (FCFA)'**
  String get discountFCFA;

  /// No description provided for @deliveryFCFA.
  ///
  /// In fr, this message translates to:
  /// **'Livraison (FCFA)'**
  String get deliveryFCFA;

  /// No description provided for @taxIncluded.
  ///
  /// In fr, this message translates to:
  /// **'TVA incluse'**
  String get taxIncluded;

  /// No description provided for @taxDisabled.
  ///
  /// In fr, this message translates to:
  /// **'TVA désactivée'**
  String get taxDisabled;

  /// No description provided for @paymentMethodTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mode de paiement'**
  String get paymentMethodTitle;

  /// No description provided for @cashMethod.
  ///
  /// In fr, this message translates to:
  /// **'Espèces'**
  String get cashMethod;

  /// No description provided for @cashSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Paiement en espèces'**
  String get cashSubtitle;

  /// No description provided for @mtnMethod.
  ///
  /// In fr, this message translates to:
  /// **'MTN Mobile Money'**
  String get mtnMethod;

  /// No description provided for @orangeMethod.
  ///
  /// In fr, this message translates to:
  /// **'Orange Money'**
  String get orangeMethod;

  /// No description provided for @manualPaymentSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Le vendeur confirme la réception'**
  String get manualPaymentSubtitle;

  /// No description provided for @otherMethod.
  ///
  /// In fr, this message translates to:
  /// **'Autre'**
  String get otherMethod;

  /// No description provided for @otherPaymentSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Virement, chèque ou autre mode'**
  String get otherPaymentSubtitle;

  /// No description provided for @transactionReferenceLabel.
  ///
  /// In fr, this message translates to:
  /// **'Référence de transaction'**
  String get transactionReferenceLabel;

  /// No description provided for @transactionReferenceHint.
  ///
  /// In fr, this message translates to:
  /// **'Référence visible sur le reçu de paiement'**
  String get transactionReferenceHint;

  /// No description provided for @paymentReferenceRequired.
  ///
  /// In fr, this message translates to:
  /// **'Saisissez la référence du paiement.'**
  String get paymentReferenceRequired;

  /// No description provided for @saleFailed.
  ///
  /// In fr, this message translates to:
  /// **'Échec de la vente : {error}'**
  String saleFailed(String error);

  /// No description provided for @saleNeedsReview.
  ///
  /// In fr, this message translates to:
  /// **'Vente enregistrée localement et à vérifier : {error}'**
  String saleNeedsReview(String error);

  /// No description provided for @saleSavedOffline.
  ///
  /// In fr, this message translates to:
  /// **'Vente enregistrée hors ligne. La synchronisation reprendra automatiquement.'**
  String get saleSavedOffline;

  /// No description provided for @confirmSale.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer — {amount}'**
  String confirmSale(String amount);

  /// No description provided for @receiptProvisional.
  ///
  /// In fr, this message translates to:
  /// **'Ticket provisoire — synchronisation en attente'**
  String get receiptProvisional;

  /// No description provided for @receiptNeedsReview.
  ///
  /// In fr, this message translates to:
  /// **'Vente à vérifier avant confirmation serveur'**
  String get receiptNeedsReview;

  /// No description provided for @receiptNotFiscal.
  ///
  /// In fr, this message translates to:
  /// **'Document non fiscal — informations fiscales non vérifiées'**
  String get receiptNotFiscal;

  /// No description provided for @receiptFiscalVerified.
  ///
  /// In fr, this message translates to:
  /// **'Profil fiscal vérifié'**
  String get receiptFiscalVerified;

  /// No description provided for @receiptLocalTime.
  ///
  /// In fr, this message translates to:
  /// **'Heure locale provisoire'**
  String get receiptLocalTime;

  /// No description provided for @organizationNameMissing.
  ///
  /// In fr, this message translates to:
  /// **'Commerce'**
  String get organizationNameMissing;

  /// No description provided for @organizationAddressMissing.
  ///
  /// In fr, this message translates to:
  /// **'Adresse non renseignée'**
  String get organizationAddressMissing;

  /// No description provided for @organizationNiuMissing.
  ///
  /// In fr, this message translates to:
  /// **'Non renseigné'**
  String get organizationNiuMissing;

  /// No description provided for @taxFieldInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Saisissez un taux entre 0 et 100 %.'**
  String get taxFieldInvalid;

  /// No description provided for @businessNameRequired.
  ///
  /// In fr, this message translates to:
  /// **'Saisissez le nom de l’entreprise.'**
  String get businessNameRequired;

  /// No description provided for @receiptTax.
  ///
  /// In fr, this message translates to:
  /// **'TVA ({rate} %)'**
  String receiptTax(Object rate);

  /// No description provided for @authInputRequired.
  ///
  /// In fr, this message translates to:
  /// **'Saisissez vos identifiants pour continuer.'**
  String get authInputRequired;

  /// No description provided for @authVerifyEmail.
  ///
  /// In fr, this message translates to:
  /// **'Vérifiez votre adresse e-mail avant de vous connecter.'**
  String get authVerifyEmail;

  /// No description provided for @authBusinessUnlinked.
  ///
  /// In fr, this message translates to:
  /// **'Ce compte n’est pas membre actif d’un commerce MboaPOS.'**
  String get authBusinessUnlinked;

  /// No description provided for @authOwnerRequired.
  ///
  /// In fr, this message translates to:
  /// **'Un accès propriétaire ou administrateur est requis.'**
  String get authOwnerRequired;

  /// No description provided for @authTooManyAttempts.
  ///
  /// In fr, this message translates to:
  /// **'Trop de tentatives. Patientez avant de réessayer.'**
  String get authTooManyAttempts;

  /// No description provided for @authAccountExists.
  ///
  /// In fr, this message translates to:
  /// **'Un compte existe déjà pour cette adresse e-mail.'**
  String get authAccountExists;

  /// No description provided for @authWeakPassword.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez un mot de passe plus fort d’au moins 8 caractères.'**
  String get authWeakPassword;

  /// No description provided for @authInvalidEmail.
  ///
  /// In fr, this message translates to:
  /// **'Saisissez une adresse e-mail valide.'**
  String get authInvalidEmail;

  /// No description provided for @businessSetupUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'La configuration du commerce est temporairement indisponible.'**
  String get businessSetupUnavailable;

  /// No description provided for @businessSetupInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Les informations du commerce n’ont pas pu être validées.'**
  String get businessSetupInvalid;

  /// No description provided for @businessSetupRetry.
  ///
  /// In fr, this message translates to:
  /// **'La configuration est incomplète. Vérifiez la connexion et réessayez.'**
  String get businessSetupRetry;

  /// No description provided for @businessCreateFailed.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de créer le compte du commerce. Réessayez.'**
  String get businessCreateFailed;
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
