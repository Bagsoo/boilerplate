import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'package:crypto/crypto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import '../../profile/services/profile_service.dart';
import '../../../core/services/fcm_service.dart';
import '../../../core/logger.dart';
import '../../../core/errors/app_error.dart';
import '../../../core/app_config.dart';

class AuthService {
  final _client = Supabase.instance.client;
  StreamSubscription? _authSubscription;

  // 세션 상태 감지 시작
  void listenAuthState({
    required VoidCallback onSignedOut,
    VoidCallback? onPasswordRecovery,
  }) {
    _authSubscription = _client.auth.onAuthStateChange.listen((data) {
      final event = data.event;

      switch (event) {
        case AuthChangeEvent.signedOut:
          onSignedOut();
          break;
        case AuthChangeEvent.passwordRecovery:
          onPasswordRecovery?.call();
          break;
        case AuthChangeEvent.tokenRefreshed:
          logger.i('토큰 갱신 성공');
          break;
        case AuthChangeEvent.signedIn:
          logger.i('로그인 감지');
          break;
        default:
          break;
      }
    });
  }

  void disposeAuthListener() {
    _authSubscription?.cancel();
  }

  // 회원가입
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String nickname,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'nickname': nickname},
    );

    // Confirm email ON일 때: 이미 가입된 이메일이면 에러 대신 identities가 빈 배열로 옴
    if (response.user != null &&
        (response.user!.identities?.isEmpty ?? false)) {
      throw const AppException(AppErrorType.emailAlreadyRegistered);
    }
    return response;
  }

  // 로그인
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    // 탈퇴한 유저인지 확인
    if (response.user != null) {
      final profile = await _client
          .from('profiles')
          .select('is_deleted')
          .eq('id', response.user!.id)
          .single();

      if (profile['is_deleted'] == true) {
        await _client.auth.signOut(); // 바로 로그아웃
        throw const AppException(AppErrorType.accountDeleted);
      }
    }

    return response;
  }

  Future<AuthResponse> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn(); // ① 구글 계정 선택 팝업

    if (googleUser == null) {
      throw const AppException(AppErrorType.userCancelled);
    }

    final googleAuth = await googleUser.authentication;

    return await _client.auth.signInWithIdToken(
      // ② Supabase에 토큰 전달
      provider: OAuthProvider.google,
      idToken: googleAuth.idToken!,
      accessToken: googleAuth.accessToken,
    );
  }

  // nonce 생성 (보안용)
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<AuthResponse> signInWithApple() async {
    final rawNonce = _generateNonce();
    final hashedNonce = _sha256ofString(rawNonce);

    // ① 애플 로그인 팝업
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce,
    );

    // ② Supabase에 토큰 전달
    return await _client.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: credential.identityToken!,
      nonce: rawNonce,
    );
  }

  Future<void> signOut() async {
    if (Firebase.apps.isNotEmpty) {
      try {
        await FcmService().deleteToken();
      } catch (e) {
        logger.w('FCM 토큰 삭제 실패: $e'); // 실패해도 로그아웃은 진행
      }
    }
    await _client.auth.signOut();
  }

  // 현재 로그인된 유저 가져오기
  User? getCurrentUser() {
    return _client.auth.currentUser;
  }

  // 비밀번호 재설정 메일 발송
  Future<void> sendPasswordResetEmail(String email) async {
    await _client.auth.resetPasswordForEmail(
      email,
      redirectTo: AppConfig.passwordResetRedirect,
    );
  }

  // 새 비밀번호 설정 (재설정 링크로 들어온 세션 필요)
  Future<void> updatePassword(String newPassword) async {
    await _client.auth.updateUser(UserAttributes(password: newPassword));
  }

  // 회원 탈퇴
  Future<void> deleteAccount() async {
    if (Firebase.apps.isNotEmpty) {
      try {
        await FcmService().deleteToken();
      } catch (e) {
        logger.w('FCM 토큰 삭제 실패: $e');
      }
    }
    await ProfileService().deleteAvatar();
    await _client.rpc('delete_user');
    await _client.auth.signOut();
  }
}
