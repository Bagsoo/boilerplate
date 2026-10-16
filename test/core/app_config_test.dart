import 'package:flutter_pt/core/app_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() => AppConfig.flavor = Flavor.prod);

  test('prod는 환경 표시 없이 버전과 빌드 번호만', () {
    AppConfig.flavor = Flavor.prod;
    expect(AppConfig.formatVersion('1.0.0', '3'), '1.0.0 (3)');
  });

  test('dev는 환경 표시를 덧붙임', () {
    AppConfig.flavor = Flavor.dev;
    expect(AppConfig.formatVersion('1.0.0', '3'), '1.0.0 (3) · dev');
  });

  test('빌드 번호가 없으면 버전만', () {
    AppConfig.flavor = Flavor.prod;
    expect(AppConfig.formatVersion('1.0.0', ''), '1.0.0');
  });
}
