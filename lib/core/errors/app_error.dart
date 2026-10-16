import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

enum AppErrorType {
  invalidCredentials, // 이메일/비밀번호 불일치
  emailAlreadyRegistered, // 이미 가입된 이메일
  emailNotConfirmed, // 이메일 인증 미완료
  accountDeleted, // 탈퇴한 계정
  userCancelled, // 소셜 로그인 취소 (에러로 표시 안 함)
  network, // 네트워크 오류
  weakPassword, // 비밀번호 정책 위반
  tooManyRequests, // 요청 과다
  linkExpired, // 재설정/인증 링크만료
  unknown,
}

/// 서비스 계층에서 던지는 앱 전용 예외
class AppException implements Exception {
  final AppErrorType type;
  const AppException(this.type);
  @override
  String toString() => 'AppException($type)';
}

/// 어떤 예외든 AppErrorType으로 변환
AppErrorType mapToAppError(Object e) {
  if (e is AppException) return e.type;

  if (e is SignInWithAppleAuthorizationException &&
      e.code == AuthorizationErrorCode.canceled) {
    return AppErrorType.userCancelled;
  }

  if (e is AuthException) {
    final code = e.code ?? '';
    final msg = e.message.toLowerCase();

    if (code == 'invalid_credentials' || msg.contains('invalid login')) {
      return AppErrorType.invalidCredentials;
    }
    if (code == 'user_already_exists' ||
        code == 'email_exists' ||
        msg.contains('already registered')) {
      return AppErrorType.emailAlreadyRegistered;
    }
    if (code == 'email_not_confirmed' || msg.contains('not confirmed')) {
      return AppErrorType.emailNotConfirmed;
    }
    if (code == 'weak_password') return AppErrorType.weakPassword;
    if (code == 'over_request_rate_limit' ||
        code == 'over_email_send_rate_limit') {
      return AppErrorType.tooManyRequests;
    }

    if (code == 'otp_expired' ||
        msg.contains('expired') ||
        msg.contains('invalid or has expired')) {
      return AppErrorType.linkExpired;
    }
  }

  final text = e.toString().toLowerCase();
  if (text.contains('socketexception') ||
      text.contains('clientexception') ||
      text.contains('failed host lookup') ||
      text.contains('network')) {
    return AppErrorType.network;
  }
  return AppErrorType.unknown;
}
