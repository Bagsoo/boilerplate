import 'package:flutter/material.dart';
import '../../l10n/l10n_extension.dart';
import '../services/fcm_service.dart';
import '../services/notification_permission_service.dart';
import 'app_bottom_sheet.dart';
import 'app_button.dart';

class NotificationPermissionSheet {
  // 조건이 맞을 때만 사전 설명 바텀시트 표시
  static Future<void> showIfNeeded(BuildContext context) async {
    final service = NotificationPermissionService();
    if (!await service.shouldShowPrompt()) return;
    if (!context.mounted) return;

    final agreed = await AppBottomSheet.show<bool>(
      context,
      isDismissible: false,
      child: _Content(),
    );

    if (agreed == true) {
      await FcmService().requestPermissionAndInitialize();
    } else {
      await service.recordAsked(); // "나중에" 또는 닫기
    }
  }
}

class _Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        MediaQuery.of(context).padding.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.notifications_active_outlined,
            size: 48,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.notifPermissionTitle,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.notifPermissionDescription,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          AppButton(
            label: context.l10n.notifPermissionAllow,
            onPressed: () => Navigator.pop(context, true),
          ),
          const SizedBox(height: 8),
          AppButton(
            label: context.l10n.notifPermissionLater,
            type: AppButtonType.ghost,
            onPressed: () => Navigator.pop(context, false),
          ),
        ],
      ),
    );
  }
}
