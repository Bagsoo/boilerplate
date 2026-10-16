import 'package:flutter_pt/core/services/permission_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final now = DateTime(2026, 1, 15, 12);

  PermissionService build([
    AppPermissionState state = AppPermissionState.notDetermined,
  ]) => PermissionService(stateReader: (_) async => state, now: () => now);

  test('권한별로 재요청 기록이 분리됨', () async {
    SharedPreferences.setMockInitialValues({});
    final s = build();
    await s.recordAsked(AppPermission.camera);

    expect(await s.shouldShowPrompt(AppPermission.camera), isFalse); // 7일 이내
    expect(await s.shouldShowPrompt(AppPermission.location), isTrue); // 별개
  });

  test('알림은 기존 키(notif_...)를 사용', () async {
    SharedPreferences.setMockInitialValues({});
    await build().recordAsked(AppPermission.notification);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getInt('notif_ask_count'), 1);
    expect(prefs.getInt('notif_last_asked_at'), now.millisecondsSinceEpoch);
  });

  test('허용된 권한은 프롬프트 불필요', () async {
    SharedPreferences.setMockInitialValues({});
    final s = build(AppPermissionState.granted);
    expect(await s.shouldShowPrompt(AppPermission.camera), isFalse);
  });

  test('최대 횟수 초과 시 표시 안 함', () async {
    SharedPreferences.setMockInitialValues({
      'perm_camera_ask_count': 3,
      'perm_camera_last_asked_at': now
          .subtract(const Duration(days: 30))
          .millisecondsSinceEpoch,
    });
    expect(await build().shouldShowPrompt(AppPermission.camera), isFalse);
  });

  test('reset은 해당 권한만 지움', () async {
    SharedPreferences.setMockInitialValues({});
    final s = build();
    await s.recordAsked(AppPermission.camera);
    await s.recordAsked(AppPermission.location);
    await s.reset(AppPermission.camera);

    expect(await s.shouldShowPrompt(AppPermission.camera), isTrue);
    expect(await s.shouldShowPrompt(AppPermission.location), isFalse);
  });
}
