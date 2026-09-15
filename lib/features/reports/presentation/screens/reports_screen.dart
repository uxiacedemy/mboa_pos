import 'package:flutter/material.dart';
import '../../../../core/design/design_tokens.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return Scaffold(
      appBar: AppBar(title: const Text('Rapports')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bar_chart_outlined, size: 64, color: color),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'Rapports — bientôt disponible',
              style: AppTypography.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
