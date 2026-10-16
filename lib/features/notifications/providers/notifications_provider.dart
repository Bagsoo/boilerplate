import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/notifications_repository.dart';
import '../../../core/pagination/paged_notifier.dart';
import '../../../core/pagination/paged_state.dart';

class NotificationsNotifier extends PagedNotifier<Map<String, dynamic>> {
  late final _repository = ref.read(notificationsRepositoryProvider);

  @override
  Future<List<Map<String, dynamic>>> fetchPage({
    required int offset,
    required int limit,
    Map<String, dynamic>? last,
  }) {
    // created_at 커서: 새 알림이 쌓여도 중복/누락 없음
    return _repository.getNotifications(
      limit: limit,
      before: last?['created_at'] as String?,
    );
  }

  // 기존 호출부 호환
  Future<void> loadNotifications() => refresh();

  Future<void> markAsRead(String notificationId) async {
    await _repository.markAsRead(notificationId);
    updateItems(
      (items) => items
          .map((n) => n['id'] == notificationId ? {...n, 'is_read': true} : n)
          .toList(),
    );
  }

  Future<void> markAllAsRead() async {
    await _repository.markAllAsRead();
    updateItems((items) => items.map((n) => {...n, 'is_read': true}).toList());
  }
}

final notificationsProvider =
    NotifierProvider<NotificationsNotifier, PagedState<Map<String, dynamic>>>(
      NotificationsNotifier.new,
    );

final unreadCountProvider = Provider<int>((ref) {
  final items = ref.watch(notificationsProvider).items;
  return items.where((n) => n['is_read'] == false).length;
});
