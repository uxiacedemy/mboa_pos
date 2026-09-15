import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/design/design_tokens.dart';
import '../../domain/models/product.dart';
import '../providers/cart_provider.dart';
import '../../../sales/presentation/screens/payment_screen.dart';
import '../widgets/product_tile.dart';
class PosScreen extends ConsumerStatefulWidget {
  const PosScreen({super.key});

  @override
  ConsumerState<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends ConsumerState<PosScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Product> _filter(List<Product> products) {
    if (_searchQuery.isEmpty) return products;
    final q = _searchQuery.toLowerCase();
    return products
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.nameEn.toLowerCase().contains(q) ||
            (p.barcode?.contains(q) ?? false))
        .toList();
  }

  static String _formatFCFA(int amount) {
    return '${NumberFormat('#,##0', 'fr_CM').format(amount)} FCFA';
  }

  @override
  Widget build(BuildContext context) {
    final products    = ref.watch(productsProvider);
    final cart        = ref.watch(cartProvider);
    final total       = ref.watch(cartTotalProvider);
    final itemCount   = ref.watch(cartItemCountProvider);
    final syncStatus  = ref.watch(syncStatusProvider);
    final filtered    = _filter(products);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        title: const Text('Nouvelle Vente', style: AppTypography.titleLarge),
        actions: [
          _SyncBadge(status: syncStatus),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md, AppSpacing.xs, AppSpacing.md, AppSpacing.sm,
            ),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Rechercher ou scanner...',
              leading: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
              trailing: [
                if (_searchQuery.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  ),
                IconButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  tooltip: 'Scanner',
                  onPressed: () {},
                ),
              ],
              onChanged: (v) => setState(() => _searchQuery = v),
              elevation: const WidgetStatePropertyAll(0),
              backgroundColor: WidgetStatePropertyAll(
                colorScheme.surfaceContainerHighest,
              ),
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? _EmptyState(query: _searchQuery)
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final product = filtered[index];
                      final qtyInCart = cart
                          .where((i) => i.product.id == product.id)
                          .fold(0, (_, i) => i.quantity);
                      return ProductTile(
                        product: product,
                        quantityInCart: qtyInCart,
                        onAdd: () => ref.read(cartProvider.notifier).addProduct(product),
                        onRemove: () => ref
                            .read(cartProvider.notifier)
                            .updateQuantity(product.id, qtyInCart - 1),
                      );
                    },
                  ),
          ),
          _CartBar(
            itemCount: itemCount,
            total: total,
            isEmpty: cart.isEmpty,
            formatFCFA: _formatFCFA,
          ),
        ],
      ),
    );
  }
}

class _CartBar extends StatelessWidget {
  final int itemCount;
  final int total;
  final bool isEmpty;
  final String Function(int) formatFCFA;

  const _CartBar({
    required this.itemCount,
    required this.total,
    required this.isEmpty,
    required this.formatFCFA,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bottom = MediaQuery.of(context).padding.bottom;

    return Container(
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
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.md + bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isEmpty
                    ? 'Panier vide'
                    : '$itemCount article${itemCount > 1 ? 's' : ''}',
                style: AppTypography.bodyMedium.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              if (!isEmpty)
                Text(
                  formatFCFA(total),
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            width: double.infinity,
            height: AppSpacing.buttonHeight,
            child: FilledButton.icon(
              onPressed: isEmpty
                  ? null
                  : () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const PaymentScreen(),
                        ),
                      );
                    },
              icon: const Icon(Icons.payment),
              label: Text(
                isEmpty ? 'Panier vide' : 'Encaisser ${formatFCFA(total)}',
                style: AppTypography.buttonLabel,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SyncBadge extends StatelessWidget {
  final SyncStatus status;
  const _SyncBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final (icon, label, color) = switch (status) {
      SyncStatus.synced   => (Icons.cloud_done,   'Synchronisé', AppColors.success),
      SyncStatus.pending  => (Icons.cloud_upload,  'En attente',  AppColors.warning),
      SyncStatus.offline  => (Icons.cloud_off,     'Hors ligne',  colorScheme.outline),
      SyncStatus.conflict => (Icons.sync_problem,  'Conflit',     colorScheme.error),
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: AppSpacing.xs),
        Text(label, style: AppTypography.labelSmall.copyWith(color: color)),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String query;
  const _EmptyState({required this.query});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_outlined, size: 64,
              color: colorScheme.onSurfaceVariant),
          const SizedBox(height: AppSpacing.md),
          Text(
            query.isEmpty
                ? 'Aucun produit disponible'
                : 'Aucun résultat pour "$query"',
            style: AppTypography.bodyMedium.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
