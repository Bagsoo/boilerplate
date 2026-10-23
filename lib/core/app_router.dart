import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/services/fcm_service.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/signup_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/settings/screens/settings_screen.dart';
import '../features/auth/screens/terms_screen.dart';
import '../features/notifications/screens/notification_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/search/screens/search_screen.dart';
import '../features/auth/screens/forgot_password_screen.dart';
import '../features/auth/screens/reset_password_screen.dart';
import 'scaffold_with_nav.dart';

final router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/home',
  debugLogDiagnostics: true, // 딥링크 디버깅용

  redirect: (context, state) async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

    final location = state.matchedLocation;

    final session = Supabase.instance.client.auth.currentSession;
    final isLoggedIn = session != null;

    // 1. 비밀번호 재설정 딥링크는 항상 허용
    if (location == '/reset-password') {
      return null;
    }

    // 2. 온보딩을 아직 완료하지 않은 경우
    if (!hasSeenOnboarding) {
      if (location == '/onboarding') {
        return null;
      }
      return '/onboarding';
    }

    // 3. 온보딩 완료 후 다시 진입한 경우
    if (location == '/onboarding') {
      return isLoggedIn ? '/home' : '/login';
    }

    // 4. 로그인 없이 접근 가능한 인증 화면
    final isAuthRoute =
        location == '/login' ||
        location == '/signup' ||
        location == '/terms' ||
        location == '/forgot-password';

    // 5. 로그인하지 않은 사용자
    if (!isLoggedIn) {
      if (isAuthRoute) return null;
      return '/login';
    }

    // 6. 로그인한 사용자는 로그인/가입 화면에 접근 불필요
    if (location == '/login' ||
        location == '/signup' ||
        location == '/forgot-password') {
      return '/home';
    }

    // 7. 정상적인 화면 이동 허용
    return null;
  },
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/reset-password',
      builder: (context, state) => const ResetPasswordScreen(),
    ),
    GoRoute(
      path: '/terms',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return TermsScreen(extra: extra);
      },
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(path: '/search', builder: (context, state) => const SearchScreen()),

    StatefulShellRoute.indexedStack(
      // ① 탭 묶음 라우트
      builder: (context, state, navigationShell) {
        return ScaffoldWithNav(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          // ② 탭1 - 홈
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          // ③ 탭2 - 프로필
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
