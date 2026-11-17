import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/design/design_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../settings/data/organization_settings.dart';
import '../../data/checkout_persistence.dart';
import '../../domain/checkout_fingerprint.dart';
import '../../domain/models/cart_item.dart';
import '../../domain/models/receipt.dart';
import '../providers/cart_provider.dart';
import 'receipt_screen.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  final _discountController = TextEditingController(text: '0');
  final _deliveryController = TextEditingController(text: '0');
  final _paymentReferenceController = TextEditingController();
  final _checkoutId = const Uuid().v4();
  String _paymentMethod = 'cash';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _discountController.dispose();
    _deliveryController.dispose();
    _paymentReferenceController.dispose();
    super.dispose();
  }

  int get _discount => int.tryParse(_discountController.text) ?? 0;
  int get _delivery => int.tryParse(_deliveryController.text) ?? 0;

  int _taxFor(int amount, int rateBasisPoints) =>
      (amount * rateBasisPoints + 5000) ~/ 10000;

  int _calculate(int subtotal, OrganizationSettings settings) {
    final taxableAmount = (subtotal - _discount).clamp(0, subtotal);
    final tax = settings.taxEnabled
        ? _taxFor(taxableAmount, settings.taxRateBasisPoints ?? 1925)
        : 0;
    return taxableAmount + tax + _delivery;
  }

  static String _fmt(int amount) =>
      '${NumberFormat('#,##0', 'fr_CM').format(amount)} FCFA';

  Future<void> _confirmSale(
    int total,
    List<CartItem> cart,
    int subtotal,
    OrganizationSettings settings,
  ) async {
    if (_isSubmitting) return;
    final l10n = AppLocalizations.of(context)!;
    if (!settings.isServerConfigured) {
      _showMessage(l10n.settingsUnavailable, isError: true);
      return;
    }
    if (cart.isEmpty) return;
    if (_paymentMethod != 'cash' &&
        _paymentReferenceController.text.trim().isEmpty) {
      _showMessage(l10n.paymentReferenceRequired, isError: true);
      return;
    }

    setState(() => _isSubmitting = true);
    var recordedLocally = false;
    ReceiptData? localReceipt;
    try {
      final staffUser = ref.read(authProvider).value;
      if (staffUser == null) {
        throw StateError('A staff session is required to record a sale.');
      }
      final deviceId = await ref.read(deviceIdProvider.future);
      if (!mounted) return;

      final taxRateBasisPoints = settings.taxRateBasisPoints ?? 1925;
      final tax = settings.taxEnabled
          ? _taxFor(
              (subtotal - _discount).clamp(0, subtotal), taxRateBasisPoints)
          : 0;
      localReceipt = _buildReceipt(
        settings: settings,
        cashierId: staffUser.uid,
        cart: cart,
        subtotal: subtotal,
        total: total,
        tax: tax,
        taxRateBasisPoints: settings.taxEnabled ? taxRateBasisPoints : 0,
        receiptNumber: _checkoutId,
        issuedAt: DateTime.now(),
        isProvisional: true,
        syncStatus: 'pending',
      );
      final payload = <String, dynamic>{
        'schemaVersion': 1,
        'idempotencyKey': _checkoutId,
        'deviceId': deviceId,
        'organizationId': staffUser.organizationId,
        'actorId': staffUser.uid,
        'lines': [
          for (final item in cart)
            {'productId': item.product.id, 'quantity': item.quantity},
        ],
        'subtotalFCFA': subtotal,
        'discountFCFA': _discount,
        'deliveryFCFA': _delivery,
        'taxFCFA': tax,
        'taxRateBasisPoints': taxRateBasisPoints,
        'totalFCFA': total,
        'paymentMethod': _paymentMethod,
        'paymentReference': _paymentMethod == 'cash'
            ? null
            : _paymentReferenceController.text.trim(),
        'localReceipt': localReceipt.toJson(),
      };
      payload['requestFingerprint'] = checkoutRequestFingerprint(payload);

      final pending = PendingCheckout(
        idempotencyKey: _checkoutId,
        payload: payload,
        queuedAt: DateTime.now(),
        organizationId: staffUser.organizationId,
        actorId: staffUser.uid,
        deviceId: deviceId,
        requestFingerprint: payload['requestFingerprint'] as String,
      );
      await localCheckoutStore.recordOfflineCheckout(
        checkout: pending,
        receipt: localReceipt,
        lines: [
          for (final item in cart)
            (productId: item.product.id, quantity: item.quantity),
        ],
        movements: _movementRecords(payload, syncStatus: 'pending'),
      );
      recordedLocally = true;
      ref.invalidate(catalogProvider);
      ref.read(syncStatusProvider.notifier).markPending();

      final callable = FirebaseFunctions.instanceFor(region: 'europe-west1')
          .httpsCallable('commitCheckout');
      final result = await callable.call<Map<String, dynamic>>(payload);
      final receipt = _authoritativeReceipt(
        localReceipt,
        result.data,
      );
      await localCheckoutStore.completeCheckout(
        idempotencyKey: _checkoutId,
        organizationId: staffUser.organizationId,
        receipt: receipt,
        movements: _movementRecords(
          payload,
          syncStatus: 'synced',
          occurredAt: receipt.issuedAt.toIso8601String(),
        ),
      );
      ref.read(syncStatusProvider.notifier).markSynced();
      if (!mounted) return;
      ref.read(cartProvider.notifier).clearCart();
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => ReceiptScreen(receipt: receipt)),
      );
    } catch (error) {
      if (recordedLocally && localReceipt != null) {
        final needsReview = !_isRetryable(error);
        final receipt = _receiptWithSyncStatus(
          localReceipt,
          needsReview ? 'needsReview' : 'pending',
        );
        if (needsReview) {
          await localCheckoutStore.markNeedsReview(_checkoutId, error);
          await localCheckoutStore.saveReceipt(receipt,
              checkoutId: _checkoutId);
        }
        if (!mounted) return;
        ref.read(syncStatusProvider.notifier).markPending();
        ref.read(cartProvider.notifier).clearCart();
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => ReceiptScreen(receipt: receipt)),
        );
      } else if (mounted) {
        _showMessage(l10n.saleFailed('$error'), isError: true);
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  ReceiptData _buildReceipt({
    required OrganizationSettings settings,
    required String cashierId,
    required List<CartItem> cart,
    required int subtotal,
    required int total,
    required int tax,
    required int taxRateBasisPoints,
    required String receiptNumber,
    required DateTime issuedAt,
    required bool isProvisional,
    required String syncStatus,
  }) =>
      ReceiptData(
        receiptNumber: receiptNumber,
        issuedAt: issuedAt,
        organizationName: settings.businessName.isEmpty
            ? AppLocalizations.of(context)!.organizationNameMissing
            : settings.businessName,
        organizationNiu: settings.organizationNiu ??
            AppLocalizations.of(context)!.organizationNiuMissing,
        organizationAddress: settings.address ??
            AppLocalizations.of(context)!.organizationAddressMissing,
        organizationId: settings.organizationId,
        cashierName: cashierId,
        items: [
          for (final item in cart)
            ReceiptLine(
              name: item.product.name,
              quantity: item.quantity,
              unitPriceFCFA: item.product.priceFCFA,
              subtotalFCFA: item.product.priceFCFA * item.quantity,
            ),
        ],
        subtotalFCFA: subtotal,
        discountFCFA: _discount,
        deliveryFCFA: _delivery,
        taxFCFA: tax,
        taxRate: taxRateBasisPoints / 10000,
        totalFCFA: total,
        paymentMethod: _paymentMethodLabel(_paymentMethod),
        paymentReference: _paymentMethod == 'cash'
            ? null
            : _paymentReferenceController.text.trim(),
        isFiscal: settings.fiscalProfileVerified,
        isProvisional: isProvisional,
        issuedAtIsServer: false,
        syncStatus: syncStatus,
      );

  ReceiptData _authoritativeReceipt(
    ReceiptData local,
    Map<String, dynamic> response,
  ) {
    final issuedAtValue = response['issuedAt'];
    final receiptNumber = response['receiptNumber'];
    final organizationId = response['organizationId'];
    final organizationName = response['organizationName'];
    final organizationNiu = response['organizationNiu'];
    final organizationAddress = response['organizationAddress'];
    final cashierId = response['cashierId'];
    final paymentMethod = response['paymentMethod'];
    final paymentReference = response['paymentReference'];
    final isFiscal = response['isFiscal'];
    final taxRate = response['taxRateBasisPoints'];
    if (issuedAtValue is! String ||
        receiptNumber is! String ||
        organizationId is! String ||
        organizationId != local.organizationId ||
        organizationName is! String ||
        organizationNiu is! String ||
        organizationAddress is! String ||
        cashierId is! String ||
        paymentMethod is! String ||
        isFiscal is! bool ||
        taxRate is! int ||
        taxRate < 0 ||
        taxRate > 10000 ||
        (paymentReference != null && paymentReference is! String)) {
      throw StateError('The server did not return authoritative receipt data.');
    }
    final issuedAt = DateTime.tryParse(issuedAtValue);
    if (issuedAt == null || receiptNumber.isEmpty) {
      throw StateError('The server returned invalid receipt data.');
    }
    final rawLines = response['lines'];
    if (rawLines is! List || rawLines.isEmpty) {
      throw StateError('The server did not return authoritative receipt lines.');
    }
    final lines = <ReceiptLine>[];
    for (final rawLine in rawLines) {
      if (rawLine is! Map ||
          rawLine['name'] is! String ||
          (rawLine['name'] as String).isEmpty ||
          rawLine['quantity'] is! int ||
          (rawLine['quantity'] as int) < 1 ||
          rawLine['unitPriceFCFA'] is! int ||
          (rawLine['unitPriceFCFA'] as int) < 0 ||
          rawLine['subtotalFCFA'] is! int ||
          (rawLine['subtotalFCFA'] as int) < 0) {
        throw StateError('The server returned invalid receipt lines.');
      }
      lines.add(ReceiptLine(
        name: rawLine['name'] as String,
        quantity: rawLine['quantity'] as int,
        unitPriceFCFA: rawLine['unitPriceFCFA'] as int,
        subtotalFCFA: rawLine['subtotalFCFA'] as int,
      ));
    }
    if (paymentMethod != _paymentMethod) {
      throw StateError('The server returned a different payment method.');
    }
    if (cashierId != local.cashierName) {
      throw StateError('The server returned a different cashier.');
    }
    return ReceiptData(
      receiptNumber: receiptNumber,
      issuedAt: issuedAt,
      organizationId: organizationId,
      organizationName: organizationName.isEmpty
          ? AppLocalizations.of(context)!.organizationNameMissing
          : organizationName,
      organizationNiu: organizationNiu.isEmpty
          ? AppLocalizations.of(context)!.organizationNiuMissing
          : organizationNiu,
      organizationAddress: organizationAddress.isEmpty
          ? AppLocalizations.of(context)!.organizationAddressMissing
          : organizationAddress,
      cashierName: cashierId,
      items: lines,
      subtotalFCFA: _requiredServerAmount(response, 'subtotalFCFA'),
      discountFCFA: _requiredServerAmount(response, 'discountFCFA'),
      deliveryFCFA: _requiredServerAmount(response, 'deliveryFCFA'),
      taxFCFA: _requiredServerAmount(response, 'taxFCFA'),
      taxRate: taxRate / 10000,
      totalFCFA: _requiredServerAmount(response, 'totalFCFA'),
      paymentMethod: _paymentMethodLabel(paymentMethod),
      paymentReference: paymentReference as String?,
      isFiscal: isFiscal,
      isProvisional: false,
      issuedAtIsServer: true,
      syncStatus: 'synced',
    );
  }

  int _requiredServerAmount(Map<String, dynamic> response, String field) {
    final value = response[field];
    if (value is! int || value < 0) {
      throw StateError('The server returned an invalid $field.');
    }
    return value;
  }

  ReceiptData _receiptWithSyncStatus(ReceiptData receipt, String status) =>
      ReceiptData(
        receiptNumber: receipt.receiptNumber,
        issuedAt: receipt.issuedAt,
        organizationName: receipt.organizationName,
        organizationNiu: receipt.organizationNiu,
        organizationAddress: receipt.organizationAddress,
        organizationId: receipt.organizationId,
        cashierName: receipt.cashierName,
        items: receipt.items,
        subtotalFCFA: receipt.subtotalFCFA,
        discountFCFA: receipt.discountFCFA,
        deliveryFCFA: receipt.deliveryFCFA,
        taxFCFA: receipt.taxFCFA,
        taxRate: receipt.taxRate,
        totalFCFA: receipt.totalFCFA,
        paymentMethod: receipt.paymentMethod,
        paymentReference: receipt.paymentReference,
        isFiscal: receipt.isFiscal,
        isProvisional: receipt.isProvisional,
        issuedAtIsServer: receipt.issuedAtIsServer,
        syncStatus: status,
      );

  bool _isRetryable(Object error) =>
      error is FirebaseFunctionsException &&
      const {
        'unavailable',
        'deadline-exceeded',
        'internal',
        'aborted',
        'cancelled',
      }.contains(error.code);

  List<Map<String, dynamic>> _movementRecords(
    Map<String, dynamic> payload, {
    required String syncStatus,
    String? occurredAt,
  }) {
    final lines = (payload['lines'] as List).cast<Map>();
    final receipt = payload['localReceipt'] as Map;
    return [
      for (final line in lines)
        {
          'id': '${payload['idempotencyKey']}:${line['productId']}',
          'organizationId': payload['organizationId'],
          'productId': line['productId'],
          'quantity': -(line['quantity'] as int),
          'type': 'saleDeduction',
          'actorId': payload['actorId'],
          'deviceId': payload['deviceId'],
          'occurredAt': occurredAt ?? receipt['issuedAt'],
          'syncStatus': syncStatus,
        },
    ];
  }

  String _paymentMethodLabel(String method) => switch (method) {
        'cash' => AppLocalizations.of(context)!.cashMethod,
        'mtn' => AppLocalizations.of(context)!.mtnMethod,
        'orange' => AppLocalizations.of(context)!.orangeMethod,
        'other' => AppLocalizations.of(context)!.otherMethod,
        _ => method,
      };

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? Theme.of(context).colorScheme.error : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cart = ref.watch(cartProvider);
    final subtotal = ref.watch(cartTotalProvider);
    final settingsAsync = ref.watch(organizationSettingsProvider);
    final staff = ref.watch(authProvider).value;
    final settings = settingsAsync.value ??
        OrganizationSettings.defaults(staff?.organizationId ?? '');
    final total = _calculate(subtotal, settings);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        title: Text(l10n.paymentTitle, style: AppTypography.titleLarge),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          if (settingsAsync.isLoading) const LinearProgressIndicator(),
          if (settingsAsync.hasError)
            _SettingsNotice(
              message: l10n.settingsUnavailable,
              actionLabel: l10n.settingsRetry,
              onPressed: () =>
                  ref.read(organizationSettingsProvider.notifier).refresh(),
              isError: true,
            )
          else if (!settings.isServerConfigured)
            _SettingsNotice(
              message: l10n.settingsUnavailable,
              actionLabel: l10n.settingsRetry,
              onPressed: () =>
                  ref.read(organizationSettingsProvider.notifier).refresh(),
            ),
          _SectionCard(
            title: l10n.cartSummary(cart.length),
            child: Column(
              children: [
                for (final item in cart)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${item.product.name} ×${item.quantity}',
                            style: AppTypography.bodyMedium,
                          ),
                        ),
                        Text(_fmt(item.subtotalFCFA),
                            style: AppTypography.bodyMedium),
                      ],
                    ),
                  ),
                const Divider(),
                _TotalRow(label: l10n.subtotalLabel, value: _fmt(subtotal)),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _SectionCard(
            title: l10n.adjustments,
            child: Column(
              children: [
                _AmountField(
                  label: l10n.discountFCFA,
                  icon: Icons.local_offer_outlined,
                  controller: _discountController,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: AppSpacing.sm),
                _AmountField(
                  label: l10n.deliveryFCFA,
                  icon: Icons.delivery_dining_outlined,
                  controller: _deliveryController,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: AppSpacing.sm),
                _TotalRow(
                  label: settings.taxEnabled
                      ? l10n.tax(settings.taxRateBasisPoints == null
                          ? '19.25'
                          : (settings.taxRateBasisPoints! / 100)
                              .toStringAsFixed(2))
                      : l10n.taxDisabled,
                  value: _fmt(settings.taxEnabled
                      ? _taxFor(
                          (subtotal - _discount).clamp(0, subtotal),
                          settings.taxRateBasisPoints ?? 1925,
                        )
                      : 0),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _SectionCard(
            title: l10n.paymentMethodTitle,
            child: RadioGroup<String>(
              groupValue: _paymentMethod,
              onChanged: (value) => setState(() => _paymentMethod = value!),
              child: Column(
                children: [
                  _PaymentOption(
                    value: 'cash',
                    label: l10n.cashMethod,
                    subtitle: l10n.cashSubtitle,
                    icon: Icons.payments_outlined,
                    color: AppColors.success,
                  ),
                  _PaymentOption(
                    value: 'mtn',
                    label: l10n.mtnMethod,
                    subtitle: l10n.manualPaymentSubtitle,
                    icon: Icons.phone_android_outlined,
                    color: AppColors.mtnYellowDark,
                  ),
                  _PaymentOption(
                    value: 'orange',
                    label: l10n.orangeMethod,
                    subtitle: l10n.manualPaymentSubtitle,
                    icon: Icons.phone_android_outlined,
                    color: AppColors.orangeOrange,
                  ),
                  _PaymentOption(
                    value: 'other',
                    label: l10n.otherMethod,
                    subtitle: l10n.otherPaymentSubtitle,
                    icon: Icons.more_horiz,
                    color: AppColors.info,
                  ),
                  if (_paymentMethod != 'cash')
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.sm),
                      child: TextFormField(
                        controller: _paymentReferenceController,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          labelText: l10n.transactionReferenceLabel,
                          hintText: l10n.transactionReferenceHint,
                          prefixIcon:
                              const Icon(Icons.confirmation_number_outlined),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: AppRadius.card,
            ),
            child: _TotalRow(
              label: l10n.total,
              value: _fmt(total),
              labelStyle: AppTypography.titleLarge.copyWith(
                color: colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w700,
              ),
              valueStyle: AppTypography.headlineMedium.copyWith(
                color: colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            height: AppSpacing.buttonHeight,
            child: FilledButton.icon(
              onPressed: _isSubmitting ||
                      !settings.isServerConfigured ||
                      cart.isEmpty ||
                      settingsAsync.isLoading
                  ? null
                  : () => _confirmSale(total, cart, subtotal, settings),
              icon: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check_circle_outline),
              label: Text(
                l10n.confirmSale(_fmt(total)),
                style: AppTypography.buttonLabel,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}

class _SettingsNotice extends StatelessWidget {
  const _SettingsNotice({
    required this.message,
    required this.actionLabel,
    required this.onPressed,
    this.isError = false,
  });

  final String message;
  final String actionLabel;
  final VoidCallback onPressed;
  final bool isError;

  @override
  Widget build(BuildContext context) => Card(
        color: isError ? Theme.of(context).colorScheme.errorContainer : null,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(
            children: [
              Expanded(child: Text(message)),
              TextButton(onPressed: onPressed, child: Text(actionLabel)),
            ],
          ),
        ),
      );
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.titleSmall.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: child,
            ),
          ),
        ],
      );
}

class _AmountField extends StatelessWidget {
  const _AmountField({
    required this.label,
    required this.icon,
    required this.controller,
    required this.onChanged,
  });

  final String label;
  final IconData icon;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: controller,
        onChanged: onChanged,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: AppRadius.input),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
        ),
      );
}

class _PaymentOption extends StatelessWidget {
  const _PaymentOption({
    required this.value,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String value;
  final String label;
  final String subtitle;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final selected = RadioGroup.maybeOf<String>(context)?.groupValue == value;
    return RadioListTile<String>(
      value: value,
      contentPadding: EdgeInsets.zero,
      title: Row(
        children: [
          Icon(icon, size: 18, color: selected ? color : null),
          const SizedBox(width: AppSpacing.sm),
          Text(label, style: AppTypography.titleSmall),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(left: 26),
        child: Text(subtitle, style: AppTypography.bodySmall),
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({
    required this.label,
    required this.value,
    this.labelStyle,
    this.valueStyle,
  });

  final String label;
  final String value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: labelStyle ?? AppTypography.bodyMedium),
          Text(value,
              style: valueStyle ??
                  AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  )),
        ],
      );
}
