import 'package:flutter/material.dart';
import 'package:flutter_pt/features/auth/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>(); // ① Form 키
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _nicknameController = TextEditingController();
  bool _passwordVisible = false; // ② 비밀번호 보기/숨기기
  bool _passwordConfirmVisible = false;

  // ③ 유효성 검사 함수들
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return '이메일을 입력해주세요.';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return '올바른 이메일 형식이 아니에요.';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return '비밀번호를 입력해주세요.';
    if (value.length < 8) return '비밀번호는 8자 이상이어야 해요.';
    final specialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    if (!specialChar.hasMatch(value)) return '특수문자를 1개 이상 포함해주세요.';
    return null;
  }

  String? _validatePasswordConfirm(String? value) {
    if (value == null || value.isEmpty) return '비밀번호를 한 번 더 입력해주세요.';
    if (value != _passwordController.text) return '비밀번호가 일치하지 않아요.';
    return null;
  }

  String? _validateNickname(String? value) {
    if (value == null || value.isEmpty) return '닉네임을 입력해주세요.';
    if (value.length < 2) return '닉네임은 2자 이상이어야 해요.';
    return null;
  }

  void _goToTerms() {
    // ④ 유효성 검사 통과 시에만 terms로 이동
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
      appBar: AppBar(title: const Text('회원가입')),
      body: SingleChildScrollView(
        // ⑤ 키보드 올라와도 스크롤 가능
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey, // ⑥ Form 연결
          child: Column(
            children: [
              // 이메일
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: '이메일'),
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail, // ⑦ 검사 함수 연결
              ),
              const SizedBox(height: 16),

              // 비밀번호
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () =>
                        setState(() => _passwordVisible = !_passwordVisible),
                  ),
                ),
                obscureText: !_passwordVisible,
                validator: _validatePassword,
              ),
              const SizedBox(height: 16),

              // 비밀번호 확인
              TextFormField(
                controller: _passwordConfirmController,
                decoration: InputDecoration(
                  labelText: '비밀번호 확인',
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
                obscureText: !_passwordConfirmVisible,
                validator: _validatePasswordConfirm,
              ),
              const SizedBox(height: 16),

              // 닉네임
              TextFormField(
                controller: _nicknameController,
                decoration: const InputDecoration(labelText: '닉네임'),
                validator: _validateNickname,
              ),
              const SizedBox(height: 24),

              // 회원가입 버튼
              ElevatedButton(
                onPressed: isLoading ? null : _goToTerms,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('회원가입'),
              ),
              TextButton(
                onPressed: () => context.go('/login'),
                child: const Text('이미 계정이 있어요? 로그인'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
