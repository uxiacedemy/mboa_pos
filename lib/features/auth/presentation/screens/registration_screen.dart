import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design/design_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key});
  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _business = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true, _submitting = false;
  String? _error;
  @override
  void dispose() {
    _business.dispose();
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
      await ref.read(authProvider.notifier).registerOwner(
          email: _email.text,
          password: _password.text,
          businessName: _business.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context)!.verificationSent)));
        context.go('/login');
      }
    } on AuthFailure catch (error) {
      if (mounted) setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
        backgroundColor: AppColors.checkoutCanvas,
        body: SafeArea(
            child: Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: SingleChildScrollView(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Card(
                            child: Padding(
                                padding: const EdgeInsets.all(AppSpacing.xl),
                                child: Form(
                                    key: _formKey,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Row(children: [
                                            Icon(Icons.point_of_sale_rounded,
                                                color: scheme.primary,
                                                size: 32),
                                            const SizedBox(
                                                width: AppSpacing.sm),
                                            Text('MboaPOS',
                                                style: AppTypography.titleLarge
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w800))
                                          ]),
                                          const SizedBox(height: AppSpacing.xl),
                                          Text(l10n.createBusiness,
                                              style: AppTypography
                                                  .headlineMedium
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w700)),
                                          const SizedBox(height: AppSpacing.xs),
                                          Text(l10n.authOwnerHint,
                                              style: AppTypography.bodyMedium
                                                  .copyWith(
                                                      color: scheme
                                                          .onSurfaceVariant)),
                                          const SizedBox(height: AppSpacing.lg),
                                          TextFormField(
                                              controller: _business,
                                              textInputAction:
                                                  TextInputAction.next,
                                              decoration: InputDecoration(
                                                  labelText: l10n.businessName,
                                                  prefixIcon: const Icon(Icons
                                                      .storefront_outlined)),
                                              validator: (value) => value ==
                                                          null ||
                                                      value.trim().length < 2
                                                  ? l10n.businessName
                                                  : null),
                                          const SizedBox(height: AppSpacing.md),
                                          TextFormField(
                                              controller: _email,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              textInputAction:
                                                  TextInputAction.next,
                                              decoration: InputDecoration(
                                                  labelText: l10n.email,
                                                  prefixIcon: const Icon(
                                                      Icons.email_outlined)),
                                              validator: (value) =>
                                                  value == null ||
                                                          !value.contains('@')
                                                      ? l10n.email
                                                      : null),
                                          const SizedBox(height: AppSpacing.md),
                                          TextFormField(
                                              controller: _password,
                                              obscureText: _obscure,
                                              textInputAction:
                                                  TextInputAction.done,
                                              decoration: InputDecoration(
                                                  labelText: l10n.password,
                                                  helperText:
                                                      l10n.passwordRequirement,
                                                  prefixIcon: const Icon(
                                                      Icons.lock_outline),
                                                  suffixIcon: IconButton(
                                                      tooltip: _obscure
                                                          ? l10n.showPassword
                                                          : l10n.hidePassword,
                                                      onPressed: () => setState(
                                                          () => _obscure =
                                                              !_obscure),
                                                      icon: Icon(_obscure
                                                          ? Icons
                                                              .visibility_outlined
                                                          : Icons
                                                              .visibility_off_outlined))),
                                              validator: (value) =>
                                                  value == null ||
                                                          value.length < 8
                                                      ? l10n.passwordRequirement
                                                      : null,
                                              onFieldSubmitted: (_) =>
                                                  _submit()),
                                          if (_error != null) ...[
                                            const SizedBox(
                                                height: AppSpacing.md),
                                            Text(_error!,
                                                style: TextStyle(
                                                    color: scheme.error))
                                          ],
                                          const SizedBox(height: AppSpacing.lg),
                                          FilledButton(
                                              onPressed:
                                                  _submitting ? null : _submit,
                                              child: _submitting
                                                  ? const SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                      child:
                                                          CircularProgressIndicator(
                                                              strokeWidth: 2))
                                                  : Text(l10n.createAccount)),
                                          const SizedBox(height: AppSpacing.sm),
                                          TextButton(
                                              onPressed: _submitting
                                                  ? null
                                                  : () => context.go('/login'),
                                              child: Text(l10n.backToLogin)),
                                        ])))))))));
  }
}
