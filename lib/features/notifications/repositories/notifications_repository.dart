import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationsRepository {
  final _client = Supabase.instance.client;

  // 알림 목록 조회 (페이지네이션)
  Future<List<Map<String, dynamic>>> getNotifications({
    required int limit,
    String? before, // 이 created_at보다 오래된 것만
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) return [];

    var query = _client
        .from('notifications')
        .select()
        .eq('receiver_id', user.id);

    if (before != null) query = query.lt('created_at', before);

    final data = await query.order('created_at', ascending: false).limit(limit);

    return List<Map<String, dynamic>>.from(data);
  }

  // 읽음 처리
  Future<void> markAsRead(String notificationId) async {
    await _client
        .from('notifications')
        .update({'is_read': true})
        .eq('id', notificationId);
  }

  // 전체 읽음 처리
  Future<void> markAllAsRead() async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    await _client
        .from('notifications')
        .update({'is_read': true})
        .eq('receiver_id', user.id)
        .eq('is_read', false);
  }

  // 알림 전송 (RPC)
  Future<void> sendNotification({
    required String receiverId,
    required String title,
    required String body,
    required String type,
    Map<String, dynamic>? data,
    String? senderId,
  }) async {
    await _client.rpc(
      'send_notification',
      params: {
        'p_receiver_id': receiverId,
        'p_title': title,
        'p_body': body,
        'p_type': type,
        'p_data': data,
        'p_sender_id': senderId,
      },
    );
  }
}

// Provider 등록
final notificationsRepositoryProvider = Provider<NotificationsRepository>((
  ref,
) {
  return NotificationsRepository();
});
