class DateFormatter {
  // ① "방금 전", "3분 전" 등 상대적 시간
  static String timeAgo(String dateStr) {
    final date = DateTime.parse(dateStr).toLocal();
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) return '방금 전';
    if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
    if (diff.inHours < 24) return '${diff.inHours}시간 전';
    if (diff.inDays < 7) return '${diff.inDays}일 전';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}주 전';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}개월 전';
    return '${(diff.inDays / 365).floor()}년 전';
  }

  // ② "2024.01.15" 형식
  static String toDate(String dateStr) {
    final date = DateTime.parse(dateStr).toLocal();
    return '${date.year}.${_pad(date.month)}.${_pad(date.day)}';
  }

  // ③ "2024.01.15 14:30" 형식
  static String toDateTime(String dateStr) {
    final date = DateTime.parse(dateStr).toLocal();
    return '${toDate(dateStr)} ${_pad(date.hour)}:${_pad(date.minute)}';
  }

  // ④ "오늘", "어제", 날짜 형식
  static String toRelativeDate(String dateStr) {
    final date = DateTime.parse(dateStr).toLocal();
    final now = DateTime.now();

    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;

    final yesterday = now.subtract(const Duration(days: 1));
    final isYesterday =
        date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;

    if (isToday) return '오늘';
    if (isYesterday) return '어제';
    return toDate(dateStr);
  }

  // ⑤ DateTime 객체로도 받을 수 있게
  static String timeAgoFromDateTime(DateTime date) {
    return timeAgo(date.toIso8601String());
  }

  static String _pad(int value) => value.toString().padLeft(2, '0');
}
