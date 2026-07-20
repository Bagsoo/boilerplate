import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repositories/auth_repository.dart';

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

  // ① Service 대신 Repository 사용
  late final _repository = ref.read(authRepositoryProvider);

  Future<bool> signIn({required String email, required String password}) async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await _repository.signIn(
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

  Future<bool> signInWithGoogle() async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await _repository.signInWithGoogle();
      return response.user != null;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> signInWithApple() async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await _repository.signInWithApple();
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
      final response = await _repository.signUp(
        email: email,
        password: password,
        nickname: nickname,
      );
      return response.user != null;
    } on AuthException catch (e) {
      state = state.copyWith(error: _translateError(e.message));
      return false;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    try {
      await _repository.signOut();
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> deleteAccount() async {
    state = state.copyWith(isLoading: true);
    try {
      await _repository.deleteAccount();
      return true;
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

  void clearError() => state = state.copyWith(error: null);
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
