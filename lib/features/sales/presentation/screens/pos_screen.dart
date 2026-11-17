import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/design/design_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/models/cart_item.dart';
import '../../domain/models/product.dart';
import '../providers/cart_provider.dart';
import 'payment_screen.dart';

class PosScreen extends ConsumerStatefulWidget {
  const PosScreen({super.key});

  @override
  ConsumerState<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends ConsumerState<PosScreen> {
  final _search = TextEditingController();
  String _query = '';
  String _category = '';

  static String _money(int value) =>
      '${NumberFormat('#,##0', 'fr_CM').format(value)} FCFA';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<Product> _filter(List<Product> products) {
    final query = _query.trim().toLowerCase();
    return products.where((product) {
      final categoryMatch = _category.isEmpty || product.category == _category;
      final queryMatch = query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.nameEn.toLowerCase().contains(query) ||
          (product.barcode?.contains(query) ?? false);
      return categoryMatch && queryMatch;
    }).toList();
  }

  void _checkout() {
    if (ref.read(cartProvider).isEmpty) return;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const PaymentScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final catalogAsync = ref.watch(catalogProvider);
    final products = catalogAsync.value?.products ?? const <Product>[];
    final cart = ref.watch(cartProvider);
    final total = ref.watch(cartTotalProvider);
    final count = ref.watch(cartItemCountProvider);
    final categories = <String>{
      l10n.allCategories,
      ...products.map((product) => product.category),
    }.toList();
    final filtered = _filter(products);
    final wide = MediaQuery.sizeOf(context).width >= 820;

    return Scaffold(
      backgroundColor: AppColors.checkoutCanvas,
      appBar: AppBar(
        backgroundColor: AppColors.checkoutCanvas,
        foregroundColor: AppColors.checkoutInk,
        surfaceTintColor: Colors.transparent,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.posTitle, style: AppTypography.titleLarge),
            Text(
              l10n.posSubtitle,
              style: TextStyle(
                color: AppColors.checkoutMuted,
                fontSize: 11,
              ),
            ),
          ],
        ),
        actions: [
          _SyncBadge(status: ref.watch(syncStatusProvider)),
          const SizedBox(width: AppSpacing.md),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.sm,
                      AppSpacing.md,
                      AppSpacing.xs,
                    ),
                    child: SearchBar(
                      controller: _search,
                      hintText: l10n.catalogSearch,
                      leading: const Icon(Icons.search_rounded),
                      trailing: [
                        if (_query.isNotEmpty)
                          IconButton(
                            onPressed: () {
                              _search.clear();
                              setState(() => _query = '');
                            },
                            icon: const Icon(Icons.close_rounded),
                          ),
                      ],
                      onChanged: (value) => setState(() => _query = value),
                      elevation: const WidgetStatePropertyAll(0),
                      backgroundColor: const WidgetStatePropertyAll(
                        AppColors.checkoutSurface,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 52,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(width: AppSpacing.xs),
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final selected = _category.isEmpty
                            ? index == 0
                            : category == _category;
                        return ChoiceChip(
                          label: Text(category),
                          selected: selected,
                          onSelected: (_) => setState(
                            () => _category = index == 0 ? '' : category,
                          ),
                          showCheckmark: false,
                          selectedColor: AppColors.checkoutOlive,
                          backgroundColor: AppColors.checkoutSurface,
                          labelStyle: TextStyle(
                            color: selected
                                ? Colors.white
                                : AppColors.checkoutMuted,
                            fontWeight: FontWeight.w700,
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.xs,
                      AppSpacing.md,
                      AppSpacing.sm,
                    ),
                    child: Row(
                      children: [
                        Text(
                          l10n.productsHeading,
                          style: TextStyle(
                            color: AppColors.checkoutInk,
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          l10n.availableCount(filtered.length),
                          style: const TextStyle(
                            color: AppColors.checkoutMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (catalogAsync.value?.syncError != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                          ),
                          child: Row(
                            children: [
                              Expanded(child: Text(l10n.catalogLoadFailed)),
                              TextButton(
                                onPressed: () => ref
                                    .read(catalogProvider.notifier)
                                    .refresh(),
                                child: Text(l10n.settingsRetry),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    child: catalogAsync.isLoading && products.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : catalogAsync.hasError && products.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(AppSpacing.md),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        l10n.catalogLoadFailed,
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: AppSpacing.sm),
                                      OutlinedButton(
                                        onPressed: () => ref
                                            .read(catalogProvider.notifier)
                                            .refresh(),
                                        child: Text(l10n.settingsRetry),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : filtered.isEmpty
                                ? Center(
                                    child: Text(
                                      _query.isEmpty
                                          ? l10n.noProducts
                                          : l10n.noMatchingProducts,
                                      style: const TextStyle(
                                        color: AppColors.checkoutMuted,
                                      ),
                                    ),
                                  )
                                : GridView.builder(
                                    padding: const EdgeInsets.fromLTRB(
                                      AppSpacing.md,
                                      0,
                                      AppSpacing.md,
                                      AppSpacing.md,
                                    ),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          MediaQuery.sizeOf(context).width >=
                                                  1200
                                              ? 4
                                              : 2,
                                      crossAxisSpacing: AppSpacing.sm,
                                      mainAxisSpacing: AppSpacing.sm,
                                      childAspectRatio: wide ? 1.05 : 0.82,
                                    ),
                                    itemCount: filtered.length,
                                    itemBuilder: (context, index) {
                                      final product = filtered[index];
                                      final quantity = cart
                                          .where((item) =>
                                              item.product.id == product.id)
                                          .fold(
                                              0,
                                              (sum, item) =>
                                                  sum + item.quantity);
                                      return _ProductCard(
                                        product: product,
                                        quantity: quantity,
                                        money: _money,
                                        onAdd: () => ref
                                            .read(cartProvider.notifier)
                                            .addProduct(product),
                                        onRemove: quantity == 0
                                            ? null
                                            : () => ref
                                                .read(cartProvider.notifier)
                                                .updateQuantity(
                                                  product.id,
                                                  quantity - 1,
                                                ),
                                      );
                                    },
                                  ),
                  ),
                ],
              ),
            ),
            if (wide)
              SizedBox(
                width: 330,
                child: _CartPanel(
                  cart: cart,
                  total: total,
                  count: count,
                  money: _money,
                  onQuantity: (id, quantity) => ref
                      .read(cartProvider.notifier)
                      .updateQuantity(id, quantity),
                  onCheckout: _checkout,
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: wide
          ? null
          : _MobileCartBar(
              count: count,
              total: total,
              money: _money,
              onCheckout: cart.isEmpty ? null : _checkout,
            ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.quantity,
    required this.money,
    required this.onAdd,
    required this.onRemove,
  });

  final Product product;
  final int quantity;
  final String Function(int) money;
  final VoidCallback onAdd;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final out = product.stockQty <= 0;
    return Card(
      margin: EdgeInsets.zero,
      color: AppColors.checkoutSurface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.checkoutCard,
        side: const BorderSide(color: AppColors.checkoutBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.checkoutSage.withValues(alpha: 0.5),
                  borderRadius: AppRadius.checkoutCard,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(
                      Icons.inventory_2_outlined,
                      size: 40,
                      color: AppColors.checkoutOlive,
                    ),
                    if (quantity > 0)
                      Positioned(
                        top: AppSpacing.xs,
                        right: AppSpacing.xs,
                        child: CircleAvatar(
                          radius: 13,
                          backgroundColor: AppColors.checkoutLime,
                          child: Text(
                            quantity.toString(),
                            style: const TextStyle(
                              color: AppColors.checkoutInk,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.checkoutInk,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Row(
              children: [
                Expanded(
                  child: Text(
                    money(product.priceFCFA),
                    style: const TextStyle(
                      color: AppColors.checkoutOlive,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                    ),
                  ),
                ),
                Text(
                  l10n.stockCount(product.stockQty),
                  style: TextStyle(
                    color: product.stockQty <= 5
                        ? Theme.of(context).colorScheme.error
                        : AppColors.checkoutMuted,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                if (onRemove != null)
                  IconButton(
                    onPressed: onRemove,
                    icon: const Icon(Icons.remove_circle_outline),
                    constraints: const BoxConstraints(
                      minWidth: 48,
                      minHeight: 48,
                    ),
                  ),
                Expanded(
                  child: FilledButton(
                    onPressed: out ? null : onAdd,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.checkoutInk,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.checkoutButton,
                      ),
                    ),
                    child: Text(out ? l10n.outOfStockShort : l10n.addToCart),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CartPanel extends StatelessWidget {
  const _CartPanel({
    required this.cart,
    required this.total,
    required this.count,
    required this.money,
    required this.onQuantity,
    required this.onCheckout,
  });

  final List<CartItem> cart;
  final int total;
  final int count;
  final String Function(int) money;
  final void Function(String, int) onQuantity;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: const BoxDecoration(
        color: AppColors.checkoutSurface,
        border: Border(left: BorderSide(color: AppColors.checkoutBorder)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.cartTitle,
            style: TextStyle(
              color: AppColors.checkoutInk,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            l10n.cartItemCount(count),
            style: const TextStyle(color: AppColors.checkoutMuted),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: cart.isEmpty
                ? Center(
                    child: Text(
                      l10n.emptyCartMessage,
                      style: TextStyle(color: AppColors.checkoutMuted),
                    ),
                  )
                : ListView.separated(
                    itemCount: cart.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final item = cart[index];
                      return _CartLine(
                        item: item,
                        money: money,
                        onDecrease: () =>
                            onQuantity(item.product.id, item.quantity - 1),
                        onIncrease: () =>
                            onQuantity(item.product.id, item.quantity + 1),
                      );
                    },
                  ),
          ),
          const Divider(color: AppColors.checkoutBorder),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.totalLabel,
                style: TextStyle(
                  color: AppColors.checkoutInk,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
              Text(
                money(total),
                style: const TextStyle(
                  color: AppColors.checkoutOlive,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: cart.isEmpty ? null : onCheckout,
              icon: const Icon(Icons.arrow_forward_rounded),
              label: Text(l10n.proceedToPayment),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartLine extends StatelessWidget {
  const _CartLine({
    required this.item,
    required this.money,
    required this.onDecrease,
    required this.onIncrease,
  });

  final CartItem item;
  final String Function(int) money;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.checkoutCanvas,
        borderRadius: AppRadius.checkoutButton,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item.product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.checkoutInk,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          IconButton(
            onPressed: onDecrease,
            icon: const Icon(Icons.remove_rounded),
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          ),
          Text(item.quantity.toString()),
          IconButton(
            onPressed: onIncrease,
            icon: const Icon(Icons.add_rounded),
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          ),
        ],
      ),
    );
  }
}

class _MobileCartBar extends StatelessWidget {
  const _MobileCartBar({
    required this.count,
    required this.total,
    required this.money,
    required this.onCheckout,
  });

  final int count;
  final int total;
  final String Function(int) money;
  final VoidCallback? onCheckout;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Row(
          children: [
            Expanded(
              child: Text(
                l10n.cartItemCount(count),
                style: const TextStyle(
                  color: AppColors.checkoutInk,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            FilledButton.icon(
              onPressed: onCheckout,
              icon: const Icon(Icons.payment_rounded),
              label: Text(l10n.checkout),
            ),
          ],
        ),
      ),
    );
  }
}

class _SyncBadge extends StatelessWidget {
  const _SyncBadge({required this.status});

  final SyncStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final (icon, label, color) = switch (status) {
      SyncStatus.synced => (
          Icons.cloud_done_outlined,
          l10n.synced,
          AppColors.success,
        ),
      SyncStatus.pending => (
          Icons.cloud_upload_outlined,
          l10n.pending,
          AppColors.warning,
        ),
      SyncStatus.offline => (
          Icons.cloud_off_outlined,
          l10n.offline,
          AppColors.checkoutMuted,
        ),
      SyncStatus.conflict => (
          Icons.sync_problem_outlined,
          l10n.conflict,
          Theme.of(context).colorScheme.error,
        ),
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
