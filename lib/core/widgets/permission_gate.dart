import 'package:flutter/material.dart';
import '../../l10n/l10n_extension.dart';
import '../services/permission_service.dart';
import 'app_bottom_sheet.dart';
import 'app_button.dart';
import 'confirm_dialog.dart';

class PermissionGate {
  /// 기능 실행 직전에 호출. 허용되어 있거나 허용받으면 true.
  /// 사전 설명 → 시스템 요청 → (영구 거부면) 설정 안내
  static Future<bool> ensure(
    BuildContext context,
    AppPermission permission, {
    PermissionService? service, // 테스트용
  }) async {
    final svc = service ?? PermissionService();
    final state = await svc.getState(permission);
    if (state == AppPermissionState.granted) return true;
    if (!context.mounted) return false;

    if (state == AppPermissionState.permanentlyDenied) {
      final goSettings = await ConfirmDialog.show(
        context,
        title: context.l10n.permDeniedTitle,
        content: context.l10n.permDeniedContent,
        confirmLabel: context.l10n.permOpenSettings,
      );
      if (goSettings) await svc.openSettings();
      return false;
    }

    final agreed = await AppBottomSheet.show<bool>(
      context,
      isDismissible: false,
      child: _RationaleContent(permission: permission),
    );
    if (agreed != true) return false;
    return svc.request(permission);
  }
}

class _RationaleContent extends StatelessWidget {
  const _RationaleContent({required this.permission});
  final AppPermission permission;

  IconData get _icon {
    switch (permission) {
      case AppPermission.camera:
        return Icons.photo_camera_outlined;
      case AppPermission.photos:
        return Icons.photo_library_outlined;
      case AppPermission.location:
        return Icons.location_on_outlined;
      case AppPermission.notification:
        return Icons.notifications_active_outlined;
    }
  }

  String _title(BuildContext c) {
    switch (permission) {
      case AppPermission.camera:
        return c.l10n.permCameraTitle;
      case AppPermission.photos:
        return c.l10n.permPhotosTitle;
      case AppPermission.location:
        return c.l10n.permLocationTitle;
      case AppPermission.notification:
        return c.l10n.notifPermissionTitle;
    }
  }

  String _description(BuildContext c) {
    switch (permission) {
      case AppPermission.camera:
        return c.l10n.permCameraDescription;
      case AppPermission.photos:
        return c.l10n.permPhotosDescription;
      case AppPermission.location:
        return c.l10n.permLocationDescription;
      case AppPermission.notification:
        return c.l10n.notifPermissionDescription;
    }
  }

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
          Icon(_icon, size: 48, color: theme.colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            _title(context),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _description(context),
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          AppButton(
            label: context.l10n.permAllow,
            onPressed: () => Navigator.pop(context, true),
          ),
          const SizedBox(height: 8),
          AppButton(
            label: context.l10n.permLater,
            type: AppButtonType.ghost,
            onPressed: () => Navigator.pop(context, false),
          ),
        ],
      ),
    );
  }
}
