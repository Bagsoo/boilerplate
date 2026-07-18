import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';

// 인증상태를 나타내는 클래스
class AuthState {
  final bool isLoading;
  final String? error;

  const AuthState({this.isLoading = false, this.error});

  AuthState copyWith({bool? isLoading, String? error}) {
    return AuthState(isLoading: isLoading ?? this.isLoading, error: error);
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  final _authService = AuthService();

  // 로그인
  Future<bool> signIn({required String email, required String password}) async {
    state = state.copyWith(isLoading: true); // 로딩 시작

    try {
      final response = await _authService.signIn(
        email: email,
        password: password,
      );
      return response.user != null;
    } on AuthException catch (e) {
      state = state.copyWith(error: e.message);
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // 구글 로그인
  Future<bool> signInWithGoogle() async {
    state = state.copyWith(isLoading: true);

    try {
      final response = await _authService.signInWithGoogle();
      return response.user != null;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // 애플 로그인
  Future<bool> signInWithApple() async {
    state = state.copyWith(isLoading: true);

    try {
      final response = await _authService.signInWithApple();
      return response.user != null;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String nickname,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      final response = await _authService.signUp(
        email: email,
        password: password,
        nickname: nickname,
      );
      return response.user != null;
    } on AuthException catch (e) {
      state = state.copyWith(
        error: _translateError(e.message),
      ); // throw 대신 state에 저장
      return false;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  String _translateError(String message) {
    if (message.contains('already registered') ||
        message.contains('User already registered')) {
      return '이미 사용 중인 이메일이에요.';
    }
    return message;
  }

  // 로그아웃
  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);

    try {
      await _authService.signOut();
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // 회원 탈퇴
  Future<bool> deleteAccount() async {
    state = state.copyWith(isLoading: true);

    try {
      await _authService.deleteAccount();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // 에러 초기화
  void clearError() {
    state = state.copyWith(error: null);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
