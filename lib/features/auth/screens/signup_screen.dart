import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../l10n/l10n_extension.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _nicknameController = TextEditingController();
  bool _passwordVisible = false;
  bool _passwordConfirmVisible = false;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return context.l10n.validationEmailRequired;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return context.l10n.validationEmailInvalid;
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return context.l10n.validationPasswordRequired;
    }
    if (value.length < 8) return context.l10n.validationPasswordMinLength(8);
    final specialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    if (!specialChar.hasMatch(value)) {
      return context.l10n.validationPasswordSpecialChar;
    }
    return null;
  }

  String? _validatePasswordConfirm(String? value) {
    if (value == null || value.isEmpty) {
      return context.l10n.validationPasswordConfirmRequired;
    }
    if (value != _passwordController.text) {
      return context.l10n.validationPasswordMismatch;
    }
    return null;
  }

  String? _validateNickname(String? value) {
    if (value == null || value.isEmpty) {
      return context.l10n.validationNicknameRequired;
    }
    if (value.length < 2) return context.l10n.validationNicknameMinLength(2);
    return null;
  }

  void _goToTerms() {
    if (!_formKey.currentState!.validate()) return;
    context.push(
      '/terms',
      extra: <String, dynamic>{
        'from': 'signup',
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
        'nickname': _nicknameController.text.trim(),
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.sign_up)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AppTextField(
                controller: _emailController,
                label: context.l10n.email,
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
                prefixIcon: const Icon(Icons.email_outlined),
              ),
              const SizedBox(height: 16),

              AppTextField(
                controller: _passwordController,
                label: context.l10n.password,
                obscureText: !_passwordVisible,
                validator: _validatePassword,
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () =>
                      setState(() => _passwordVisible = !_passwordVisible),
                ),
              ),
              const SizedBox(height: 16),

              AppTextField(
                controller: _passwordConfirmController,
                label: context.l10n.signupPasswordConfirm,
                obscureText: !_passwordConfirmVisible,
                validator: _validatePasswordConfirm,
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordConfirmVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () => setState(
                    () => _passwordConfirmVisible = !_passwordConfirmVisible,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              AppTextField(
                controller: _nicknameController,
                label: context.l10n.nickname,
                validator: _validateNickname,
                prefixIcon: const Icon(Icons.person_outline),
              ),
              const SizedBox(height: 24),

              AppButton(
                label: context.l10n.sign_up,
                isLoading: isLoading,
                onPressed: _goToTerms,
                icon: Icons.arrow_forward,
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => context.go('/login'),
                child: Text(context.l10n.signupHaveAccount),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
