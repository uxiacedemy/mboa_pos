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

  @override
  String get storeSubtitle => 'Caisse et inventaire';

  @override
  String get clear => 'Effacer';

  @override
  String get scanner => 'Scanner';

  @override
  String get products => 'Produits';

  @override
  String get quantity => 'Qté';

  @override
  String get unitPrice => 'Prix';

  @override
  String availableProducts(int count) {
    return '$count disponibles';
  }

  @override
  String get allCategories => 'Toutes les catégories';

  @override
  String get addProduct => 'Ajouter';

  @override
  String get outOfStock => 'Rupture de stock';

  @override
  String get cart => 'Panier';

  @override
  String get emptyCart => 'Votre panier est vide';

  @override
  String get proceedPayment => 'Procéder au paiement';

  @override
  String get remove => 'Supprimer';

  @override
  String get decrease => 'Diminuer la quantité';

  @override
  String get increase => 'Augmenter la quantité';

  @override
  String get receiptTitle => 'Reçu';

  @override
  String get shareReceipt => 'Partager le reçu';

  @override
  String get printReceipt => 'Imprimer le reçu';

  @override
  String get sharePdf => 'Partager le PDF';

  @override
  String get newSale => 'Nouvelle vente';

  @override
  String get receiptNumber => 'Reçu N°';

  @override
  String get date => 'Date';

  @override
  String get cashier => 'Caissier';

  @override
  String get subtotal => 'Sous-total HT';

  @override
  String get discount => 'Remise';

  @override
  String get delivery => 'Livraison';

  @override
  String tax(String rate) {
    return 'Taxe ($rate%)';
  }

  @override
  String get total => 'TOTAL TTC';

  @override
  String get payment => 'Paiement';

  @override
  String get paymentReference => 'Référence';

  @override
  String get receiptShared => 'Reçu PDF prêt à être partagé.';

  @override
  String get receiptPrinted => 'Reçu envoyé à l\'impression.';

  @override
  String receiptActionFailed(String error) {
    return 'Impossible de traiter le reçu : $error';
  }

  @override
  String get organizationNiu => 'NIU';

  @override
  String get organizationAddress => 'Adresse non configurée';

  @override
  String get scannerUnavailable => 'Scanner indisponible sur cet appareil';

  @override
  String get thankYou => 'Merci de votre visite !';

  @override
  String get authStaff => 'Équipe';

  @override
  String get authOwner => 'Propriétaire';

  @override
  String get loginLanguageLabel => 'Langue';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageEnglish => 'Anglais';

  @override
  String get welcomeTitle => 'Bienvenue sur MboaPOS';

  @override
  String get welcomeBody => 'Gérez vos ventes et votre stock, même hors ligne.';

  @override
  String get welcomeStart => 'Continuer';

  @override
  String get welcomeContinueError =>
      'Impossible d’enregistrer votre choix. Réessayez.';

  @override
  String get entryChoiceTitle => 'Comment souhaitez-vous continuer ?';

  @override
  String get entryChoiceDescription => 'Choisissez votre espace.';

  @override
  String get staffLoginChoice => 'Connexion de l’équipe';

  @override
  String get ownerLoginChoice => 'Connexion du propriétaire';

  @override
  String get backToEntry => 'Changer de méthode';

  @override
  String get entryLoadingError =>
      'Impossible de préparer le démarrage. Vérifiez la connexion ou le stockage, puis réessayez.';

  @override
  String get entryRetry => 'Réessayer';

  @override
  String get entryContinueToSignIn => 'Continuer vers la connexion';

  @override
  String get authWelcome => 'Bienvenue sur MboaPOS';

  @override
  String get authSubtitle =>
      'La caisse simple pour garder votre activité sous contrôle.';

  @override
  String get authStaffHint =>
      'Connectez-vous avec votre identifiant et votre PIN.';

  @override
  String get authOwnerHint => 'Accédez à votre espace de gestion.';

  @override
  String get staffId => 'Identifiant staff';

  @override
  String get pin => 'PIN sécurisé';

  @override
  String get email => 'Adresse e-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get showPin => 'Afficher le PIN';

  @override
  String get hidePin => 'Masquer le PIN';

  @override
  String get showPassword => 'Afficher le mot de passe';

  @override
  String get hidePassword => 'Masquer le mot de passe';

  @override
  String get signIn => 'Se connecter';

  @override
  String get signingIn => 'Connexion…';

  @override
  String get forgotPin => 'PIN oublié ? Contactez votre administrateur.';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get resetSent =>
      'Si ce compte existe, un e-mail de réinitialisation a été envoyé.';

  @override
  String get createBusiness => 'Créer un compte entreprise';

  @override
  String get businessName => 'Nom de l’entreprise';

  @override
  String get createAccount => 'Créer le compte';

  @override
  String get creatingAccount => 'Création…';

  @override
  String get verificationSent =>
      'Compte créé. Vérifiez votre e-mail avant de vous connecter.';

  @override
  String get backToLogin => 'Retour à la connexion';

  @override
  String get passwordRequirement => '8 caractères minimum';

  @override
  String get brandPromise =>
      'Vendez vite. Suivez votre stock. Gardez le contrôle.';

  @override
  String get brandBenefitOne => 'Une caisse claire et rapide';

  @override
  String get brandBenefitTwo => 'Stock visible à chaque vente';

  @override
  String get brandBenefitThree => 'Conçu pour les commerces locaux';

  @override
  String get authInvalid => 'Vérifiez vos informations et réessayez.';

  @override
  String get authNetwork => 'Connexion réseau indisponible.';

  @override
  String get authDisabled => 'Ce compte est désactivé.';

  @override
  String get authGeneric => 'Connexion impossible. Réessayez.';

  @override
  String get authClose => 'Fermer';

  @override
  String get firebaseSetupTitle => 'Firebase n’est pas configuré';

  @override
  String get firebaseSetupBody =>
      'Ajoutez la configuration Firebase de cette plateforme, puis relancez l’application.';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get appearance => 'Apparence';

  @override
  String get appearanceDescription =>
      'Choisissez l’affichage le plus confortable pour votre caisse.';

  @override
  String get lightTheme => 'Écran blanc';

  @override
  String get darkTheme => 'Écran noir';

  @override
  String get account => 'Compte';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get signOutDescription => 'Fermer la session sur cet appareil';

  @override
  String get businessProfile => 'Informations de l’entreprise';

  @override
  String get businessNameLabel => 'Nom de l’entreprise';

  @override
  String get organizationNiuLabel => 'NIU (facultatif)';

  @override
  String get businessAddressLabel => 'Adresse (facultatif)';

  @override
  String get saveBusinessProfile => 'Enregistrer les informations';

  @override
  String get taxSettings => 'Paramètres de TVA';

  @override
  String get taxEnabled => 'Appliquer la TVA aux ventes';

  @override
  String get taxRateLabel => 'Taux de TVA (%)';

  @override
  String get taxRateOptional => 'Laisser vide pour désactiver la TVA';

  @override
  String get saveTaxSettings => 'Enregistrer la TVA';

  @override
  String get settingsSaved => 'Paramètres enregistrés.';

  @override
  String settingsSaveFailed(String error) {
    return 'Impossible d’enregistrer : $error';
  }

  @override
  String get settingsUnavailable => 'Paramètres du commerce indisponibles.';

  @override
  String get settingsRetry => 'Réessayer';

  @override
  String get inventoryTitle => 'Inventaire';

  @override
  String get inventoryComingSoon =>
      'La gestion de l’inventaire sera bientôt disponible.';

  @override
  String get reportsTitle => 'Rapports';

  @override
  String get reportsComingSoon => 'Les rapports seront bientôt disponibles.';

  @override
  String get posSubtitle => 'Caisse MboaPOS';

  @override
  String get catalogSearch => 'Rechercher un produit ou un code-barres';

  @override
  String get productsHeading => 'Produits';

  @override
  String availableCount(int count) {
    return '$count disponibles';
  }

  @override
  String stockCount(int count) {
    return 'Stock $count';
  }

  @override
  String get outOfStockShort => 'Épuisé';

  @override
  String get addToCart => 'Ajouter';

  @override
  String get cartTitle => 'Panier';

  @override
  String cartItemCount(int count) {
    return '$count article(s)';
  }

  @override
  String get emptyCartMessage => 'Votre panier est vide.';

  @override
  String get totalLabel => 'Total';

  @override
  String get proceedToPayment => 'Passer au paiement';

  @override
  String get checkout => 'Encaisser';

  @override
  String get noMatchingProducts =>
      'Aucun produit ne correspond à votre recherche.';

  @override
  String get catalogLoadFailed =>
      'Le catalogue n’a pas pu être actualisé. Les produits enregistrés hors ligne restent disponibles.';

  @override
  String get paymentTitle => 'Encaissement';

  @override
  String cartSummary(int count) {
    return 'Articles ($count)';
  }

  @override
  String get subtotalLabel => 'Sous-total';

  @override
  String get adjustments => 'Ajustements';

  @override
  String get discountFCFA => 'Remise (FCFA)';

  @override
  String get deliveryFCFA => 'Livraison (FCFA)';

  @override
  String get taxIncluded => 'TVA incluse';

  @override
  String get taxDisabled => 'TVA désactivée';

  @override
  String get paymentMethodTitle => 'Mode de paiement';

  @override
  String get cashMethod => 'Espèces';

  @override
  String get cashSubtitle => 'Paiement en espèces';

  @override
  String get mtnMethod => 'MTN Mobile Money';

  @override
  String get orangeMethod => 'Orange Money';

  @override
  String get manualPaymentSubtitle => 'Le vendeur confirme la réception';

  @override
  String get otherMethod => 'Autre';

  @override
  String get otherPaymentSubtitle => 'Virement, chèque ou autre mode';

  @override
  String get transactionReferenceLabel => 'Référence de transaction';

  @override
  String get transactionReferenceHint =>
      'Référence visible sur le reçu de paiement';

  @override
  String get paymentReferenceRequired => 'Saisissez la référence du paiement.';

  @override
  String saleFailed(String error) {
    return 'Échec de la vente : $error';
  }

  @override
  String saleNeedsReview(String error) {
    return 'Vente enregistrée localement et à vérifier : $error';
  }

  @override
  String get saleSavedOffline =>
      'Vente enregistrée hors ligne. La synchronisation reprendra automatiquement.';

  @override
  String confirmSale(String amount) {
    return 'Confirmer — $amount';
  }

  @override
  String get receiptProvisional =>
      'Ticket provisoire — synchronisation en attente';

  @override
  String get receiptNeedsReview =>
      'Vente à vérifier avant confirmation serveur';

  @override
  String get receiptNotFiscal =>
      'Document non fiscal — informations fiscales non vérifiées';

  @override
  String get receiptFiscalVerified => 'Profil fiscal vérifié';

  @override
  String get receiptLocalTime => 'Heure locale provisoire';

  @override
  String get organizationNameMissing => 'Commerce';

  @override
  String get organizationAddressMissing => 'Adresse non renseignée';

  @override
  String get organizationNiuMissing => 'Non renseigné';

  @override
  String get taxFieldInvalid => 'Saisissez un taux entre 0 et 100 %.';

  @override
  String get businessNameRequired => 'Saisissez le nom de l’entreprise.';

  @override
  String receiptTax(Object rate) {
    return 'TVA ($rate %)';
  }

  @override
  String get authInputRequired => 'Saisissez vos identifiants pour continuer.';

  @override
  String get authVerifyEmail =>
      'Vérifiez votre adresse e-mail avant de vous connecter.';

  @override
  String get authBusinessUnlinked =>
      'Ce compte n’est pas membre actif d’un commerce MboaPOS.';

  @override
  String get authOwnerRequired =>
      'Un accès propriétaire ou administrateur est requis.';

  @override
  String get authTooManyAttempts =>
      'Trop de tentatives. Patientez avant de réessayer.';

  @override
  String get authAccountExists =>
      'Un compte existe déjà pour cette adresse e-mail.';

  @override
  String get authWeakPassword =>
      'Choisissez un mot de passe plus fort d’au moins 8 caractères.';

  @override
  String get authInvalidEmail => 'Saisissez une adresse e-mail valide.';

  @override
  String get businessSetupUnavailable =>
      'La configuration du commerce est temporairement indisponible.';

  @override
  String get businessSetupInvalid =>
      'Les informations du commerce n’ont pas pu être validées.';

  @override
  String get businessSetupRetry =>
      'La configuration est incomplète. Vérifiez la connexion et réessayez.';

  @override
  String get businessCreateFailed =>
      'Impossible de créer le compte du commerce. Réessayez.';
}
