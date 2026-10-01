import 'package:flutter/material.dart';
import 'package:flutter_pt/features/settings/providers/locale_provider.dart';
import 'package:flutter_pt/l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreen();
}

class _SettingsScreen extends ConsumerState<SettingsScreen> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = '${info.version}'; // 빌드 넘버 미포함
      // _version = '${info.version} (${info.buildNumber})'; //빌드 넘버 포함
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final profile = ref.watch(profileProvider);
    final locale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.setting)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                final result = await AppBottomSheet.showOptions<String>(
                  context,
                  title: '프로필 이미지',
                  options: [
                    const BottomSheetOption(
                      label: '갤러리에서 선택',
                      icon: Icons.photo_library_outlined,
                      value: 'gallery',
                    ),
                    const BottomSheetOption(
                      label: '이미지 삭제',
                      icon: Icons.delete_outline,
                      value: 'delete',
                      isDestructive: true,
                    ),
                  ],
                );
                if (result == 'gallery') {
                  ref.read(profileProvider.notifier).uploadAvatar();
                }
              },
              child: AvatarImage(radius: 50, imageUrl: profile?.profileImage),
            ),
            const SizedBox(height: 8),
            const Text('탭하여 이미지 변경'),
            const SizedBox(height: 32),
            SwitchListTile(
              title: Text(l10n.darkmode),
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
              title: Text(l10n.settingsLanguage),
              subtitle: Text(_localeLabel(locale, l10n)),
              onTap: () => _showLanguageSheet(context),
            ),
            const Divider(),

            // 일반 알림
            SwitchListTile(
              title: const Text('푸시 알림'),
              subtitle: const Text('새로운 알림을 받아요'),
              secondary: const Icon(Icons.notifications_outlined),
              value: profile?.pushNotificationEnabled ?? true,
              onChanged: (value) {
                ref
                    .read(profileProvider.notifier)
                    .updateNotificationSettings(
                      pushEnabled: value,
                      marketingEnabled:
                          profile?.marketingNotificationEnabled ?? false,
                    );
              },
            ),

            // 마케팅 알림
            SwitchListTile(
              title: const Text('마케팅 알림'),
              subtitle: const Text('혜택 및 이벤트 소식을 받아요'),
              secondary: const Icon(Icons.campaign_outlined),
              value: profile?.marketingNotificationEnabled ?? false,
              onChanged: (value) {
                ref
                    .read(profileProvider.notifier)
                    .updateNotificationSettings(
                      pushEnabled: profile?.pushNotificationEnabled ?? true,
                      marketingEnabled: value,
                    );
              },
            ),
            const SizedBox(height: 8),
            const Divider(),
            AppButton(
              label: '리뷰 남기기',
              type: AppButtonType.ghost,
              icon: Icons.star_outline_rounded,
              onPressed: () => ReviewService().openStoreListing(),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('로그아웃'),
              onTap: () async {
                await ref.read(authProvider.notifier).signOut();
                ref.read(profileProvider.notifier).clear();
                ref.read(notificationsProvider.notifier).clear();
                if (!mounted) return;
                context.go('/login');
              },
            ),
            const SizedBox(height: 0),
            ListTile(
              leading: Icon(
                Icons.person_remove_outlined,
                color: Theme.of(context).colorScheme.error.withOpacity(0.7),
              ),
              title: Text(
                '회원탈퇴',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error.withOpacity(0.7),
                ),
              ),
              onTap: () => _deleteAccount(context, ref),
            ),

            const SizedBox(height: 32),
            Text(
              '버전 $_version',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteAccount(BuildContext context, WidgetRef ref) async {
    // ① 확인 다이얼로그
    final confirm = await ConfirmDialog.show(
      context,
      title: '회원탈퇴',
      content: '정말 탈퇴하시겠어요?\n모든 데이터가 삭제되며 복구할 수 없어요.',
      confirmLabel: '탈퇴하기',
      isDanger: true,
    );

    if (confirm != true) return; // 취소 누르면 종료

    // ② 탈퇴 실행
    final success = await ref.read(authProvider.notifier).deleteAccount();

    if (success) {
      ref.read(profileProvider.notifier).clear();
      if (!context.mounted) return;
      context.go('/login');
    } else {
      final error = ref.read(authProvider).error;
      if (!context.mounted) return;
      AppSnackBar.show(
        context,
        message: error ?? '탈퇴 실패',
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
