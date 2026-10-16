import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/auth_repository.dart';
import '../../../core/errors/app_error.dart';

class AuthState {
  final bool isLoading;
  final AppErrorType? error; // String? → AppErrorType?

  const AuthState({this.isLoading = false, this.error});

  AuthState copyWith({
    bool? isLoading,
    AppErrorType? error,
    bool clearError = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  // ① Service 대신 Repository 사용
  late final _repository = ref.read(authRepositoryProvider);

  Future<bool> signIn({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await _repository.signIn(
        email: email,
        password: password,
      );
      return response.user != null;
    } catch (e) {
      state = state.copyWith(error: mapToAppError(e));
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await _repository.signInWithGoogle();
      return response.user != null;
    } catch (e) {
      state = state.copyWith(error: mapToAppError(e));
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> signInWithApple() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await _repository.signInWithApple();
      return response.user != null;
    } catch (e) {
      state = state.copyWith(error: mapToAppError(e));
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
    state = state.copyWith(isLoading: true, clearError: true); // clearError 추가
    try {
      final response = await _repository.signUp(
        email: email,
        password: password,
        nickname: nickname,
      );
      return response.user != null;
    } catch (e) {
      state = state.copyWith(error: mapToAppError(e));
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
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.deleteAccount();
      return true;
    } catch (e) {
      state = state.copyWith(error: mapToAppError(e));
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.sendPasswordResetEmail(email);
      return true;
    } catch (e) {
      state = state.copyWith(error: mapToAppError(e));
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> updatePassword(String newPassword) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.updatePassword(newPassword);
      return true;
    } catch (e) {
      state = state.copyWith(error: mapToAppError(e));
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void clearError() => state = state.copyWith(clearError: true);
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
