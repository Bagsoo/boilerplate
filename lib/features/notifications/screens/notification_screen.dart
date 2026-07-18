import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/notifications_provider.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(notificationsProvider.notifier).loadNotifications(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notifications = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('알림'),
        actions: [
          // 전체 읽음 버튼
          TextButton(
            onPressed: () =>
                ref.read(notificationsProvider.notifier).markAllAsRead(),
            child: const Text('전체 읽음'),
          ),
        ],
      ),
      body: notifications.isEmpty
          ? const Center(child: Text('알림이 없어요'))
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                final isRead = notification['is_read'] as bool;

                return ListTile(
                  // ① 읽지 않은 알림은 배경색 강조
                  tileColor: isRead
                      ? null
                      : Theme.of(context).colorScheme.primary.withOpacity(0.05),
                  leading: CircleAvatar(
                    backgroundColor: isRead
                        ? Colors.grey[300]
                        : Theme.of(context).colorScheme.primary,
                    child: Icon(
                      _getIcon(notification['type'] as String),
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    notification['title'] as String,
                    style: TextStyle(
                      fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notification['body'] as String),
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(notification['created_at'] as String),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    if (!isRead) {
                      ref
                          .read(notificationsProvider.notifier)
                          .markAsRead(notification['id'] as String);
                    }

                    final data = notification['data'] as Map<String, dynamic>?;
                    final route = data?['route'] as String?;

                    if (route != null && context.mounted) {
                      context.push(route);
                    }
                  },
                );
              },
            ),
    );
  }

  // ② 알림 타입별 아이콘
  IconData _getIcon(String type) {
    switch (type) {
      case 'chat':
        return Icons.chat;
      case 'follow':
        return Icons.person_add;
      case 'like':
        return Icons.favorite;
      default:
        return Icons.notifications;
    }
  }

  // ③ 날짜 포맷
  String _formatDate(String dateStr) {
    final date = DateTime.parse(dateStr).toLocal();
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return '방금 전';
    if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
    if (diff.inHours < 24) return '${diff.inHours}시간 전';
    return '${diff.inDays}일 전';
  }
}
