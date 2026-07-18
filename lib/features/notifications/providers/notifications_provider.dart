import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationsNotifier extends Notifier<List<Map<String, dynamic>>> {
  final _client = Supabase.instance.client;

  @override
  List<Map<String, dynamic>> build() => []; // 초기값

  Future<void> loadNotifications() async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    final data = await _client
        .from('notifications')
        .select()
        .eq('receiver_id', user.id)
        .order('created_at', ascending: false);

    state = List<Map<String, dynamic>>.from(data);
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
