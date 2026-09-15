import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/design/design_tokens.dart';
import '../../../inventory/domain/errors/insufficient_stock_exception.dart';
import '../../../inventory/domain/models/stock_movement.dart';
import '../providers/cart_provider.dart';
import '../../domain/models/cart_item.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  final _discountController  = TextEditingController(text: '0');
  final _deliveryController  = TextEditingController(text: '0');
  final _taxRateController   = TextEditingController(text: '19.25');
  String _paymentMethod      = 'cash';
  bool _taxIncluded          = false;

  @override
  void dispose() {
    _discountController.dispose();
    _deliveryController.dispose();
    _taxRateController.dispose();
    super.dispose();
  }

  int get _discount  => int.tryParse(_discountController.text)  ?? 0;
  int get _delivery  => int.tryParse(_deliveryController.text)  ?? 0;
  int get _taxRateBasisPoints {
    final value = _taxRateController.text.trim().replaceAll(',', '.');
    final parts = value.split('.');
    final whole = int.tryParse(parts.first) ?? 0;
    final fraction = parts.length > 1
        ? parts[1].padRight(2, '0').substring(0, 2)
        : '00';
    return whole * 100 + (int.tryParse(fraction) ?? 0);
  }

  int _taxFor(int taxableAmount) =>
      (taxableAmount * _taxRateBasisPoints + 5000) ~/ 10000;

  int _calculate(int subtotal) {
    final afterDiscount = (subtotal - _discount).clamp(0, subtotal);
    final tax      = _taxIncluded ? _taxFor(afterDiscount) : 0;
    return afterDiscount + tax + _delivery;
  }

  static String _fmt(int amount) =>
      '${NumberFormat('#,##0', 'fr_CM').format(amount)} FCFA';

  Future<void> _confirmSale(
    int total,
    List<CartItem> cart,
    int subtotal,
  ) async {
    const organizationId = 'default';
    const deviceId = 'local-device';
    final db = FirebaseFirestore.instance;
    final uuid = const Uuid();
    final saleId = uuid.v4();
    final productRefs = [
      for (final item in cart)
        db
            .collection('organizations')
            .doc(organizationId)
            .collection('products')
            .doc(item.product.id),
    ];

    await db.runTransaction((txn) async {
      final snapshots = [
        for (final productRef in productRefs) await txn.get(productRef),
      ];

      final movements = <({DocumentReference<Map<String, dynamic>> ref,
          StockMovement movement})>[];
      for (var index = 0; index < cart.length; index++) {
        final item = cart[index];
        final movement = StockMovement(
          id: uuid.v4(),
          productId: item.product.id,
          quantity: -item.quantity,
          type: StockMovementType.saleDeduction,
          actorId: 'local-cashier',
          deviceId: deviceId,
          occurredAt: DateTime.now(),
        );
        final movementRef = db
            .collection('organizations')
            .doc(organizationId)
            .collection('inventory_adjustments')
            .doc(movement.id);
          final snap = snapshots[index];
        final current = snap.data()?['stockQty'] as int? ?? 0;
        if (current < item.quantity) {
          throw InsufficientStockException(
            productId: item.product.id,
            requested: item.quantity,
            available: current,
          );
        }
        movements.add((ref: movementRef, movement: movement));
      }

      for (var index = 0; index < cart.length; index++) {
        txn.update(productRefs[index], {
          'stockQty': FieldValue.increment(-cart[index].quantity),
        });
      }
      for (final entry in movements) {
        txn.set(entry.ref, entry.movement.toFirestore());
      }
      txn.set(
        db
            .collection('organizations')
            .doc(organizationId)
            .collection('transactions')
            .doc(saleId),
        {
          'id': saleId,
          'organizationId': organizationId,
          'cashierId': 'local-cashier',
          'status': 'completed',
          'subtotalFCFA': subtotal,
          'discountFCFA': _discount,
          'deliveryFCFA': _delivery,
          'taxFCFA': _taxIncluded ? _taxFor((subtotal - _discount).clamp(0, subtotal)) : 0,
          'taxRateBasisPoints': _taxRateBasisPoints,
          'totalFCFA': total,
          'paymentMethod': _paymentMethod,
          'items': [
            for (final item in cart)
              {
                'productId': item.product.id,
                'name': item.product.name,
                'quantity': item.quantity,
                'unitPriceFCFA': item.product.priceFCFA,
                'subtotalFCFA': item.subtotalFCFA,
              },
          ],
          'createdAt': FieldValue.serverTimestamp(),
        },
      );
    });

    if (!mounted) return;
    ref.read(cartProvider.notifier).clearCart();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Vente confirmée — ${_fmt(total)} encaissé en '
          '${_paymentMethodLabel(_paymentMethod)}',
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.success,
      ),
    );
    Navigator.of(context).pop();
  }

  String _paymentMethodLabel(String method) => switch (method) {
    'cash'   => 'Espèces',
    'mtn'    => 'MTN MoMo',
    'orange' => 'Orange Money',
    'other'  => 'Autre',
    _        => method,
  };

  @override
  Widget build(BuildContext context) {
    final cart       = ref.watch(cartProvider);
    final subtotal   = ref.watch(cartTotalProvider);
    final total      = _calculate(subtotal);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        title: const Text('Encaissement',
            style: AppTypography.titleLarge),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [

          // ── Cart summary ─────────────────────────────────────────
          _SectionCard(
            title: 'Articles (${cart.length})',
            child: Column(
              children: [
                ...cart.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.xs),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${item.product.name} ×${item.quantity}',
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
                    Text('Sous-total',
                        style: AppTypography.titleSmall),
                    Text(_fmt(subtotal),
                        style: AppTypography.titleSmall),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // ── Adjustments ──────────────────────────────────────────
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
                          onChanged: (v) =>
                              setState(() => _taxIncluded = v),
                        ),
                        Text(
                          _taxIncluded ? 'Activée' : 'Désactivée',
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

          // ── Payment method ───────────────────────────────────────
          _SectionCard(
            title: 'Mode de paiement',
            child: RadioGroup<String>(
              groupValue: _paymentMethod,
              onChanged: (value) => setState(() => _paymentMethod = value!),
              child: Column(
                children: [
                  _PaymentOption(
                    value: 'cash',
                    label: 'Espèces',
                    subtitle: 'Paiement en main propre',
                    icon: Icons.payments_outlined,
                    color: AppColors.success,
                  ),
                  _PaymentOption(
                    value: 'mtn',
                    label: 'MTN Mobile Money',
                    subtitle: 'Le vendeur confirme la réception',
                    icon: Icons.phone_android_outlined,
                    color: AppColors.mtnYellowDark,
                  ),
                  _PaymentOption(
                    value: 'orange',
                    label: 'Orange Money',
                    subtitle: 'Le vendeur confirme la réception',
                    icon: Icons.phone_android_outlined,
                    color: AppColors.orangeOrange,
                  ),
                  _PaymentOption(
                    value: 'other',
                    label: 'Autre',
                    subtitle: 'Virement, chèque, crédit...',
                    icon: Icons.more_horiz,
                    color: AppColors.info,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // ── Total ────────────────────────────────────────────────
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

          // ── Confirm button ───────────────────────────────────────
          SizedBox(
            height: AppSpacing.buttonHeight,
            child: FilledButton.icon(
              onPressed: () => _confirmSale(total, cart, subtotal),
              icon: const Icon(Icons.check_circle_outline),
              label: Text(
                'Confirmer — ${_fmt(total)}',
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

// ─── Reusable widgets ─────────────────────────────────────────────────────────

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