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
    return 'Aucun rÃ©sultat pour \"$query\"';
  }

  @override
  String articles(int count) {
    return '$count article(s)';
  }

  @override
  String get synced => 'SynchronisÃ©';

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
  String get navSettings => 'ParamÃ¨tres';

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
  String get comingSoon => 'BientÃ´t disponible';

  @override
  String get paymentComingSoon => 'Paiement â€” bientÃ´t disponible';

  @override
  String get storeSubtitle => 'Caisse et inventaire';

  @override
  String get clear => 'Effacer';

  @override
  String get scanner => 'Scanner';

  @override
  String get products => 'Produits';

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
}
