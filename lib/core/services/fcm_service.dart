import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/logger.dart';

// router에 접근하기 위한 navigatorKey
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class FcmService {
  final _messaging = FirebaseMessaging.instance;
  final _client = Supabase.instance.client;

  // 포그라운드 메시지 처리
  void _handleForegroundMessage(RemoteMessage message) async {
    logger.i('포그라운드 메시지: ${message.notification?.title}');

    // 알림 목록 갱신은 알림 스크린 진입 시 처리하므로 여기선 생략
  }

  // ① 앱이 백그라운드에서 알림 탭해서 열릴 때
  void _handleMessageOpenedApp(RemoteMessage message) {
    logger.i('알림 탭: ${message.data}');
    _navigateFromMessage(message);
  }

  // ② 앱이 완전히 종료된 상태에서 알림 탭해서 열릴 때
  Future<void> _checkInitialMessage() async {
    final message = await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      logger.i('앱 시작 메시지: ${message.data}');
      // 앱 초기화 완료 후 이동해야 해서 딜레이 줘요
      await Future.delayed(const Duration(seconds: 1));
      _navigateFromMessage(message);
    }
  }

  // ③ 메시지 데이터로 화면 이동
  void _navigateFromMessage(RemoteMessage message) {
    final route = message.data['route'] as String? ?? '/notifications';
    final context = navigatorKey.currentContext;
    if (context != null) {
      GoRouter.of(context).push(route); // push 사용 가능
    }
  }

  // ① 권한 요청 + 토큰 저장
  Future<void> initialize() async {
    // 권한 요청
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) return;

    // FCM 토큰 가져오기
    final token = await _messaging.getToken();
    if (token != null) await _saveToken(token);

    // 토큰 갱신 시 자동 업데이트
    _messaging.onTokenRefresh.listen(_saveToken);

    // 포그라운드 메시지 처리
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // 앱이 백그라운드에서 열릴 때
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    await _checkInitialMessage();
  }

  // ② device_tokens 테이블에 저장
  Future<void> _saveToken(String token) async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    // 기기 정보 가져오기
    final deviceInfo = DeviceInfoPlugin();
    String platform = 'android';
    String deviceName = 'Unknown';

    try {
      final androidInfo = await deviceInfo.androidInfo;
      deviceName = androidInfo.model;
    } catch (_) {
      platform = 'ios';
      final iosInfo = await deviceInfo.iosInfo;
      deviceName = iosInfo.name;
    }

    // upsert로 토큰 저장 (있으면 업데이트, 없으면 insert)
    await _client.from('device_tokens').upsert({
      'user_id': user.id,
      'token': token,
      'platform': platform,
      'device_name': deviceName,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
      'last_used_at': DateTime.now().toUtc().toIso8601String(),
    }, onConflict: 'user_id, token');
  }

  // ⑤ 로그아웃 시 토큰 삭제
  Future<void> deleteToken() async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    final token = await _messaging.getToken();
    if (token == null) return;

    await _client
        .from('device_tokens')
        .delete()
        .eq('user_id', user.id)
        .eq('token', token);

    await _messaging.deleteToken();
  }
}
