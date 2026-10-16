import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../../../core/errors/app_error_l10n.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_snack_bar.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../l10n/l10n_extension.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _sent = false;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return context.l10n.validationEmailRequired;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return context.l10n.validationEmailInvalid;
    return null;
  }

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref
        .read(authProvider.notifier)
        .sendPasswordResetEmail(_emailController.text.trim());

    if (!mounted) return;
    if (success) {
      setState(() => _sent = true);
    } else {
      final error = ref.read(authProvider).error;
      AppSnackBar.show(
        context,
        message: error?.message(context) ?? context.l10n.errorUnknown,
        type: SnackBarType.error,
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.forgotPasswordTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: _sent
            ? Column(
                children: [
                  const SizedBox(height: 48),
                  const Icon(Icons.mark_email_read_outlined, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    context.l10n.forgotPasswordSent,
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            : Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.l10n.forgotPasswordDescription),
                    const SizedBox(height: 24),
                    AppTextField(
                      controller: _emailController,
                      label: context.l10n.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: _validateEmail,
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    const SizedBox(height: 24),
                    AppButton(
                      label: context.l10n.forgotPasswordSend,
                      isLoading: isLoading,
                      onPressed: _send,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
