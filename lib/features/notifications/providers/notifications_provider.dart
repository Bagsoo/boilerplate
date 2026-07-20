import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/notifications_repository.dart';

class NotificationsNotifier extends Notifier<List<Map<String, dynamic>>> {
  static const _pageSize = 10;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  @override
  List<Map<String, dynamic>> build() => [];

  late final _repository = ref.read(notificationsRepositoryProvider);

  Future<void> loadNotifications() async {
    _hasMore = true;

    final data = await _repository.getNotifications(from: 0, to: _pageSize - 1);

    state = data;
    _hasMore = data.length == _pageSize;
  }

  Future<void> loadMore() async {
    if (!_hasMore || _isLoadingMore) return;

    _isLoadingMore = true;

    final data = await _repository.getNotifications(
      from: state.length,
      to: state.length + _pageSize - 1,
    );

    _isLoadingMore = false;
    _hasMore = data.length == _pageSize;
    state = [...state, ...data];
  }

  Future<void> markAsRead(String notificationId) async {
    await _repository.markAsRead(notificationId);

    state = state.map((n) {
      if (n['id'] == notificationId) {
        return {...n, 'is_read': true};
      }
      return n;
    }).toList();
  }

  Future<void> markAllAsRead() async {
    await _repository.markAllAsRead();
    state = state.map((n) => {...n, 'is_read': true}).toList();
  }

  void clear() => state = [];
}

final notificationsProvider =
    NotifierProvider<
      // ← < 추가
      NotificationsNotifier,
      List<Map<String, dynamic>>
    >(() {
      return NotificationsNotifier();
    });

final unreadCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationsProvider);
  return notifications.where((n) => n['is_read'] == false).length;
});
