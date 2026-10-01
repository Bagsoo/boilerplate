// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'My App';

  @override
  String hello(String name) {
    return 'Hello, $name';
  }

  @override
  String homeGreeting(String nickname) {
    return 'Hello, $nickname!';
  }

  @override
  String get settingsLanguage => 'Language';

  @override
  String get languageSystem => 'System default';

  @override
  String get darkmode => 'darkmode';

  @override
  String get setting => 'setting';

  @override
  String get profile => 'profile';

  @override
  String profileEmail(String email) {
    return 'Email: $email';
  }

  @override
  String profileNickname(String nickname) {
    return 'Nickname: $nickname';
  }
}
