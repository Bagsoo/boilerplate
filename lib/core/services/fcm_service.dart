import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/logger.dart';
import 'notification_permission_service.dart';

// router에 접근하기 위한 navigatorKey
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class FcmService {
  final _messaging = FirebaseMessaging.instance;
  final _client = Supabase.instance.client;
  static bool _listenersRegistered = false;

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

  // 권한이 이미 허용된 경우에만 토큰 저장 + 리스너 등록 (팝업을 띄우지 않음)
  Future<void> initialize() async {
    final state = await NotificationPermissionService().getState();
    if (state != NotificationPermissionState.granted) return;
    await _setup();
  }

  // 사전 설명 후 허용을 눌렀을 때 호출: 시스템 팝업 → 허용 시 초기화
  Future<bool> requestPermissionAndInitialize() async {
    final granted = await NotificationPermissionService().request();
    if (!granted) return false;
    await _setup();
    return true;
  }

  Future<void> _setup() async {
    // iOS 포그라운드 표시 등을 위해 firebase 쪽 권한 상태도 동기화
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    final token = await _messaging.getToken();
    if (token != null) await _saveToken(token);

    if (_listenersRegistered) return; // 중복 등록 방지
    _listenersRegistered = true;

    _messaging.onTokenRefresh.listen(_saveToken);
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
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

    // RPC로 토큰 등록 (다른 계정에 남은 같은 토큰은 서버에서 정리)
    try {
      await _client.rpc(
        'register_device_token',
        params: {
          'p_token': token,
          'p_platform': platform,
          'p_device_name': deviceName,
        },
      );
    } catch (e) {
      logger.w('토큰 등록 실패: $e');
    }
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
