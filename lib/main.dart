import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'core/widgets/offline_banner.dart';
import 'core/route.dart';
import 'core/app_theme.dart';
import 'core/logger.dart';
import 'features/settings/providers/theme_provider.dart';
import 'features/auth/services/auth_service.dart';
import 'features/notifications/providers/notifications_provider.dart';
import 'features/profile/providers/profile_provider.dart';

// 백그라운드 메시지 핸들러
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('background firebase initialize error: $e');
  }
  // 백그라운드에서 메시지 수신 시 처리
}

void main() async {
  runZonedGuarded(
    () async {
      final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

      // Flutter 에러 전역 캐치
      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);
        logger.e(
          'Flutter Error',
          error: details.exception,
          stackTrace: details.stack,
        );
        FirebaseCrashlytics.instance.recordFlutterFatalError(details);
      };

      // 릴리즈 모드에서 에러 캐치
      PlatformDispatcher.instance.onError = (error, stack) {
        logger.e('PlatformDispatcher Error', error: error, stackTrace: stack);
        return true;
      };

      await dotenv.load(fileName: '.env');

      try {
        await Firebase.initializeApp();
        FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler,
        );
      } catch (e) {
        logger.w('Firebase 초기화 실패: $e');
      }

      await Supabase.initialize(
        url: dotenv.env['SUPABASE_URL']!,
        anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
      );

      FlutterNativeSplash.remove();
      runApp(const ProviderScope(child: MyApp()));
    },
    (error, stack) {
      // 비동기 에러 전역 캐치
      logger.e('ZonedGuarded Error', error: error, stackTrace: stack);
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    },
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _authService.listenAuthState(
      onSignedOut: () {
        // 세션 만료 시 상태 초기화 + 로그인 화면으로
        ref.read(profileProvider.notifier).clear();
        ref.read(notificationsProvider.notifier).clear();
        router.go('/login');
      },
    );
  }

  @override
  void dispose() {
    _authService.disposeAuthListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      builder: (context, child) {
        return OfflineBanner(child: child!);
      },
    );
  }
}
