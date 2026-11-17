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

  @override
  String get storeSubtitle => 'Checkout and inventory';

  @override
  String get clear => 'Clear';

  @override
  String get scanner => 'Scanner';

  @override
  String get products => 'Products';

  @override
  String get quantity => 'Qty';

  @override
  String get unitPrice => 'Unit price';

  @override
  String availableProducts(int count) {
    return '$count available';
  }

  @override
  String get allCategories => 'All categories';

  @override
  String get addProduct => 'Add';

  @override
  String get outOfStock => 'Out of stock';

  @override
  String get cart => 'Cart';

  @override
  String get emptyCart => 'Your cart is empty';

  @override
  String get proceedPayment => 'Proceed to payment';

  @override
  String get remove => 'Remove';

  @override
  String get decrease => 'Decrease quantity';

  @override
  String get increase => 'Increase quantity';

  @override
  String get receiptTitle => 'Receipt';

  @override
  String get shareReceipt => 'Share receipt';

  @override
  String get printReceipt => 'Print receipt';

  @override
  String get sharePdf => 'Share PDF';

  @override
  String get newSale => 'New sale';

  @override
  String get receiptNumber => 'Receipt No.';

  @override
  String get date => 'Date';

  @override
  String get cashier => 'Cashier';

  @override
  String get subtotal => 'Subtotal before tax';

  @override
  String get discount => 'Discount';

  @override
  String get delivery => 'Delivery';

  @override
  String tax(String rate) {
    return 'Tax ($rate%)';
  }

  @override
  String get total => 'TOTAL';

  @override
  String get payment => 'Payment';

  @override
  String get paymentReference => 'Reference';

  @override
  String get receiptShared => 'Receipt PDF is ready to share.';

  @override
  String get receiptPrinted => 'Receipt sent to the printer.';

  @override
  String receiptActionFailed(String error) {
    return 'Could not process receipt: $error';
  }

  @override
  String get organizationNiu => 'Tax ID';

  @override
  String get organizationAddress => 'Address not configured';

  @override
  String get scannerUnavailable => 'Scanner is unavailable on this device';

  @override
  String get thankYou => 'Thank you for your visit!';

  @override
  String get authStaff => 'Staff';

  @override
  String get authOwner => 'Owner';

  @override
  String get loginLanguageLabel => 'Language';

  @override
  String get languageFrench => 'French';

  @override
  String get languageEnglish => 'English';

  @override
  String get welcomeTitle => 'Welcome to MboaPOS';

  @override
  String get welcomeBody => 'Manage sales and stock, even while offline.';

  @override
  String get welcomeStart => 'Continue';

  @override
  String get welcomeContinueError =>
      'Couldn\'t save your choice. Please try again.';

  @override
  String get entryChoiceTitle => 'How would you like to continue?';

  @override
  String get entryChoiceDescription => 'Choose where you want to sign in.';

  @override
  String get staffLoginChoice => 'Staff sign in';

  @override
  String get ownerLoginChoice => 'Owner sign in';

  @override
  String get backToEntry => 'Choose another option';

  @override
  String get entryLoadingError =>
      'Couldn\'t prepare startup. Check your connection or storage, then try again.';

  @override
  String get entryRetry => 'Retry';

  @override
  String get entryContinueToSignIn => 'Continue to sign in';

  @override
  String get authWelcome => 'Welcome to MboaPOS';

  @override
  String get authSubtitle =>
      'The simple checkout that keeps your business in control.';

  @override
  String get authStaffHint => 'Sign in with your staff ID and PIN.';

  @override
  String get authOwnerHint => 'Access your business management space.';

  @override
  String get staffId => 'Staff ID';

  @override
  String get pin => 'Secure PIN';

  @override
  String get email => 'Email address';

  @override
  String get password => 'Password';

  @override
  String get showPin => 'Show PIN';

  @override
  String get hidePin => 'Hide PIN';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get signIn => 'Sign in';

  @override
  String get signingIn => 'Signing in…';

  @override
  String get forgotPin => 'Forgot your PIN? Contact your administrator.';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get resetSent =>
      'If this account exists, a reset email has been sent.';

  @override
  String get createBusiness => 'Create a business account';

  @override
  String get businessName => 'Business name';

  @override
  String get createAccount => 'Create account';

  @override
  String get creatingAccount => 'Creating…';

  @override
  String get verificationSent =>
      'Account created. Verify your email before signing in.';

  @override
  String get backToLogin => 'Back to sign in';

  @override
  String get passwordRequirement => 'At least 8 characters';

  @override
  String get brandPromise => 'Sell faster. Track stock. Stay in control.';

  @override
  String get brandBenefitOne => 'A clear, fast checkout';

  @override
  String get brandBenefitTwo => 'Stock visibility on every sale';

  @override
  String get brandBenefitThree => 'Built for local businesses';

  @override
  String get authInvalid => 'Check your details and try again.';

  @override
  String get authNetwork => 'Network connection unavailable.';

  @override
  String get authDisabled => 'This account is disabled.';

  @override
  String get authGeneric => 'Sign-in failed. Try again.';

  @override
  String get authClose => 'Close';

  @override
  String get firebaseSetupTitle => 'Firebase is not configured';

  @override
  String get firebaseSetupBody =>
      'Add the Firebase configuration for this platform, then restart the app.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get appearanceDescription =>
      'Choose the display that works best for your checkout.';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get account => 'Account';

  @override
  String get signOut => 'Sign out';

  @override
  String get signOutDescription => 'End the session on this device';

  @override
  String get businessProfile => 'Business information';

  @override
  String get businessNameLabel => 'Business name';

  @override
  String get organizationNiuLabel => 'Tax ID (optional)';

  @override
  String get businessAddressLabel => 'Address (optional)';

  @override
  String get saveBusinessProfile => 'Save business information';

  @override
  String get taxSettings => 'VAT settings';

  @override
  String get taxEnabled => 'Apply VAT to sales';

  @override
  String get taxRateLabel => 'VAT rate (%)';

  @override
  String get taxRateOptional => 'Leave blank to disable VAT';

  @override
  String get saveTaxSettings => 'Save VAT settings';

  @override
  String get settingsSaved => 'Settings saved.';

  @override
  String settingsSaveFailed(String error) {
    return 'Could not save settings: $error';
  }

  @override
  String get settingsUnavailable => 'Business settings are unavailable.';

  @override
  String get settingsRetry => 'Retry';

  @override
  String get inventoryTitle => 'Inventory';

  @override
  String get inventoryComingSoon => 'Inventory management is coming soon.';

  @override
  String get reportsTitle => 'Reports';

  @override
  String get reportsComingSoon => 'Reports are coming soon.';

  @override
  String get posSubtitle => 'MboaPOS checkout';

  @override
  String get catalogSearch => 'Search products or barcodes';

  @override
  String get productsHeading => 'Products';

  @override
  String availableCount(int count) {
    return '$count available';
  }

  @override
  String stockCount(int count) {
    return 'Stock $count';
  }

  @override
  String get outOfStockShort => 'Sold out';

  @override
  String get addToCart => 'Add';

  @override
  String get cartTitle => 'Cart';

  @override
  String cartItemCount(int count) {
    return '$count item(s)';
  }

  @override
  String get emptyCartMessage => 'Your cart is empty.';

  @override
  String get totalLabel => 'Total';

  @override
  String get proceedToPayment => 'Proceed to payment';

  @override
  String get checkout => 'Checkout';

  @override
  String get noMatchingProducts => 'No products match your search.';

  @override
  String get catalogLoadFailed =>
      'The catalog could not be refreshed. Cached products remain available offline.';

  @override
  String get paymentTitle => 'Checkout';

  @override
  String cartSummary(int count) {
    return 'Items ($count)';
  }

  @override
  String get subtotalLabel => 'Subtotal';

  @override
  String get adjustments => 'Adjustments';

  @override
  String get discountFCFA => 'Discount (FCFA)';

  @override
  String get deliveryFCFA => 'Delivery (FCFA)';

  @override
  String get taxIncluded => 'VAT included';

  @override
  String get taxDisabled => 'VAT disabled';

  @override
  String get paymentMethodTitle => 'Payment method';

  @override
  String get cashMethod => 'Cash';

  @override
  String get cashSubtitle => 'Cash payment';

  @override
  String get mtnMethod => 'MTN Mobile Money';

  @override
  String get orangeMethod => 'Orange Money';

  @override
  String get manualPaymentSubtitle => 'Seller confirms receipt';

  @override
  String get otherMethod => 'Other';

  @override
  String get otherPaymentSubtitle => 'Transfer, cheque, or another method';

  @override
  String get transactionReferenceLabel => 'Transaction reference';

  @override
  String get transactionReferenceHint =>
      'Reference shown on the payment receipt';

  @override
  String get paymentReferenceRequired => 'Enter the payment reference.';

  @override
  String saleFailed(String error) {
    return 'Sale failed: $error';
  }

  @override
  String saleNeedsReview(String error) {
    return 'Sale saved locally and needs review: $error';
  }

  @override
  String get saleSavedOffline =>
      'Sale saved offline. Sync will resume automatically.';

  @override
  String confirmSale(String amount) {
    return 'Confirm — $amount';
  }

  @override
  String get receiptProvisional => 'Provisional ticket — sync pending';

  @override
  String get receiptNeedsReview =>
      'Sale needs review before server confirmation';

  @override
  String get receiptNotFiscal =>
      'Non-fiscal document — tax details are not verified';

  @override
  String get receiptFiscalVerified => 'Fiscal profile verified';

  @override
  String get receiptLocalTime => 'Provisional local time';

  @override
  String get organizationNameMissing => 'Business';

  @override
  String get organizationAddressMissing => 'Address not provided';

  @override
  String get organizationNiuMissing => 'Not provided';

  @override
  String get taxFieldInvalid => 'Enter a rate between 0 and 100%.';

  @override
  String get businessNameRequired => 'Enter the business name.';

  @override
  String receiptTax(Object rate) {
    return 'VAT ($rate%)';
  }

  @override
  String get authInputRequired => 'Enter your sign-in details to continue.';

  @override
  String get authVerifyEmail => 'Verify your email address before signing in.';

  @override
  String get authBusinessUnlinked =>
      'This account is not an active member of an MboaPOS business.';

  @override
  String get authOwnerRequired => 'Owner or administrator access is required.';

  @override
  String get authTooManyAttempts =>
      'Too many attempts. Wait before trying again.';

  @override
  String get authAccountExists =>
      'An account already exists for this email address.';

  @override
  String get authWeakPassword =>
      'Choose a stronger password with at least 8 characters.';

  @override
  String get authInvalidEmail => 'Enter a valid email address.';

  @override
  String get businessSetupUnavailable =>
      'Business setup is temporarily unavailable.';

  @override
  String get businessSetupInvalid =>
      'The business information could not be validated.';

  @override
  String get businessSetupRetry =>
      'Setup is incomplete. Check your connection and try again.';

  @override
  String get businessCreateFailed =>
      'Could not create the business account. Try again.';
}
