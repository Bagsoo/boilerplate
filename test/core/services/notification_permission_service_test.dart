import 'package:flutter_pt/core/services/notification_permission_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final now = DateTime(2026, 1, 15, 12);

  NotificationPermissionService build({
    NotificationPermissionState state =
        NotificationPermissionState.notDetermined,
  }) {
    return NotificationPermissionService(
      stateReader: () async => state,
      now: () => now,
    );
  }

  // 키 이름은 서비스의 private 상수와 같아야 함
  void seed({int? count, DateTime? lastAsked}) {
    SharedPreferences.setMockInitialValues({
      'notif_ask_count': ?count,
      'notif_last_asked_at': ?lastAsked?.millisecondsSinceEpoch,
    });
  }

  group('shouldShowPrompt', () {
    test('이미 허용된 경우 표시 안 함', () async {
      seed();
      final s = build(state: NotificationPermissionState.granted);
      expect(await s.shouldShowPrompt(), isFalse);
    });

    test('한 번도 안 물어봤으면 표시', () async {
      seed();
      expect(await build().shouldShowPrompt(), isTrue);
    });

    test('"나중에" 후 7일 안에는 표시 안 함', () async {
      seed(count: 1, lastAsked: now.subtract(const Duration(days: 6)));
      expect(await build().shouldShowPrompt(), isFalse);
    });

    test('7일이 지나면 다시 표시', () async {
      seed(count: 1, lastAsked: now.subtract(const Duration(days: 7)));
      expect(await build().shouldShowPrompt(), isTrue);
    });

    test('최대 3회를 넘으면 시간이 지나도 표시 안 함', () async {
      seed(count: 3, lastAsked: now.subtract(const Duration(days: 30)));
      expect(await build().shouldShowPrompt(), isFalse);
    });
  });

  group('recordAsked / reset', () {
    test('횟수와 시각을 기록', () async {
      seed();
      final s = build();
      await s.recordAsked();
      await s.recordAsked();

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('notif_ask_count'), 2);
      expect(prefs.getInt('notif_last_asked_at'), now.millisecondsSinceEpoch);
    });

    test('reset은 기록을 지움', () async {
      seed(count: 2, lastAsked: now);
      final s = build();
      await s.reset();
      expect(await s.shouldShowPrompt(), isTrue);
    });
  });
}
