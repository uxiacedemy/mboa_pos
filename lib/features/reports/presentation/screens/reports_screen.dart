import 'package:flutter/material.dart';

import '../../../../core/design/design_tokens.dart';
import '../../../../l10n/app_localizations.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.reportsTitle)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bar_chart_outlined, size: 64, color: color),
            const SizedBox(height: AppSpacing.md),
            Text(l10n.reportsComingSoon, style: AppTypography.bodyMedium),
          ],
        ),
      ),
    );
  }
}
