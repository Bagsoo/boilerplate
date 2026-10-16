import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../../../core/errors/app_error_l10n.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_snack_bar.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/errors/app_error.dart';
import '../../../l10n/l10n_extension.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _visible = false;

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

  String? _validateConfirm(String? value) {
    if (value == null || value.isEmpty) {
      return context.l10n.validationPasswordConfirmRequired;
    }
    if (value != _passwordController.text) {
      return context.l10n.validationPasswordMismatch;
    }
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref
        .read(authProvider.notifier)
        .updatePassword(_passwordController.text.trim());

    if (!mounted) return;
    if (success) {
      AppSnackBar.show(
        context,
        message: context.l10n.resetPasswordSuccess,
        type: SnackBarType.success,
      );
      context.go('/home');
    } else {
      final error = ref.read(authProvider).error;
      AppSnackBar.show(
        context,
        message: error?.message(context) ?? context.l10n.errorUnknown,
        type: SnackBarType.error,
      );
      if (error == AppErrorType.linkExpired) {
        context.go('/forgot-password');
      }
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.resetPasswordTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AppTextField(
                controller: _passwordController,
                label: context.l10n.resetPasswordNew,
                obscureText: !_visible,
                validator: _validatePassword,
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _visible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () => setState(() => _visible = !_visible),
                ),
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _confirmController,
                label: context.l10n.signupPasswordConfirm,
                obscureText: !_visible,
                validator: _validateConfirm,
                prefixIcon: const Icon(Icons.lock_outline),
              ),
              const SizedBox(height: 24),
              AppButton(
                label: context.l10n.resetPasswordSubmit,
                isLoading: isLoading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
