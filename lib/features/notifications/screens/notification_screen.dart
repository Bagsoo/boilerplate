import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/pagination/paged_list_view.dart';
import '../providers/notifications_provider.dart';
import '../../../l10n/l10n_extension.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/skeleton_loader.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(notificationsProvider.notifier).refresh());
  }

  @override
  void dispose() {
    _scrollController.dispose(); // ③ 메모리 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationsProvider);
    final notifier = ref.read(notificationsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.notificationsTitle),
        actions: [
          TextButton(
            onPressed: notifier.markAllAsRead,
            child: Text(context.l10n.notificationsMarkAllRead),
          ),
        ],
      ),
      body: PagedListView<Map<String, dynamic>>(
        state: state,
        onRefresh: notifier.refresh,
        onLoadMore: notifier.loadMore,
        loadingView: const SkeletonNotificationList(),
        allLoadedText: context.l10n.notificationsAllLoaded,
        emptyView: EmptyView(
          title: context.l10n.notificationsEmptyTitle,
          description: context.l10n.notificationsEmptyDescription,
          icon: Icons.notifications_none_rounded,
        ),
        itemBuilder: (context, notification, index) =>
            _buildItem(context, notification),
      ),
    );
  }

  Widget _buildItem(BuildContext context, Map<String, dynamic> notification) {
    final isRead = notification['is_read'] as bool;
    final theme = Theme.of(context);

    return ListTile(
      // 읽지 않은 알림은 배경색 강조
      tileColor: isRead
          ? null
          : theme.colorScheme.primary.withValues(alpha: 0.05),
      leading: CircleAvatar(
        backgroundColor: isRead ? Colors.grey[300] : theme.colorScheme.primary,
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
            DateFormatter.timeAgo(
              context.l10n,
              notification['created_at'] as String,
            ),
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      onTap: () {
        if (!isRead) {
          ref
              .read(notificationsProvider.notifier)
              .markAsRead(notification['id'] as String);
        }

        final type = notification['type'] as String;
        final data = notification['data'] as Map<String, dynamic>?;
        final route = data?['route'] as String?;

        if (type == 'system' || route == null) return;
        if (route == '/notifications') return;

        if (context.mounted) {
          context.push(route);
        }
      },
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
}
