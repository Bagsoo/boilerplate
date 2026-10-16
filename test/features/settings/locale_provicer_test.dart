import 'dart:ui';

import 'package:flutter_pt/features/settings/providers/locale_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

// LocaleNotifier는 생성 시 비동기로 저장값을 읽으므로 잠깐 기다림
Future<void> settle() => Future<void>.delayed(const Duration(milliseconds: 20));

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('저장된 값이 없으면 null (시스템 언어)', () async {
    SharedPreferences.setMockInitialValues({});
    final container = ProviderContainer();
    addTearDown(container.dispose);

    container.read(localeProvider);
    await settle();
    expect(container.read(localeProvider), isNull);
  });

  test('저장된 언어를 복원', () async {
    SharedPreferences.setMockInitialValues({'app_locale': 'en'});
    final container = ProviderContainer();
    addTearDown(container.dispose);

    container.read(localeProvider);
    await settle();
    expect(container.read(localeProvider), const Locale('en'));
  });

  test('setLocale은 상태와 저장소를 함께 갱신, null이면 삭제', () async {
    SharedPreferences.setMockInitialValues({});
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(localeProvider.notifier);

    await notifier.setLocale(const Locale('ko'));
    final prefs = await SharedPreferences.getInstance();
    expect(container.read(localeProvider), const Locale('ko'));
    expect(prefs.getString('app_locale'), 'ko');

    await notifier.setLocale(null);
    expect(container.read(localeProvider), isNull);
    expect(prefs.getString('app_locale'), isNull);
  });
}
