import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../l10n/l10n_extension.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../features/profile/providers/profile_provider.dart';
import '../../../features/settings/providers/theme_provider.dart';
import '../../../features/notifications/providers/notifications_provider.dart';
import '../../../core/services/review_service.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/app_snack_bar.dart';
import '../../../core/widgets/avatar_image.dart';
import '../../../core/errors/app_error.dart';
import '../../../core/errors/app_error_l10n.dart';
import '../../../core/services/fcm_service.dart';
import '../../../core/services/notification_permission_service.dart';
import '../../../features/profile/models/profile_model.dart';
import '../../../features/settings/providers/locale_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/app_config.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreen();
}

class _SettingsScreen extends ConsumerState<SettingsScreen>
    with WidgetsBindingObserver {
  String _version = '';
  bool _osPushGranted = true; // 조회 전에는 깜빡임 방지를 위해 true

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadVersion();
    _refreshOsPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refreshOsPermission();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() {
      _version = AppConfig.formatVersion(info.version, info.buildNumber);
    });
  }

  Future<void> _refreshOsPermission() async {
    final state = await NotificationPermissionService().getState();
    if (!mounted) return;
    setState(() {
      _osPushGranted = state == NotificationPermissionState.granted;
    });
  }

  Future<void> _run(Future<void> Function() action) async {
    try {
      await action();
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.show(
        context,
        message: mapToAppError(e).message(context),
        type: SnackBarType.error,
      );
    }
  }

  Future<void> _onPushChanged(bool value, ProfileModel? profile) async {
    if (value) {
      final service = NotificationPermissionService();
      final state = await service.getState();

      if (state == NotificationPermissionState.permanentlyDenied) {
        if (!mounted) return;
        final goSettings = await ConfirmDialog.show(
          context,
          title: context.l10n.notifPermissionDeniedTitle,
          content: context.l10n.notifPermissionDeniedContent,
          confirmLabel: context.l10n.notifPermissionOpenSettings,
        );
        if (goSettings == true) await service.openSettings();
        return; // 서버 설정은 바꾸지 않음 (스위치는 그대로 꺼짐)
      }

      if (state == NotificationPermissionState.notDetermined) {
        final granted = await FcmService().requestPermissionAndInitialize();
        await _refreshOsPermission();
        if (!granted) return;
      }
    }

    await _run(
      () => ref
          .read(profileProvider.notifier)
          .updateNotificationSettings(
            pushEnabled: value,
            marketingEnabled: profile?.marketingNotificationEnabled ?? false,
          ),
    );

    await _refreshOsPermission();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final profile = ref.watch(profileProvider);
    final locale = ref.watch(localeProvider);
    final isAuthLoading = ref.watch(authProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.setting)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                final result = await AppBottomSheet.showOptions<String>(
                  context,
                  title: context.l10n.settingsProfileImage,
                  options: [
                    BottomSheetOption(
                      label: context.l10n.settingsPickFromGallery,
                      icon: Icons.photo_library_outlined,
                      value: 'gallery',
                    ),
                    BottomSheetOption(
                      label: context.l10n.settingsDeleteImage,
                      icon: Icons.delete_outline,
                      value: 'delete',
                      isDestructive: true,
                    ),
                  ],
                );
                if (result == 'gallery') {
                  await _run(
                    () => ref.read(profileProvider.notifier).uploadAvatar(),
                  );
                } else if (result == 'delete') {
                  await _run(
                    () => ref.read(profileProvider.notifier).removeAvatar(),
                  );
                }
              },
              child: AvatarImage(radius: 50, imageUrl: profile?.profileImage),
            ),
            const SizedBox(height: 8),
            Text(context.l10n.settingsTapToChangeImage),
            const SizedBox(height: 32),
            SwitchListTile(
              title: Text(context.l10n.darkmode),
              secondary: Icon(
                themeMode == ThemeMode.dark
                    ? Icons.dark_mode
                    : Icons.light_mode_outlined,
              ),
              value: themeMode == ThemeMode.dark,
              onChanged: (value) {
                if (value) {
                  ref.read(themeProvider.notifier).setDark();
                } else {
                  ref.read(themeProvider.notifier).setLight();
                }
              },
            ),
            const Divider(),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(context.l10n.settingsLanguage),
              subtitle: Text(_localeLabel(locale, context.l10n)),
              onTap: () => _showLanguageSheet(context),
            ),
            const Divider(),

            // 일반 알림
            SwitchListTile(
              title: Text(context.l10n.settingsPush),
              subtitle: Text(
                _osPushGranted
                    ? context.l10n.settingsPushDescription
                    : context.l10n.settingsPushOsOff,
              ),
              secondary: const Icon(Icons.notifications_outlined),
              value:
                  (profile?.pushNotificationEnabled ?? true) && _osPushGranted,
              onChanged: (value) => _onPushChanged(value, profile),
            ),

            // 마케팅 알림
            SwitchListTile(
              title: Text(context.l10n.settingsMarketing),
              subtitle: Text(context.l10n.settingsMarketingDescription),
              secondary: const Icon(Icons.campaign_outlined),
              value: profile?.marketingNotificationEnabled ?? false,
              onChanged: (value) => _run(
                () => ref
                    .read(profileProvider.notifier)
                    .updateNotificationSettings(
                      pushEnabled: profile?.pushNotificationEnabled ?? true,
                      marketingEnabled: value,
                    ),
              ),
            ),
            const SizedBox(height: 8),
            const Divider(),
            AppButton(
              label: context.l10n.settingsReview,
              type: AppButtonType.ghost,
              icon: Icons.star_outline_rounded,
              onPressed: () => ReviewService().openStoreListing(),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(context.l10n.logout),
              enabled: !isAuthLoading,
              onTap: _logout,
            ),
            const SizedBox(height: 0),
            ListTile(
              leading: Icon(
                Icons.person_remove_outlined,
                color: Theme.of(
                  context,
                ).colorScheme.error.withValues(alpha: 0.7),
              ),
              title: Text(
                context.l10n.settingsDeleteAccount,
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.error.withValues(alpha: 0.7),
                ),
              ),
              enabled: !isAuthLoading,
              onTap: () => _deleteAccount,
            ),

            const SizedBox(height: 32),
            Text(
              context.l10n.settingsVersion(_version.toString()),
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _logout() async {
    await ref.read(authProvider.notifier).signOut();
    ref.read(profileProvider.notifier).clear();
    ref.read(notificationsProvider.notifier).clear();
    if (!mounted) return;
    context.go('/login');
  }

  Future<void> _deleteAccount() async {
    // ① 확인 다이얼로그
    final confirm = await ConfirmDialog.show(
      context,
      title: context.l10n.settingsDeleteAccount,
      content: context.l10n.settingsDeleteAccountConfirm,
      confirmLabel: context.l10n.settingsDeleteAccountAction,
      isDanger: true,
    );

    if (confirm != true) return; // 취소 누르면 종료
    if (!mounted) return;

    // ② 탈퇴 실행
    final success = await ref.read(authProvider.notifier).deleteAccount();
    if (!mounted) return; // 모든 분기 앞에서 한 번만

    if (success) {
      ref.read(profileProvider.notifier).clear();
      context.go('/login');
    } else {
      final error = ref.read(authProvider).error;
      AppSnackBar.show(
        context,
        message:
            error?.message(context) ?? context.l10n.settingsDeleteAccountFailed,
        type: SnackBarType.error,
      );
    }
  }

  String _localeLabel(Locale? locale, AppLocalizations l10n) {
    switch (locale?.languageCode) {
      case 'ko':
        return '한국어';
      case 'en':
        return 'English';
      default:
        return l10n.languageSystem;
    }
  }

  Future<void> _showLanguageSheet(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await AppBottomSheet.showOptions<String>(
      context,
      title: l10n.settingsLanguage,
      options: [
        BottomSheetOption(
          label: l10n.languageSystem,
          icon: Icons.phone_android,
          value: 'system',
        ),
        const BottomSheetOption(
          label: '한국어',
          icon: Icons.language,
          value: 'ko',
        ),
        const BottomSheetOption(
          label: 'English',
          icon: Icons.language,
          value: 'en',
        ),
      ],
    );
    if (result == null) return;
    ref
        .read(localeProvider.notifier)
        .setLocale(result == 'system' ? null : Locale(result));
  }
}
