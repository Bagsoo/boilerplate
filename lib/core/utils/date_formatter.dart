import 'package:intl/intl.dart';
import '../../l10n/app_localizations.dart';

class DateFormatter {
  static String timeAgo(AppLocalizations l10n, String dateStr) {
    final date = DateTime.parse(dateStr).toLocal();
    final diff = DateTime.now().difference(date);

    if (diff.inSeconds < 60) return l10n.timeJustNow;
    if (diff.inMinutes < 60) return l10n.timeMinutesAgo(diff.inMinutes);
    if (diff.inHours < 24) return l10n.timeHoursAgo(diff.inHours);
    if (diff.inDays < 7) return l10n.timeDaysAgo(diff.inDays);
    if (diff.inDays < 30) return l10n.timeWeeksAgo((diff.inDays / 7).floor());
    if (diff.inDays < 365) {
      return l10n.timeMonthsAgo((diff.inDays / 30).floor());
    }
    return l10n.timeYearsAgo((diff.inDays / 365).floor());
  }

  static String toDate(AppLocalizations l10n, String dateStr) {
    final date = DateTime.parse(dateStr).toLocal();
    return DateFormat.yMd(l10n.localeName).format(date);
  }

  static String toDateTime(AppLocalizations l10n, String dateStr) {
    final date = DateTime.parse(dateStr).toLocal();
    return DateFormat.yMd(l10n.localeName).add_Hm().format(date);
  }

  static String toRelativeDate(AppLocalizations l10n, String dateStr) {
    final date = DateTime.parse(dateStr).toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final days = today.difference(target).inDays;

    if (days == 0) return l10n.timeToday;
    if (days == 1) return l10n.timeYesterday;
    return toDate(l10n, dateStr);
  }

  static String timeAgoFromDateTime(AppLocalizations l10n, DateTime date) {
    return timeAgo(l10n, date.toIso8601String());
  }
}
