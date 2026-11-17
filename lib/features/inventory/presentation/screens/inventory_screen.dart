import 'package:flutter/material.dart';

import '../../../../core/design/design_tokens.dart';
import '../../../../l10n/app_localizations.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.inventoryTitle)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: color),
            const SizedBox(height: AppSpacing.md),
            Text(l10n.inventoryComingSoon, style: AppTypography.bodyMedium),
          ],
        ),
      ),
    );
  }
}
