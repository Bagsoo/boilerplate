import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final _authService = AuthService();
  final _client = Supabase.instance.client;

  // 이메일 로그인
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _authService.signIn(email: email, password: password);
  }

  // 회원가입
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String nickname,
  }) async {
    return await _authService.signUp(
      email: email,
      password: password,
      nickname: nickname,
    );
  }

  // 구글 로그인
  Future<AuthResponse> signInWithGoogle() async {
    return await _authService.signInWithGoogle();
  }

  // 애플 로그인
  Future<AuthResponse> signInWithApple() async {
    return await _authService.signInWithApple();
  }

  // 로그아웃
  Future<void> signOut() async {
    await _authService.signOut();
  }

  // 회원탈퇴
  Future<void> deleteAccount() async {
    await _authService.deleteAccount();
  }

  // 약관 동의 여부 확인
  Future<bool> hasAgreedToTerms(String userId) async {
    final profile = await _client
        .from('profiles')
        .select('terms_agreed_at')
        .eq('id', userId)
        .single();
    return profile['terms_agreed_at'] != null;
  }

  // 현재 유저
  User? get currentUser => _client.auth.currentUser;

  // 현재 세션
  Session? get currentSession => _client.auth.currentSession;
}

// Provider 등록
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});
