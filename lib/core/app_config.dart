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
}
