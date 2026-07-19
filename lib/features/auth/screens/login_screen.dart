import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../auth/providers/auth_provider.dart';
import '../../profile/providers/profile_provider.dart';
import '../../../core/services/fcm_service.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/app_snack_bar.dart';

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
    if (value == null || value.isEmpty) return '이메일을 입력해주세요.';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return '올바른 이메일 형식이 아니에요.';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return '비밀번호를 입력해주세요.';
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error ?? '로그인 실패')));
    }
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
      appBar: AppBar(title: const Text('로그인')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AppTextField(
                controller: _emailController,
                label: '이메일',
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _passwordController,
                label: '비밀번호',
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
              AppButton(label: '로그인', isLoading: isLoading, onPressed: _signIn),
              TextButton(
                onPressed: () => context.push('/signup'),
                child: const Text('회원가입 하기'),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () async {
                  final success = await ref
                      .read(authProvider.notifier)
                      .signInWithGoogle();

                  if (success) {
                    final userId =
                        Supabase.instance.client.auth.currentUser!.id;
                    final profile = await Supabase.instance.client
                        .from('profiles')
                        .select('terms_agreed_at')
                        .eq('id', userId)
                        .single();

                    if (!mounted) return;
                    if (profile['terms_agreed_at'] == null) {
                      context.push(
                        '/terms',
                        extra: {'from': 'google'},
                      ); // 처음 가입
                    } else {
                      await ref.read(profileProvider.notifier).loadProfile();
                      if (!mounted) return;
                      context.go('/home');
                    }
                  } else {
                    final error = ref.read(authProvider).error;
                    if (!mounted) return;
                    AppSnackBar.show(
                      context,
                      message: error ?? '로그인 실패',
                      type: SnackBarType.error,
                    );
                  }
                },
                icon: const FaIcon(FontAwesomeIcons.google, size: 20),
                label: const Text('구글로 로그인'),
              ),
              OutlinedButton.icon(
                onPressed: () async {
                  final success = await ref
                      .read(authProvider.notifier)
                      .signInWithApple();

                  if (success) {
                    // 약관 동의 여부 확인
                    final userId =
                        Supabase.instance.client.auth.currentUser!.id;
                    final profile = await Supabase.instance.client
                        .from('profiles')
                        .select('terms_agreed_at')
                        .eq('id', userId)
                        .single();

                    if (!mounted) return;

                    if (profile['terms_agreed_at'] == null) {
                      context.push(
                        '/terms',
                        extra: <String, dynamic>{'from': 'apple'},
                      );
                    } else {
                      await ref.read(profileProvider.notifier).loadProfile();
                      await FcmService().initialize();
                      if (!mounted) return;
                      context.go('/home');
                    }
                  } else {
                    final error = ref.read(authProvider).error;
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(error ?? '애플 로그인 실패')),
                    );
                  }
                },
                icon: const Icon(Icons.apple, size: 24),
                label: const Text('Apple로 로그인'),
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
