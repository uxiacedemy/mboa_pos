import 'package:flutter/material.dart';
import '../../../../core/design/design_tokens.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return Scaffold(
      appBar: AppBar(title: const Text('Inventaire')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: color),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'Inventaire — bientôt disponible',
              style: AppTypography.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
