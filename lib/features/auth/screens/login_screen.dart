import 'package:flutter/material.dart';
import 'package:flutter_pt/core/errors/app_error_l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../auth/providers/auth_provider.dart';
import '../../profile/providers/profile_provider.dart';
import '../../../features/auth/repositories/auth_repository.dart';
import '../../../core/services/fcm_service.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/app_snack_bar.dart';
import '../../../l10n/l10n_extension.dart';
import '../../../core/errors/app_error.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;

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
    return null;
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref
        .read(authProvider.notifier)
        .signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

    if (success) {
      await ref.read(profileProvider.notifier).loadProfile();
      try {
        await FcmService().initialize();
      } catch (e) {
        debugPrint('Fcm initailize error after login: $e');
      }

      if (!mounted) return;
      context.go('/home');
    } else {
      final error = ref.read(authProvider).error;
      if (!mounted) return;
      if (error != null && error != AppErrorType.userCancelled) {
        AppSnackBar.show(
          context,
          message: error.message(context),
          type: SnackBarType.error,
        );
      }
    }
  }

  Future<void> _signInWithGoogle() => _socialSignIn(
    () => ref.read(authProvider.notifier).signInWithGoogle(),
    'google',
  );

  Future<void> _signInWithApple() => _socialSignIn(
    () => ref.read(authProvider.notifier).signInWithApple(),
    'apple',
  );

  Future<void> _socialSignIn(
    Future<bool> Function() signIn,
    String from,
  ) async {
    final success = await signIn();
    if (!mounted) return;

    if (!success) {
      final error = ref.read(authProvider).error;
      if (error != null && error != AppErrorType.userCancelled) {
        AppSnackBar.show(
          context,
          message: error.message(context),
          type: SnackBarType.error,
        );
      }
      return;
    }

    final userId = Supabase.instance.client.auth.currentUser!.id;
    final hasAgreed = await ref
        .read(authRepositoryProvider)
        .hasAgreedToTerms(userId);
    if (!mounted) return;

    if (!hasAgreed) {
      context.push('/terms', extra: <String, dynamic>{'from': from});
      return;
    }

    await ref.read(profileProvider.notifier).loadProfile();
    if (!mounted) return;
    context.go('/home');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.sign_in)),
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
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _passwordController,
                label: context.l10n.password,
                obscureText: !_passwordVisible,
                validator: _validatePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () =>
                      setState(() => _passwordVisible = !_passwordVisible),
                ),
              ),
              const SizedBox(height: 24),
              AppButton(
                label: context.l10n.sign_in,
                isLoading: isLoading,
                onPressed: isLoading ? null : _signIn,
              ),
              TextButton(
                onPressed: () => context.push('/forgot-password'),
                child: Text(context.l10n.forgotPasswordLink),
              ),
              TextButton(
                onPressed: () => context.push('/signup'),
                child: Text(context.l10n.sign_up),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: isLoading ? null : _signInWithGoogle,
                icon: const FaIcon(FontAwesomeIcons.google, size: 20),
                label: Text(context.l10n.loginWithGoogle),
              ),
              OutlinedButton.icon(
                onPressed: isLoading ? null : _signInWithApple,
                icon: const Icon(Icons.apple, size: 24),
                label: Text(context.l10n.loginWithApple),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
