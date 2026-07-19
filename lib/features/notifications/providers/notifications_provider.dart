import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationsNotifier extends Notifier<List<Map<String, dynamic>>> {
  final _client = Supabase.instance.client;

  static const _pageSize = 10; // ① 한 번에 로드할 개수
  bool _hasMore = true; // ② 더 불러올 데이터 있는지
  bool _isLoadingMore = false; // ③ 추가 로딩 중인지

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  @override
  List<Map<String, dynamic>> build() => []; // 초기값

  Future<void> loadNotifications() async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    _hasMore = true;

    final data = await _client
        .from('notifications')
        .select()
        .eq('receiver_id', user.id)
        .order('created_at', ascending: false)
        .limit(_pageSize);

    state = List<Map<String, dynamic>>.from(data);
    _hasMore = data.length == _pageSize; // 10개 미만이면 더 없음
  }

  // 추가 로드 (무한 스크롤)
  Future<void> loadMore() async {
    if (!_hasMore || _isLoadingMore) return; // 중복 호출 방지

    final user = _client.auth.currentUser;
    if (user == null) return;

    _isLoadingMore = true;

    final data = await _client
        .from('notifications')
        .select()
        .eq('receiver_id', user.id)
        .order('created_at', ascending: false)
        .range(state.length, state.length + _pageSize - 1); // 이어서 로드

    _isLoadingMore = false;
    _hasMore = data.length == _pageSize;
    state = [...state, ...List<Map<String, dynamic>>.from(data)]; // 기존에 추가
  }

  int get unreadCount => state.where((n) => n['is_read'] == false).length;

  Future<void> markAsRead(String notificationId) async {
    await _client
        .from('notifications')
        .update({'is_read': true})
        .eq('id', notificationId);

    state = state.map((n) {
      if (n['id'] == notificationId) {
        return {...n, 'is_read': true};
      }
      return n;
    }).toList();
  }

  Future<void> markAllAsRead() async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    await _client
        .from('notifications')
        .update({'is_read': true})
        .eq('receiver_id', user.id)
        .eq('is_read', false);

    state = state.map((n) => {...n, 'is_read': true}).toList();
  }

  void clear() => state = [];
}

final notificationsProvider =
    NotifierProvider<NotificationsNotifier, List<Map<String, dynamic>>>(() {
      return NotificationsNotifier();
    });

final unreadCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationsProvider);
  return notifications.where((n) => n['is_read'] == false).length;
});
