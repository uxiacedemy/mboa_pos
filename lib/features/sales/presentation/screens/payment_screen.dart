import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/design/design_tokens.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../../domain/models/cart_item.dart';
import '../../domain/models/receipt.dart';
import '../../data/checkout_persistence.dart';
import 'receipt_screen.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  final _discountController = TextEditingController(text: '0');
  final _deliveryController = TextEditingController(text: '0');
  final _taxRateController = TextEditingController(text: '19.25');
  final _paymentReferenceController = TextEditingController();
  final _checkoutId = const Uuid().v4();
  String _paymentMethod = 'cash';
  bool _taxIncluded = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _discountController.dispose();
    _deliveryController.dispose();
    _taxRateController.dispose();
    _paymentReferenceController.dispose();
    super.dispose();
  }

  int get _discount => int.tryParse(_discountController.text) ?? 0;
  int get _delivery => int.tryParse(_deliveryController.text) ?? 0;
  int get _taxRateBasisPoints {
    final value = _taxRateController.text.trim().replaceAll(',', '.');
    final parts = value.split('.');
    final whole = int.tryParse(parts.first) ?? 0;
    final fraction =
        parts.length > 1 ? parts[1].padRight(2, '0').substring(0, 2) : '00';
    return whole * 100 + (int.tryParse(fraction) ?? 0);
  }

  int _taxFor(int taxableAmount) =>
      (taxableAmount * _taxRateBasisPoints + 5000) ~/ 10000;

  int _calculate(int subtotal) {
    final afterDiscount = (subtotal - _discount).clamp(0, subtotal);
    final tax = _taxIncluded ? _taxFor(afterDiscount) : 0;
    return afterDiscount + tax + _delivery;
  }

  static String _fmt(int amount) =>
      '${NumberFormat('#,##0', 'fr_CM').format(amount)} FCFA';

  Future<void> _confirmSale(
    int total,
    List<CartItem> cart,
    int subtotal,
  ) async {
    if (_isSubmitting) return;
    if (_paymentMethod != 'cash' &&
        _paymentReferenceController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Saisissez la rÃƒÂ©fÃƒÂ©rence du paiement.')),
      );
      return;
    }
    setState(() => _isSubmitting = true);

    try {
      final staffUser = ref.read(authProvider).value;
      final deviceId = await ref.read(deviceIdProvider.future);
      if (!mounted) return;
      if (staffUser == null) {
        throw StateError('No authenticated staff session.');
      }
      final tax =
          _taxIncluded ? _taxFor((subtotal - _discount).clamp(0, subtotal)) : 0;
      final localReceipt = _buildReceipt(
        staffUser.uid,
        cart,
        subtotal,
        total,
        tax,
        _checkoutId,
        DateTime.now(),
      );
      final payload = <String, dynamic>{
        'idempotencyKey': _checkoutId,
        'deviceId': deviceId,
        'organizationId': staffUser.organizationId,
        'actorId': staffUser.uid,
        'lines': [
          for (final item in cart)
            {
              'productId': item.product.id,
              'quantity': item.quantity,
            },
        ],
        'subtotalFCFA': subtotal,
        'discountFCFA': _discount,
        'deliveryFCFA': _delivery,
        'taxFCFA': _taxIncluded
            ? _taxFor((subtotal - _discount).clamp(0, subtotal))
            : 0,
        'taxRateBasisPoints': _taxRateBasisPoints,
        'totalFCFA': total,
        'paymentMethod': _paymentMethod,
        'paymentReference': _paymentMethod == 'cash'
            ? null
            : _paymentReferenceController.text.trim(),
        'localReceipt': localReceipt.toJson(),
      };
      final callable = FirebaseFunctions.instanceFor(region: 'europe-west1')
          .httpsCallable('commitCheckout');
      final result = await callable.call<Map<String, dynamic>>(payload);
      final response = result.data;
      final issuedAt =
          DateTime.tryParse(response['issuedAt'] as String? ?? '') ??
              DateTime.now();
      final receipt = ReceiptData(
        receiptNumber: response['receiptNumber'] as String? ?? _checkoutId,
        issuedAt: issuedAt,
        organizationName: 'MboaPOS',
        organizationNiu: 'Non configurÃ©',
        organizationAddress: 'Adresse non configurÃ©e',
        cashierName: staffUser.uid,
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
        taxFCFA: _taxIncluded
            ? _taxFor((subtotal - _discount).clamp(0, subtotal))
            : 0,
        taxRate: _taxRateBasisPoints / 10000,
        totalFCFA: total,
        paymentMethod: _paymentMethodLabel(_paymentMethod),
        paymentReference: _paymentMethod == 'cash'
            ? null
            : _paymentReferenceController.text.trim(),
      );
      await localCheckoutStore.saveReceipt(receipt);
      await localCheckoutStore.saveStockMovements(
        _movementRecords(payload, synced: true),
      );
      if (!mounted) return;
      ref.read(cartProvider.notifier).clearCart();
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => ReceiptScreen(receipt: receipt)),
      );
    } catch (error) {
      if (_isRetryable(error)) {
        final staffUser = ref.read(authProvider).value;
        if (staffUser != null) {
          final deviceId = await ref.read(deviceIdProvider.future);
          final tax = _taxIncluded
              ? _taxFor((subtotal - _discount).clamp(0, subtotal))
              : 0;
          final localReceipt = _buildReceipt(
            staffUser.uid,
            cart,
            subtotal,
            total,
            tax,
            _checkoutId,
            DateTime.now(),
          );
          final payload = <String, dynamic>{
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
            'taxRateBasisPoints': _taxRateBasisPoints,
            'totalFCFA': total,
            'paymentMethod': _paymentMethod,
            'paymentReference': _paymentMethod == 'cash'
                ? null
                : _paymentReferenceController.text.trim(),
            'localReceipt': localReceipt.toJson(),
          };
          await localCheckoutStore.enqueue(PendingCheckout(
            idempotencyKey: _checkoutId,
            payload: payload,
            queuedAt: DateTime.now(),
          ));
          await localCheckoutStore.saveReceipt(localReceipt);
          await localCheckoutStore.saveStockMovements(
            _movementRecords(payload, synced: false),
          );
          if (!mounted) return;
          ref.read(syncStatusProvider.notifier).markPending();
          ref.read(cartProvider.notifier).clearCart();
          await Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => ReceiptScreen(receipt: localReceipt),
            ),
          );
          return;
        }
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ãƒâ€°chec de la vente : $error'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  ReceiptData _buildReceipt(
    String cashierId,
    List<CartItem> cart,
    int subtotal,
    int total,
    int tax,
    String receiptNumber,
    DateTime issuedAt,
  ) {
    return ReceiptData(
      receiptNumber: receiptNumber,
      issuedAt: issuedAt,
      organizationName: 'MboaPOS',
      organizationNiu: 'Non configuré',
      organizationAddress: 'Adresse non configurée',
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
      taxRate: _taxRateBasisPoints / 10000,
      totalFCFA: total,
      paymentMethod: _paymentMethodLabel(_paymentMethod),
      paymentReference: _paymentMethod == 'cash'
          ? null
          : _paymentReferenceController.text.trim(),
    );
  }

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
    required bool synced,
  }) {
    final lines = (payload['lines'] as List).cast<Map>();
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
          'occurredAt': (payload['localReceipt'] as Map)['issuedAt'],
          'syncStatus': synced ? 'synced' : 'pending',
        },
    ];
  }

  String _paymentMethodLabel(String method) => switch (method) {
        'cash' => 'EspÃƒÂ¨ces',
        'mtn' => 'MTN MoMo',
        'orange' => 'Orange Money',
        'other' => 'Autre',
        _ => method,
      };

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final subtotal = ref.watch(cartTotalProvider);
    final total = _calculate(subtotal);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        title: const Text('Encaissement', style: AppTypography.titleLarge),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // Ã¢â€â‚¬Ã¢â€â‚¬ Cart summary Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬
          _SectionCard(
            title: 'Articles (${cart.length})',
            child: Column(
              children: [
                ...cart.map((item) => Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${item.product.name} Ãƒâ€”${item.quantity}',
                              style: AppTypography.bodyMedium,
                            ),
                          ),
                          Text(
                            _fmt(item.subtotalFCFA),
                            style: AppTypography.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Sous-total', style: AppTypography.titleSmall),
                    Text(_fmt(subtotal), style: AppTypography.titleSmall),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Ã¢â€â‚¬Ã¢â€â‚¬ Adjustments Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬
          _SectionCard(
            title: 'Ajustements',
            child: Column(
              children: [
                // Discount
                _AmountField(
                  label: 'Remise (FCFA)',
                  icon: Icons.local_offer_outlined,
                  controller: _discountController,
                  onChanged: (_) => setState(() {}),
                ),

                const SizedBox(height: AppSpacing.sm),

                // Delivery
                _AmountField(
                  label: 'Livraison (FCFA)',
                  icon: Icons.delivery_dining_outlined,
                  controller: _deliveryController,
                  onChanged: (_) => setState(() {}),
                ),

                const SizedBox(height: AppSpacing.sm),

                // Tax
                Row(
                  children: [
                    Expanded(
                      child: _AmountField(
                        label: 'Taux taxe (%)',
                        icon: Icons.receipt_long_outlined,
                        controller: _taxRateController,
                        onChanged: (_) => setState(() {}),
                        isDecimal: true,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Column(
                      children: [
                        Switch(
                          value: _taxIncluded,
                          onChanged: (v) => setState(() => _taxIncluded = v),
                        ),
                        Text(
                          _taxIncluded ? 'ActivÃƒÂ©e' : 'DÃƒÂ©sactivÃƒÂ©e',
                          style: AppTypography.labelSmall.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                if (_taxIncluded && _taxRateBasisPoints > 0) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Taxe (${_taxRateController.text}%)',
                        style: AppTypography.bodySmall.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        _fmt(_taxFor(
                          (subtotal - _discount).clamp(0, subtotal),
                        )),
                        style: AppTypography.bodySmall.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Ã¢â€â‚¬Ã¢â€â‚¬ Payment method Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬
          _SectionCard(
            title: 'Mode de paiement',
            child: RadioGroup<String>(
              groupValue: _paymentMethod,
              onChanged: (value) => setState(() => _paymentMethod = value!),
              child: Column(
                children: [
                  _PaymentOption(
                    value: 'cash',
                    label: 'EspÃƒÂ¨ces',
                    subtitle: 'Paiement en main propre',
                    icon: Icons.payments_outlined,
                    color: AppColors.success,
                  ),
                  _PaymentOption(
                    value: 'mtn',
                    label: 'MTN Mobile Money',
                    subtitle: 'Le vendeur confirme la rÃƒÂ©ception',
                    icon: Icons.phone_android_outlined,
                    color: AppColors.mtnYellowDark,
                  ),
                  _PaymentOption(
                    value: 'orange',
                    label: 'Orange Money',
                    subtitle: 'Le vendeur confirme la rÃƒÂ©ception',
                    icon: Icons.phone_android_outlined,
                    color: AppColors.orangeOrange,
                  ),
                  _PaymentOption(
                    value: 'other',
                    label: 'Autre',
                    subtitle: 'Virement, chÃƒÂ¨que, crÃƒÂ©dit...',
                    icon: Icons.more_horiz,
                    color: AppColors.info,
                  ),
                  if (_paymentMethod != 'cash')
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.sm),
                      child: TextFormField(
                        controller: _paymentReferenceController,
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          labelText: 'RÃƒÂ©fÃƒÂ©rence de transaction',
                          hintText:
                              'RÃƒÂ©fÃƒÂ©rence visible sur le reÃƒÂ§u de paiement',
                          prefixIcon: Icon(Icons.confirmation_number_outlined),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Ã¢â€â‚¬Ã¢â€â‚¬ Total Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: AppRadius.card,
            ),
            child: Column(
              children: [
                if (_discount > 0)
                  _TotalRow(
                    label: 'Remise',
                    value: '- ${_fmt(_discount)}',
                    color: AppColors.success,
                  ),
                if (_delivery > 0)
                  _TotalRow(
                    label: 'Livraison',
                    value: '+ ${_fmt(_delivery)}',
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TOTAL',
                      style: AppTypography.titleLarge.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      _fmt(total),
                      style: AppTypography.headlineMedium.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Ã¢â€â‚¬Ã¢â€â‚¬ Confirm button Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬
          SizedBox(
            height: AppSpacing.buttonHeight,
            child: FilledButton.icon(
              onPressed: _isSubmitting
                  ? null
                  : () => _confirmSale(total, cart, subtotal),
              icon: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check_circle_outline),
              label: Text(
                'Confirmer Ã¢â‚¬â€ ${_fmt(total)}',
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

// Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬ Reusable widgets Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: AppTypography.titleSmall.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            )),
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
}

class _AmountField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool isDecimal;

  const _AmountField({
    required this.label,
    required this.icon,
    required this.controller,
    required this.onChanged,
    this.isDecimal = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: TextInputType.numberWithOptions(decimal: isDecimal),
      inputFormatters: [
        isDecimal
            ? FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
            : FilteringTextInputFormatter.digitsOnly,
      ],
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
}

class _PaymentOption extends StatelessWidget {
  final String value;
  final String label;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _PaymentOption({
    required this.value,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

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
  final String label;
  final String value;
  final Color? color;

  const _TotalRow({
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final style = AppTypography.bodyMedium.copyWith(color: color);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }
}
