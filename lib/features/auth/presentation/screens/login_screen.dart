import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design/design_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _staffId = TextEditingController();
  final _pin = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _staffMode = true;
  bool _obscure = true;
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _staffId.dispose();
    _pin.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting || !(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      if (_staffMode) {
        await ref
            .read(authProvider.notifier)
            .signIn(staffId: _staffId.text, pin: _pin.text);
      } else {
        await ref
            .read(authProvider.notifier)
            .signInOwner(email: _email.text, password: _password.text);
      }
      if (mounted) context.go('/pos');
    } on AuthFailure catch (error) {
      if (mounted) {
        setState(() => _error = error.message);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _error = AppLocalizations.of(context)!.authGeneric);
      }
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _forgotPassword() async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: _email.text);
    final value = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.forgotPassword),
        content: TextField(
            controller: controller,
            autofocus: true,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(labelText: l10n.email)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.authClose)),
          FilledButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: Text(l10n.signIn)),
        ],
      ),
    );
    controller.dispose();
    if (value == null || value.trim().isEmpty || !mounted) return;
    try {
      await ref.read(authProvider.notifier).sendPasswordReset(value);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.resetSent)));
      }
    } on AuthFailure catch (error) {
      if (mounted) {
        setState(() => _error = error.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 960;
    final form = _AuthForm(
      formKey: _formKey,
      staffMode: _staffMode,
      staffId: _staffId,
      pin: _pin,
      email: _email,
      password: _password,
      obscure: _obscure,
      submitting: _submitting,
      error: _error,
      onToggleObscure: () => setState(() => _obscure = !_obscure),
      onModeChanged: (value) => setState(() {
        _staffMode = value;
        _error = null;
      }),
      onSubmit: _submit,
      onForgot: _forgotPassword,
      onCreateBusiness: () => context.go('/register'),
    );
    return Scaffold(
      backgroundColor: AppColors.checkoutCanvas,
      body: SafeArea(
          child: Center(
              child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: wide ? 1180 : 520),
        child: Padding(
          padding: EdgeInsets.all(wide ? AppSpacing.xl : AppSpacing.md),
          child: wide
              ? Row(children: [
                  const Expanded(child: _BrandPanel()),
                  const SizedBox(width: AppSpacing.xl),
                  Expanded(child: form)
                ])
              : SingleChildScrollView(
                  child: Column(children: [const _CompactBrand(), form])),
        ),
      ))),
    );
  }
}

class _BrandPanel extends StatelessWidget {
  const _BrandPanel();
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    return Container(
      constraints: const BoxConstraints(minHeight: 560),
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration:
          BoxDecoration(color: scheme.primary, borderRadius: AppRadius.card),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.point_of_sale_rounded,
                size: 52, color: scheme.onPrimary),
            const SizedBox(height: AppSpacing.xl),
            Text('MboaPOS',
                style: AppTypography.displayLarge.copyWith(
                    color: scheme.onPrimary, fontWeight: FontWeight.w800)),
            const SizedBox(height: AppSpacing.md),
            Text(l10n.brandPromise,
                style: AppTypography.titleLarge
                    .copyWith(color: scheme.onPrimary, height: 1.2)),
            const SizedBox(height: AppSpacing.xl),
            _Benefit(icon: Icons.flash_on_outlined, text: l10n.brandBenefitOne),
            _Benefit(
                icon: Icons.inventory_2_outlined, text: l10n.brandBenefitTwo),
            _Benefit(
                icon: Icons.cloud_off_outlined, text: l10n.brandBenefitThree),
            const SizedBox(height: AppSpacing.lg),
            Icon(Icons.receipt_long_rounded,
                size: 120, color: scheme.onPrimary.withValues(alpha: .14)),
          ]),
    );
  }
}

class _CompactBrand extends StatelessWidget {
  const _CompactBrand();
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Row(children: [
        Icon(Icons.point_of_sale_rounded,
            color: Theme.of(context).colorScheme.primary, size: 32),
        const SizedBox(width: AppSpacing.sm),
        Text('MboaPOS',
            style:
                AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w800))
      ]));
}

class _Benefit extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Benefit({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(children: [
        Icon(icon, color: Theme.of(context).colorScheme.onPrimary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
            child: Text(text,
                style: AppTypography.bodyLarge
                    .copyWith(color: Theme.of(context).colorScheme.onPrimary)))
      ]));
}

