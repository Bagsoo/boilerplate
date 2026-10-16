import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Flavor { dev, prod }

class AppConfig {
  static Flavor flavor = Flavor.prod; // 기본값

  static bool get isDev => flavor == Flavor.dev;
  static bool get isProd => flavor == Flavor.prod;

  // .env 파일명
  static String get envFile => isDev ? '.env.dev' : '.env.prod';

  // 앱 이름
  static String get appName => isDev ? '[DEV] Flutter PT' : 'Flutter PT';

  // Crashlytics 활성화 여부
  static bool get enableCrashlytics => isProd;

  // 로그 활성화 여부
  static bool get enableLogging => isDev;

  // 딥링크 스킴 (.env의 SUPABASE_CALLBACK_SCHEME)
  static String get urlScheme =>
      dotenv.env['SUPABASE_CALLBACK_SCHEME'] ?? 'flutterpt';

  // 딥링크 호스트 (AndroidManifest의 android:host와 동일해야 함)
  static const urlHost = 'app';

  // 비밀번호 재설정 링크
  static String get passwordResetRedirect =>
      '$urlScheme://$urlHost/reset-password';

  static String get envLabel => isDev ? 'dev' : 'prod';

  /// 설정 화면 등에 표시: "1.0.0 (3) · dev"
  static String formatVersion(String version, String build) {
    final base = build.isEmpty ? version : '$version ($build)';
    return isProd ? base : '$base · $envLabel';
  }
}
