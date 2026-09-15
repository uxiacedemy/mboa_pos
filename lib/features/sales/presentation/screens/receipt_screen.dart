import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/design/design_tokens.dart';
import '../../domain/models/receipt.dart';

class ReceiptScreen extends StatelessWidget {
  final ReceiptData receipt;
  const ReceiptScreen({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        title: const Text('Reçu', style: AppTypography.titleLarge),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Partager',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Partage — bientôt disponible'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.print_outlined),
            tooltip: 'Imprimer',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Impression Bluetooth — bientôt disponible'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: _ReceiptPaper(receipt: receipt),
                ),
              ),
            ),
          ),

          // Bottom actions
          Container(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md + MediaQuery.of(context).padding.bottom,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.message_outlined),
                    label: const Text('WhatsApp'),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('WhatsApp — bientôt disponible'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: FilledButton.icon(
                    icon: const Icon(Icons.add_shopping_cart_outlined),
                    label: const Text('Nouvelle vente'),
                    onPressed: () {
                      // Pop back to POS screen
                      Navigator.of(context)
                          .popUntil((route) => route.isFirst);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Receipt Paper Widget ─────────────────────────────────────────────────────

class _ReceiptPaper extends StatelessWidget {
  final ReceiptData receipt;
  const _ReceiptPaper({required this.receipt});

  static String _fmt(int amount) =>
      '${NumberFormat('#,##0', 'fr_CM').format(amount)} FCFA';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: AppRadius.card,
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          // ── Header ──────────────────────────────────────────────
          Text(
            receipt.organizationName,
            textAlign: TextAlign.center,
            style: AppTypography.titleLarge.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'NIU: ${receipt.organizationNiu}',
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall,
          ),
          Text(
            receipt.organizationAddress,
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall,
          ),

          const SizedBox(height: AppSpacing.md),
          _Divider(),

          // ── Receipt info ────────────────────────────────────────
          _InfoRow(
            label: 'Reçu N°',
            value: receipt.receiptNumber,
          ),
          _InfoRow(
            label: 'Date',
            value: DateFormat('dd/MM/yyyy HH:mm').format(receipt.issuedAt),
          ),
          _InfoRow(
            label: 'Caissier',
            value: receipt.cashierName,
          ),

          const SizedBox(height: AppSpacing.sm),
          _Divider(),
          const SizedBox(height: AppSpacing.sm),

          // ── Items ────────────────────────────────────────────────
          ...receipt.items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name,
                          style: AppTypography.bodyMedium),
                      Text(
                        '${item.quantity} × ${_fmt(item.unitPriceFCFA)}',
                        style: AppTypography.bodySmall.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
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

          const SizedBox(height: AppSpacing.sm),
          _Divider(),
          const SizedBox(height: AppSpacing.sm),

          // ── Totals ───────────────────────────────────────────────
          _InfoRow(
            label: 'Sous-total HT',
            value: _fmt(receipt.subtotalFCFA),
          ),
          if (receipt.discountFCFA > 0)
            _InfoRow(
              label: 'Remise',
              value: '- ${_fmt(receipt.discountFCFA)}',
              valueColor: AppColors.success,
            ),
          if (receipt.taxFCFA > 0)
            _InfoRow(
              label:
                  'Taxe (${(receipt.taxRate * 100).toStringAsFixed(2)}%)',
              value: _fmt(receipt.taxFCFA),
            ),
          if (receipt.deliveryFCFA > 0)
            _InfoRow(
              label: 'Livraison',
              value: _fmt(receipt.deliveryFCFA),
            ),

          const SizedBox(height: AppSpacing.sm),
          _Divider(),
          const SizedBox(height: AppSpacing.sm),

          // Total TTC
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TOTAL TTC',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                _fmt(receipt.totalFCFA),
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xs),
          _InfoRow(
            label: 'Paiement',
            value: receipt.paymentMethod,
          ),

          const SizedBox(height: AppSpacing.md),
          _Divider(),
          const SizedBox(height: AppSpacing.md),

          // ── Footer ───────────────────────────────────────────────
          Text(
            'Merci de votre visite !',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            'Thank you for your visit!',
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Divider(
    color: Theme.of(context).colorScheme.outlineVariant,
    thickness: 1,
  );
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: AppTypography.bodySmall.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              )),
          Text(
            value,
            style: AppTypography.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}