class _AuthForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final bool staffMode, obscure, submitting;
  final TextEditingController staffId, pin, email, password;
  final String? error;
  final VoidCallback onToggleObscure, onSubmit, onForgot, onCreateBusiness;
  final ValueChanged<bool> onModeChanged;
  const _AuthForm(
      {required this.formKey,
      required this.staffMode,
      required this.staffId,
      required this.pin,
      required this.email,
      required this.password,
      required this.obscure,
      required this.submitting,
      required this.error,
      required this.onToggleObscure,
      required this.onModeChanged,
      required this.onSubmit,
      required this.onForgot,
      required this.onCreateBusiness});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Form(
                key: formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(l10n.authWelcome,
                          style: AppTypography.headlineMedium
                              .copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: AppSpacing.xs),
                      Text(staffMode ? l10n.authStaffHint : l10n.authOwnerHint,
                          style: AppTypography.bodyMedium
                              .copyWith(color: scheme.onSurfaceVariant)),
                      const SizedBox(height: AppSpacing.lg),
                      SegmentedButton<bool>(
                          segments: [
                            ButtonSegment(
                                value: true,
                                label: Text(l10n.authStaff),
                                icon: const Icon(Icons.badge_outlined)),
                            ButtonSegment(
                                value: false,
                                label: Text(l10n.authOwner),
                                icon: const Icon(Icons.business_outlined))
                          ],
                          selected: {
                            staffMode
                          },
                          onSelectionChanged: submitting
                              ? null
                              : (value) => onModeChanged(value.first)),
                      const SizedBox(height: AppSpacing.lg),
                      AnimatedSwitcher(
                          duration: const Duration(milliseconds: 180),
                          child: staffMode
                              ? _staffFields(l10n)
                              : _ownerFields(l10n)),
                      if (error != null) ...[
                        const SizedBox(height: AppSpacing.md),
                        Semantics(
                            liveRegion: true,
                            child: Container(
                                padding: const EdgeInsets.all(AppSpacing.sm),
                                decoration: BoxDecoration(
                                    color: scheme.errorContainer,
                                    borderRadius: AppRadius.card),
                                child: Text(error!,
                                    style: TextStyle(
                                        color: scheme.onErrorContainer))))
                      ],
                      const SizedBox(height: AppSpacing.lg),
                      FilledButton(
                          onPressed: submitting ? null : onSubmit,
                          child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 180),
                              child: submitting
                                  ? const SizedBox(
                                      key: ValueKey('loading'),
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2))
                                  : Text(
                                      key: const ValueKey('label'),
                                      l10n.signIn))),
                      if (!staffMode) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                                onPressed: submitting ? null : onForgot,
                                child: Text(l10n.forgotPassword)))
                      ],
                      const Divider(height: AppSpacing.xl),
                      OutlinedButton.icon(
                          onPressed: submitting ? null : onCreateBusiness,
                          icon: const Icon(Icons.add_business_outlined),
                          label: Text(l10n.createBusiness)),
                      if (staffMode) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Text(l10n.forgotPin,
                            textAlign: TextAlign.center,
                            style: AppTypography.bodySmall
                                .copyWith(color: scheme.onSurfaceVariant))
                      ],
                    ]))));
  }

  Widget _staffFields(AppLocalizations l10n) =>
      Column(key: const ValueKey('staff'), children: [
        TextFormField(
            controller: staffId,
            autofocus: true,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
                labelText: l10n.staffId,
                prefixIcon: const Icon(Icons.badge_outlined)),
            validator: (value) =>
                value == null || value.trim().isEmpty ? l10n.staffId : null),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
            controller: pin,
            obscureText: obscure,
            keyboardType: TextInputType.number,
            maxLength: 6,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
                labelText: l10n.pin,
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                    tooltip: obscure ? l10n.showPin : l10n.hidePin,
                    onPressed: onToggleObscure,
                    icon: Icon(obscure
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined)),
                counterText: ''),
            validator: (value) =>
                value == null || value.length < 4 ? l10n.pin : null,
            onFieldSubmitted: (_) => onSubmit)
      ]);
  Widget _ownerFields(AppLocalizations l10n) =>
      Column(key: const ValueKey('owner'), children: [
        TextFormField(
            controller: email,
            autofocus: true,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
                labelText: l10n.email,
                prefixIcon: const Icon(Icons.email_outlined)),
            validator: (value) =>
                value == null || !value.contains('@') ? l10n.email : null),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
            controller: password,
            obscureText: obscure,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
                labelText: l10n.password,
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                    tooltip: obscure ? l10n.showPassword : l10n.hidePassword,
                    onPressed: onToggleObscure,
                    icon: Icon(obscure
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined))),
            validator: (value) => value == null || value.length < 8
                ? l10n.passwordRequirement
                : null,
            onFieldSubmitted: (_) => onSubmit)
      ]);
}
