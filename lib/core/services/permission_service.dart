import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppPermission { notification, camera, photos, location }

enum AppPermissionState {
  granted, // 허용됨
  notDetermined, // 아직 안 물어봄 (또는 거부 후 재요청 가능)
  permanentlyDenied, // 시스템 설정에서만 변경 가능
}

class PermissionService {
  PermissionService({
    this.stateReader,
    DateTime Function()? now,
    this.retryInterval = const Duration(days: 7),
    this.maxAskCount = 3,
  }) : _now = now ?? DateTime.now;

  /// 테스트용: 시스템 권한 조회를 대체
  final Future<AppPermissionState> Function(AppPermission)? stateReader;
  final DateTime Function() _now;
  final Duration retryInterval;
  final int maxAskCount;

  Permission _map(AppPermission p) {
    switch (p) {
      case AppPermission.notification:
        return Permission.notification;
      case AppPermission.camera:
        return Permission.camera;
      case AppPermission.photos:
        return Permission.photos;
      case AppPermission.location:
        return Permission.locationWhenInUse;
    }
  }

  // 알림은 기존 키(notif_...)를 그대로 유지
  String _prefix(AppPermission p) =>
      p == AppPermission.notification ? 'notif' : 'perm_${p.name}';

  Future<AppPermissionState> getState(AppPermission p) async {
    final reader = stateReader;
    if (reader != null) return reader(p);

    final s = await _map(p).status;
    if (s.isGranted || s.isProvisional || s.isLimited) {
      return AppPermissionState.granted;
    }
    if (s.isPermanentlyDenied || s.isRestricted) {
      return AppPermissionState.permanentlyDenied;
    }
    return AppPermissionState.notDetermined;
  }

  Future<bool> request(AppPermission p) async {
    final s = await _map(p).request();
    return s.isGranted || s.isProvisional || s.isLimited;
  }

  Future<void> openSettings() => openAppSettings();

  // ---- 선제 요청용 재요청 정책 (알림처럼 앱이 먼저 묻는 권한) ----

  Future<bool> shouldShowPrompt(AppPermission p) async {
    if (await getState(p) == AppPermissionState.granted) return false;

    final prefs = await SharedPreferences.getInstance();
    final count = prefs.getInt('${_prefix(p)}_ask_count') ?? 0;
    if (count >= maxAskCount) return false;

    final lastMs = prefs.getInt('${_prefix(p)}_last_asked_at');
    if (lastMs == null) return true;

    final last = DateTime.fromMillisecondsSinceEpoch(lastMs);
    return _now().difference(last) >= retryInterval;
  }

  Future<void> recordAsked(AppPermission p) async {
    final prefs = await SharedPreferences.getInstance();
    final count = prefs.getInt('${_prefix(p)}_ask_count') ?? 0;
    await prefs.setInt('${_prefix(p)}_ask_count', count + 1);
    await prefs.setInt(
      '${_prefix(p)}_last_asked_at',
      _now().millisecondsSinceEpoch,
    );
  }

  Future<void> reset(AppPermission p) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('${_prefix(p)}_last_asked_at');
    await prefs.remove('${_prefix(p)}_ask_count');
  }
}
