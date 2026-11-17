import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design/design_tokens.dart';
import '../../../../core/design/theme_provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/organization_settings.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final themeMode = ref.watch(themeModeProvider);
    final settings = ref.watch(organizationSettingsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(l10n.appearance, style: AppTypography.titleLarge),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.appearanceDescription,
            style: AppTypography.bodyMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: SegmentedButton<ThemeMode>(
                segments: [
                  ButtonSegment(
                    value: ThemeMode.light,
                    icon: const Icon(Icons.light_mode_outlined),
                    label: Text(l10n.lightTheme),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    icon: const Icon(Icons.dark_mode_outlined),
                    label: Text(l10n.darkTheme),
                  ),
                ],
                selected: {themeMode},
                onSelectionChanged: (selection) {
                  ref.read(themeModeProvider.notifier).setMode(selection.first);
                },
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(l10n.businessProfile, style: AppTypography.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          settings.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => _SettingsError(
              onRetry: () => ref.invalidate(organizationSettingsProvider),
            ),
            data: (value) => value.isServerConfigured
                ? _OrganizationSettingsForm(settings: value)
                : _SettingsError(
                    onRetry: () => ref.invalidate(organizationSettingsProvider),
                  ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(l10n.account, style: AppTypography.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          Card(
            child: ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: Text(l10n.signOut),
              subtitle: Text(l10n.signOutDescription),
              onTap: () => ref.read(authProvider.notifier).signOut(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsError extends StatelessWidget {
  const _SettingsError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.settingsUnavailable),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton(
              onPressed: onRetry,
              child: Text(l10n.settingsRetry),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrganizationSettingsForm extends ConsumerStatefulWidget {
  const _OrganizationSettingsForm({required this.settings});

  final OrganizationSettings settings;

  @override
  ConsumerState<_OrganizationSettingsForm> createState() =>
      _OrganizationSettingsFormState();
}

class _OrganizationSettingsFormState
    extends ConsumerState<_OrganizationSettingsForm> {
  late final TextEditingController _businessName;
  late final TextEditingController _niu;
  late final TextEditingController _address;
  late final TextEditingController _taxRate;
  late bool _taxEnabled;
  bool _savingProfile = false;
  bool _savingTax = false;

  @override
  void initState() {
    super.initState();
    final settings = widget.settings;
    _businessName = TextEditingController(text: settings.businessName);
    _niu = TextEditingController(text: settings.organizationNiu ?? '');
    _address = TextEditingController(text: settings.address ?? '');
    _taxRate = TextEditingController(
      text: ((settings.taxRateBasisPoints ?? 1925) / 100).toStringAsFixed(2),
    );
    _taxEnabled = settings.taxEnabled;
  }

  @override
  void dispose() {
    _businessName.dispose();
    _niu.dispose();
    _address.dispose();
    _taxRate.dispose();
    super.dispose();
  }

  int? _parseRate() {
    final value = _taxRate.text.trim().replaceAll(',', '.');
    if (value.isEmpty) return null;
    final parts = value.split('.');
    if (parts.length > 2 || parts.first.isEmpty) return null;
    final whole = int.tryParse(parts.first);
    final fraction = parts.length == 1
        ? 0
        : int.tryParse(parts[1].padRight(2, '0').substring(0, 2));
    if (whole == null ||
        fraction == null ||
        parts.length == 2 && parts[1].length > 2) {
      return null;
    }
    final basisPoints = whole * 100 + fraction;
    return basisPoints <= 10000 ? basisPoints : null;
  }

  Future<void> _saveProfile() async {
    final l10n = AppLocalizations.of(context)!;
    if (_businessName.text.trim().isEmpty) {
      _feedback(l10n.businessNameRequired, error: true);
      return;
    }
    setState(() => _savingProfile = true);
    try {
      await ref.read(organizationSettingsProvider.notifier).saveBusinessProfile(
            businessName: _businessName.text,
            niu: _niu.text,
            address: _address.text,
          );
      if (mounted) _feedback(l10n.settingsSaved);
    } catch (error) {
      if (mounted) _feedback(l10n.settingsSaveFailed('$error'), error: true);
    } finally {
      if (mounted) setState(() => _savingProfile = false);
    }
  }

  Future<void> _saveTax() async {
    final l10n = AppLocalizations.of(context)!;
    final rate = _parseRate();
    if (_taxEnabled && rate == null) {
      _feedback(l10n.taxFieldInvalid, error: true);
      return;
    }
    setState(() => _savingTax = true);
    try {
      await ref.read(organizationSettingsProvider.notifier).saveTax(
            enabled: _taxEnabled,
            rateBasisPoints: _taxEnabled ? rate : null,
          );
      if (mounted) _feedback(l10n.settingsSaved);
    } catch (error) {
      if (mounted) _feedback(l10n.settingsSaveFailed('$error'), error: true);
    } finally {
      if (mounted) setState(() => _savingTax = false);
    }
  }

  void _feedback(String message, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? Theme.of(context).colorScheme.error : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final enabled = widget.settings.isServerConfigured;
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                TextField(
                  controller: _businessName,
                  enabled: enabled && !_savingProfile,
                  decoration: InputDecoration(
                    labelText: l10n.businessNameLabel,
                    prefixIcon: const Icon(Icons.store_outlined),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextField(
                  controller: _niu,
                  enabled: enabled && !_savingProfile,
                  decoration: InputDecoration(
                    labelText: l10n.organizationNiuLabel,
                    prefixIcon: const Icon(Icons.badge_outlined),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextField(
                  controller: _address,
                  enabled: enabled && !_savingProfile,
                  decoration: InputDecoration(
                    labelText: l10n.businessAddressLabel,
                    prefixIcon: const Icon(Icons.location_on_outlined),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: enabled && !_savingProfile ? _saveProfile : null,
                    child: _savingProfile
                        ? const CircularProgressIndicator()
                        : Text(l10n.saveBusinessProfile),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.taxEnabled),
                  value: _taxEnabled,
                  onChanged: enabled && !_savingTax
                      ? (value) => setState(() => _taxEnabled = value)
                      : null,
                ),
                TextField(
                  controller: _taxRate,
                  enabled: enabled && !_savingTax,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*[,.]?\d{0,2}')),
                  ],
                  decoration: InputDecoration(
                    labelText: l10n.taxRateLabel,
                    hintText: l10n.taxRateOptional,
                    suffixText: '%',
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: enabled && !_savingTax ? _saveTax : null,
                    child: _savingTax
                        ? const CircularProgressIndicator()
                        : Text(l10n.saveTaxSettings),
                  ),
                ),
                if (!enabled) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(l10n.settingsUnavailable),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
