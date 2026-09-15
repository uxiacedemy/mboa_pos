import 'package:flutter/material.dart';
import '../../../../core/design/design_tokens.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.settings_outlined, size: 64, color: color),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'Paramètres — bientôt disponible',
              style: AppTypography.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
