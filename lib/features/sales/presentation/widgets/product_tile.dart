import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/design/design_tokens.dart';
import '../../domain/models/product.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  final int quantityInCart;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const ProductTile({
    super.key,
    required this.product,
    required this.quantityInCart,
    required this.onAdd,
    required this.onRemove,
  });

  static String formatFCFA(int amount) {
    return '${NumberFormat('#,##0', 'fr_CM').format(amount)} FCFA';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final inCart = quantityInCart > 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: inCart
                    ? colorScheme.primaryContainer
                    : colorScheme.surfaceContainerHighest,
                borderRadius: AppRadius.card,
              ),
              child: Icon(
                _categoryIcon(product.category),
                size: 22,
                color: inCart
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTypography.titleSmall.copyWith(
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    formatFCFA(product.priceFCFA),
                    style: AppTypography.bodyMedium.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (inCart) ...[
              SizedBox(
                width: 36,
                height: 36,
                child: IconButton.outlined(
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minWidth: 36, minHeight: 36),
                  icon: const Icon(Icons.remove, size: 16),
                  onPressed: onRemove,
                ),
              ),
              SizedBox(
                width: 32,
                child: Text(
                  '$quantityInCart',
                  textAlign: TextAlign.center,
                  style: AppTypography.titleSmall,
                ),
              ),
            ],
            SizedBox(
              width: 44,
              height: 44,
              child: IconButton.filled(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                icon: const Icon(Icons.add, size: 22),
                onPressed: onAdd,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _categoryIcon(String category) => switch (category) {
        'boissons' => Icons.local_drink_outlined,
        'alimentaire' => Icons.restaurant_outlined,
        'hygiène' => Icons.clean_hands_outlined,
        _ => Icons.inventory_2_outlined,
      };
}
