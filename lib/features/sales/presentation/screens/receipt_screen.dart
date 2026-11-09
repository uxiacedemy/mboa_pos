import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../../core/design/design_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/models/receipt.dart';

class ReceiptScreen extends StatefulWidget {
  final ReceiptData receipt;

  const ReceiptScreen({super.key, required this.receipt});

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  String? _runningAction;

  String _money(int amount) =>
      '${NumberFormat('#,##0', 'fr_CM').format(amount)} FCFA';

  Future<Uint8List> _buildPdf(PdfPageFormat format) async {
    final receipt = widget.receipt;
    final document = pw.Document();
    document.addPage(
      pw.MultiPage(
        pageFormat: format,
        margin: const pw.EdgeInsets.all(28),
        build: (context) => [
          pw.Center(
            child: pw.Text(
              receipt.organizationName,
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Center(child: pw.Text('NIU: ${receipt.organizationNiu}')),
          pw.Center(child: pw.Text(receipt.organizationAddress)),
          pw.SizedBox(height: 12),
          pw.Divider(),
          _pdfRow('ReÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â§u NÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â°',
              receipt.receiptNumber),
          _pdfRow(
              'Date', DateFormat('dd/MM/yyyy HH:mm').format(receipt.issuedAt)),
          _pdfRow('Caissier', receipt.cashierName),
          pw.SizedBox(height: 10),
          pw.TableHelper.fromTextArray(
            headers: const ['Produit', 'QtÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â©', 'Prix', 'Total'],
            data: [
              for (final item in receipt.items)
                [
                  item.name,
                  '${item.quantity}',
                  _money(item.unitPriceFCFA),
                  _money(item.subtotalFCFA)
                ],
            ],
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            cellStyle: const pw.TextStyle(fontSize: 9),
            cellAlignments: {
              1: pw.Alignment.center,
              2: pw.Alignment.centerRight,
              3: pw.Alignment.centerRight,
            },
          ),
          pw.SizedBox(height: 10),
          pw.Divider(),
          _pdfRow('Sous-total HT', _money(receipt.subtotalFCFA)),
          if (receipt.discountFCFA > 0)
            _pdfRow('Remise', '- ${_money(receipt.discountFCFA)}'),
          if (receipt.taxFCFA > 0)
            _pdfRow('Taxe (${(receipt.taxRate * 100).toStringAsFixed(2)}%)',
                _money(receipt.taxFCFA)),
          if (receipt.deliveryFCFA > 0)
            _pdfRow('Livraison', _money(receipt.deliveryFCFA)),
          pw.Divider(),
          _pdfRow('TOTAL TTC', _money(receipt.totalFCFA), bold: true),
          _pdfRow('Paiement', receipt.paymentMethod),
          if (receipt.paymentReference != null &&
              receipt.paymentReference!.isNotEmpty)
            _pdfRow('RÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â©fÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â©rence',
                receipt.paymentReference!),
          pw.SizedBox(height: 18),
          pw.Center(child: pw.Text('Merci de votre visite !')),
        ],
      ),
    );
    return document.save();
  }

  pw.Widget _pdfRow(String label, String value, {bool bold = false}) =>
      pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 4),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(label,
                style:
                    bold ? pw.TextStyle(fontWeight: pw.FontWeight.bold) : null),
            pw.Text(value,
                style:
                    bold ? pw.TextStyle(fontWeight: pw.FontWeight.bold) : null),
          ],
        ),
      );

  Future<void> _share() async {
    if (_runningAction != null) return;
    setState(() => _runningAction = 'share');
    try {
      final bytes = await _buildPdf(PdfPageFormat.a4);
      await Printing.sharePdf(
        bytes: bytes,
        filename: '${widget.receipt.receiptNumber}.pdf',
      );
      if (mounted) {
        _feedback(AppLocalizations.of(context)!.receiptShared);
      }
    } catch (error) {
      if (mounted) {
        _feedback(AppLocalizations.of(context)!.receiptActionFailed('$error'),
            error: true);
      }
    } finally {
      if (mounted) setState(() => _runningAction = null);
    }
  }

  Future<void> _print() async {
    if (_runningAction != null) return;
    setState(() => _runningAction = 'print');
    try {
      await Printing.layoutPdf(onLayout: _buildPdf);
      if (mounted) {
        _feedback(AppLocalizations.of(context)!.receiptPrinted);
      }
    } catch (error) {
      if (mounted) {
        _feedback(AppLocalizations.of(context)!.receiptActionFailed('$error'),
            error: true);
      }
    } finally {
      if (mounted) setState(() => _runningAction = null);
    }
  }

  void _feedback(String message, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: error ? Theme.of(context).colorScheme.error : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        title: Text(l10n.receiptTitle, style: AppTypography.titleLarge),
        actions: [
          IconButton(
            icon: _runningAction == 'share'
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.share_outlined),
            tooltip: l10n.shareReceipt,
            onPressed: _runningAction == null ? _share : null,
          ),
          IconButton(
            icon: _runningAction == 'print'
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.print_outlined),
            tooltip: l10n.printReceipt,
            onPressed: _runningAction == null ? _print : null,
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
                  child: _ReceiptPaper(receipt: widget.receipt),
                ),
              ),
            ),
          ),
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
                    icon: const Icon(Icons.picture_as_pdf_outlined),
                    label: Text(l10n.sharePdf),
                    onPressed: _runningAction == null ? _share : null,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: FilledButton.icon(
                    icon: const Icon(Icons.add_shopping_cart_outlined),
                    label: Text(l10n.newSale),
                    onPressed: () => Navigator.of(context)
                        .popUntil((route) => route.isFirst),
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

class _ReceiptPaper extends StatelessWidget {
  final ReceiptData receipt;
  const _ReceiptPaper({required this.receipt});

  static String _fmt(int amount) =>
      '${NumberFormat('#,##0', 'fr_CM').format(amount)} FCFA';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
          Text(receipt.organizationName,
              textAlign: TextAlign.center,
              style: AppTypography.titleLarge
                  .copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: AppSpacing.xs),
          Text('${l10n.organizationNiu}: ${receipt.organizationNiu}',
              textAlign: TextAlign.center, style: AppTypography.bodySmall),
          Text(receipt.organizationAddress,
              textAlign: TextAlign.center, style: AppTypography.bodySmall),
          const SizedBox(height: AppSpacing.md),
          const _Divider(),
          _InfoRow(label: l10n.receiptNumber, value: receipt.receiptNumber),
          _InfoRow(
              label: l10n.date,
              value: DateFormat('dd/MM/yyyy HH:mm').format(receipt.issuedAt)),
          _InfoRow(label: l10n.cashier, value: receipt.cashierName),
          const SizedBox(height: AppSpacing.sm),
          const _Divider(),
          const SizedBox(height: AppSpacing.sm),
          ...receipt.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name, style: AppTypography.bodyMedium),
                          Text(
                              '${item.quantity} ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã¢â‚¬Â ${_fmt(item.unitPriceFCFA)}',
                              style: AppTypography.bodySmall.copyWith(
                                  color: colorScheme.onSurfaceVariant)),
                        ],
                      ),
                    ),
                    Text(_fmt(item.subtotalFCFA),
                        style: AppTypography.bodyMedium
                            .copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
              )),
          const SizedBox(height: AppSpacing.sm),
          const _Divider(),
          const SizedBox(height: AppSpacing.sm),
          _InfoRow(label: l10n.subtotal, value: _fmt(receipt.subtotalFCFA)),
          if (receipt.discountFCFA > 0)
            _InfoRow(
                label: l10n.discount,
                value: '- ${_fmt(receipt.discountFCFA)}',
                valueColor: AppColors.success),
          if (receipt.taxFCFA > 0)
            _InfoRow(
                label: l10n.tax((receipt.taxRate * 100).toStringAsFixed(2)),
                value: _fmt(receipt.taxFCFA)),
          if (receipt.deliveryFCFA > 0)
            _InfoRow(label: l10n.delivery, value: _fmt(receipt.deliveryFCFA)),
          const SizedBox(height: AppSpacing.sm),
          const _Divider(),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.total,
                  style: AppTypography.titleMedium
                      .copyWith(fontWeight: FontWeight.w700)),
              Text(_fmt(receipt.totalFCFA),
                  style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w700, color: colorScheme.primary)),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          _InfoRow(label: l10n.payment, value: receipt.paymentMethod),
          if (receipt.paymentReference != null &&
              receipt.paymentReference!.isNotEmpty)
            _InfoRow(
                label: l10n.paymentReference, value: receipt.paymentReference!),
          const SizedBox(height: AppSpacing.md),
          const _Divider(),
          const SizedBox(height: AppSpacing.md),
          Text(l10n.thankYou,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium
                  .copyWith(color: colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();
  @override
  Widget build(BuildContext context) => Divider(
      color: Theme.of(context).colorScheme.outlineVariant, thickness: 1);
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _InfoRow({required this.label, required this.value, this.valueColor});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.xxs),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
                child: Text(label,
                    style: AppTypography.bodySmall.copyWith(
                        color:
                            Theme.of(context).colorScheme.onSurfaceVariant))),
            const SizedBox(width: AppSpacing.sm),
            Flexible(
                child: Text(value,
                    textAlign: TextAlign.end,
                    style: AppTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.w600, color: valueColor))),
          ],
        ),
      );
}
