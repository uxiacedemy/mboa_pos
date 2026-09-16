import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design/design_tokens.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _staffIdController = TextEditingController();
  final _pinController = TextEditingController();
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _staffIdController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });
    try {
      await ref.read(authProvider.notifier).signIn(
            staffId: _staffIdController.text.trim(),
            pin: _pinController.text,
          );
      if (mounted) context.go('/pos');
    } catch (error) {
      if (mounted) {
        setState(() => _errorMessage = error.toString());
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Icons.point_of_sale, size: 72, color: colorScheme.primary),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'MboaPOS',
                textAlign: TextAlign.center,
                style: AppTypography.headlineLarge.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Point de Vente Intelligent',
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              TextFormField(
                controller: _staffIdController,
                decoration: InputDecoration(
                  labelText: 'Identifiant staff',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(borderRadius: AppRadius.input),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _pinController,
                decoration: InputDecoration(
                  labelText: 'PIN',
                  prefixIcon: const Icon(Icons.lock_outlined),
                  border: OutlineInputBorder(borderRadius: AppRadius.input),
                ),
                obscureText: true,
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  _errorMessage!,
                  style: TextStyle(color: colorScheme.error),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              FilledButton(
                onPressed: _isSubmitting ? null : _signIn,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),
                ),
                child: _isSubmitting
                  ? const CircularProgressIndicator()
                  : const Text('Se connecter', style: AppTypography.buttonLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
