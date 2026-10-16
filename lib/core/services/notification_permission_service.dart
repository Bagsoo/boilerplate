import 'permission_service.dart';

// 기존 코드/테스트 호환용 별칭
typedef NotificationPermissionState = AppPermissionState;

class NotificationPermissionService {
  NotificationPermissionService({
    Future<NotificationPermissionState> Function()? stateReader,
    DateTime Function()? now,
  }) : _service = PermissionService(
         stateReader: stateReader == null ? null : (_) => stateReader(),
         now: now,
       );

  final PermissionService _service;
  static const _p = AppPermission.notification;

  Future<NotificationPermissionState> getState() => _service.getState(_p);
  Future<bool> request() => _service.request(_p);
  Future<void> openSettings() => _service.openSettings();
  Future<bool> shouldShowPrompt() => _service.shouldShowPrompt(_p);
  Future<void> recordAsked() => _service.recordAsked(_p);
  Future<void> reset() => _service.reset(_p);
}
