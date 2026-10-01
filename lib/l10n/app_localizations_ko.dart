// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '내 앱';

  @override
  String hello(String name) {
    return '안녕하세요, $name님';
  }

  @override
  String homeGreeting(String nickname) {
    return '안녕하세요, $nickname님!';
  }

  @override
  String get settingsLanguage => '언어';

  @override
  String get languageSystem => '시스템 설정 따름';

  @override
  String get darkmode => '다크모드';

  @override
  String get setting => '세팅';

  @override
  String get profile => '프로필';

  @override
  String profileEmail(String email) {
    return '이메일: $email';
  }

  @override
  String profileNickname(String nickname) {
    return '닉네임: $nickname';
  }
}
