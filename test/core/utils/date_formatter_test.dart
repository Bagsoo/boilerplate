import 'package:flutter_pt/core/utils/date_formatter.dart';
import 'package:flutter_pt/l10n/app_localizations_en.dart';
import 'package:flutter_pt/l10n/app_localizations_ko.dart';
import 'package:flutter_test/flutter_test.dart';

String ago(Duration d) => DateTime.now().subtract(d).toUtc().toIso8601String();

void main() {
  final en = AppLocalizationsEn();
  final ko = AppLocalizationsKo();

  group('DateFormatter.timeAgo (en)', () {
    test('1분 미만은 Just now', () {
      expect(
        DateFormatter.timeAgo(en, ago(const Duration(seconds: 30))),
        'Just now',
      );
    });

    test('단수/복수 구분', () {
      expect(
        DateFormatter.timeAgo(en, ago(const Duration(minutes: 1, seconds: 5))),
        '1 minute ago',
      );
      expect(
        DateFormatter.timeAgo(en, ago(const Duration(minutes: 3, seconds: 5))),
        '3 minutes ago',
      );
    });

    test('경계값: 60분 → 1시간, 24시간 → 1일', () {
      expect(
        DateFormatter.timeAgo(en, ago(const Duration(minutes: 60, seconds: 5))),
        '1 hour ago',
      );
      expect(
        DateFormatter.timeAgo(en, ago(const Duration(hours: 24, seconds: 5))),
        '1 day ago',
      );
    });

    test('주/개월/년 단위', () {
      expect(
        DateFormatter.timeAgo(en, ago(const Duration(days: 7, minutes: 1))),
        '1 week ago',
      );
      expect(
        DateFormatter.timeAgo(en, ago(const Duration(days: 30, minutes: 1))),
        '1 month ago',
      );
      expect(
        DateFormatter.timeAgo(en, ago(const Duration(days: 365, minutes: 1))),
        '1 year ago',
      );
    });
  });

  test('DateFormatter.timeAgo (ko)', () {
    expect(
      DateFormatter.timeAgo(ko, ago(const Duration(minutes: 3, seconds: 5))),
      '3분 전',
    );
  });

  group('DateFormatter.toRelativeDate', () {
    test('오늘 / 어제', () {
      expect(
        DateFormatter.toRelativeDate(en, ago(const Duration(seconds: 1))),
        'Today',
      );
      expect(
        DateFormatter.toRelativeDate(en, ago(const Duration(days: 1))),
        'Yesterday',
      );
    });
  });
}
