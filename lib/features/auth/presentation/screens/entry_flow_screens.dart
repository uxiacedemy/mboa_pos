import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design/design_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../providers/entry_flow_provider.dart';

class EntryFlowLocalizations extends ConsumerWidget {
  const EntryFlowLocalizations({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Localizations.override(
        context: context,
        locale: ref.watch(entryLocaleProvider),
        child: child,
      );
}

class EntryLanguageSelector extends ConsumerWidget {
  const EntryLanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(entryLocaleProvider);
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.loginLanguageLabel, style: AppTypography.bodySmall),
        const SizedBox(height: AppSpacing.xs),
        SegmentedButton<Locale>(
          showSelectedIcon: false,
          segments: [
            ButtonSegment(
              value: const Locale('fr'),
              label: Text(l10n.languageFrench),
            ),
            ButtonSegment(
              value: const Locale('en'),
              label: Text(l10n.languageEnglish),
            ),
          ],
          selected: {locale},
          onSelectionChanged: (selection) =>
              ref.read(entryLocaleProvider.notifier).setLocale(selection.first),
        ),
      ],
    );
  }
}

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  bool _isContinuing = false;
  String? _error;

  Future<void> _continue() async {
    if (_isContinuing) return;
    setState(() {
      _isContinuing = true;
      _error = null;
    });
    try {
      await ref.read(firstRunWelcomeProvider.notifier).completeWelcome();
      if (mounted) context.go('/entry');
    } on Object catch (error, stackTrace) {
      developer.log(
        'Could not save first-run welcome completion',
        name: 'mboapos.auth',
        error: error,
        stackTrace: stackTrace,
      );
      if (mounted) {
        setState(
          () => _error = AppLocalizations.of(context)!.welcomeContinueError,
        );
      }
    } finally {
      if (mounted) setState(() => _isContinuing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: AppColors.checkoutCanvas,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const EntryLanguageSelector(),
                      const SizedBox(height: AppSpacing.xl),
                      Icon(
                        Icons.point_of_sale_rounded,
                        color: colorScheme.primary,
                        size: 64,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'MboaPOS',
                        textAlign: TextAlign.center,
                        style: AppTypography.headlineLarge
                            .copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        l10n.welcomeTitle,
                        textAlign: TextAlign.center,
                        style: AppTypography.headlineMedium
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        l10n.welcomeBody,
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyLarge
                            .copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      if (_error != null) ...[
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: colorScheme.error),
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],
                      FilledButton(
                        onPressed: _isContinuing ? null : _continue,
                        child: _isContinuing
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(l10n.welcomeStart),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EntryChoiceScreen extends StatelessWidget {
  const EntryChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: AppColors.checkoutCanvas,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const EntryLanguageSelector(),
                      const SizedBox(height: AppSpacing.xl),
                      Text(
                        l10n.entryChoiceTitle,
                        textAlign: TextAlign.center,
                        style: AppTypography.headlineMedium
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        l10n.entryChoiceDescription,
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyMedium
                            .copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      FilledButton.icon(
                        onPressed: () => context.go('/login?mode=staff'),
                        icon: const Icon(Icons.badge_outlined),
                        label: Text(l10n.staffLoginChoice),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      OutlinedButton.icon(
                        onPressed: () => context.go('/login?mode=owner'),
                        icon: const Icon(Icons.business_outlined),
                        label: Text(l10n.ownerLoginChoice),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextButton.icon(
                        onPressed: () => context.go('/register'),
                        icon: const Icon(Icons.add_business_outlined),
                        label: Text(l10n.createBusiness),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EntryStartupScreen extends ConsumerWidget {
  const EntryStartupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final welcomeState = ref.watch(firstRunWelcomeProvider);
    return Scaffold(
      backgroundColor: AppColors.checkoutCanvas,
      body: Center(
        child: welcomeState.hasError
            ? Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.entryLoadingError,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    OutlinedButton(
                      onPressed: () {
                        ref.invalidate(authProvider);
                        ref.invalidate(firstRunWelcomeProvider);
                      },
                      child: Text(l10n.entryRetry),
                    ),
                  ],
                ),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
