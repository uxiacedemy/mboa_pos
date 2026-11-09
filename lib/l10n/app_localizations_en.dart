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
  String get paymentComingSoon => 'Payment â€” coming soon';

  @override
  String get storeSubtitle => 'Checkout and inventory';

  @override
  String get clear => 'Clear';

  @override
  String get scanner => 'Scanner';

  @override
  String get products => 'Products';

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
}
