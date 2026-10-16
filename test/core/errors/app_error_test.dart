import 'package:flutter_pt/core/errors/app_error.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('mapToAppError', () {
    test('AppException은 담긴 type을 그대로 반환', () {
      expect(
        mapToAppError(const AppException(AppErrorType.accountDeleted)),
        AppErrorType.accountDeleted,
      );
    });

    test('invalid_credentials 코드', () {
      expect(
        mapToAppError(AuthException('x', code: 'invalid_credentials')),
        AppErrorType.invalidCredentials,
      );
    });

    test('code가 없어도 메시지로 판별 (Invalid login credentials)', () {
      expect(
        mapToAppError(AuthException('Invalid login credentials')),
        AppErrorType.invalidCredentials,
      );
    });

    test('이미 가입된 이메일', () {
      expect(
        mapToAppError(AuthException('User already registered')),
        AppErrorType.emailAlreadyRegistered,
      );
      expect(
        mapToAppError(AuthException('x', code: 'user_already_exists')),
        AppErrorType.emailAlreadyRegistered,
      );
    });

    test('이메일 미인증 / 약한 비밀번호 / 요청 과다', () {
      expect(
        mapToAppError(AuthException('x', code: 'email_not_confirmed')),
        AppErrorType.emailNotConfirmed,
      );
      expect(
        mapToAppError(AuthException('x', code: 'weak_password')),
        AppErrorType.weakPassword,
      );
      expect(
        mapToAppError(AuthException('x', code: 'over_request_rate_limit')),
        AppErrorType.tooManyRequests,
      );
    });

    test('만료된 링크 (otp_expired)', () {
      expect(
        mapToAppError(AuthException('x', code: 'otp_expired')),
        AppErrorType.linkExpired,
      );
    });

    test('애플 로그인 취소는 userCancelled', () {
      expect(
        mapToAppError(
          SignInWithAppleAuthorizationException(
            code: AuthorizationErrorCode.canceled,
            message: 'canceled',
          ),
        ),
        AppErrorType.userCancelled,
      );
    });

    test('네트워크 예외', () {
      expect(
        mapToAppError(Exception('SocketException: Failed host lookup')),
        AppErrorType.network,
      );
    });

    test('알 수 없는 예외는 unknown', () {
      expect(mapToAppError(Exception('boom')), AppErrorType.unknown);
    });
  });
}
