import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/version_util.dart';
import '../../l10n/l10n_extension.dart';

class ForceUpdateService {
  final _client = Supabase.instance.client;

  // 스토어 URL (교체 필요)
  static const _androidStoreUrl =
      'https://play.google.com/store/apps/details?id=com.example.flutter_pt';
  static const _iosStoreUrl = 'https://apps.apple.com/app/idXXXXXXXXX';

  Future<void> checkForceUpdate(BuildContext context) async {
    try {
      final platform = Theme.of(context).platform;
      final info = await PackageInfo.fromPlatform();
      final currentVersion = info.version;

      // Supabase에서 min_version 가져오기
      final key = platform == TargetPlatform.android
          ? 'min_version_android'
          : 'min_version_ios';

      final data = await _client
          .from('app_config')
          .select('value')
          .eq('key', key)
          .single();

      final minVersion = data['value'] as String;

      // 버전 비교
      final needsUpdate = VersionUtil.isUpdateRequired(
        currentVersion: currentVersion,
        minVersion: minVersion,
      );

      if (needsUpdate && context.mounted) {
        _showForceUpdateDialog(context, platform);
      }
    } catch (e) {
      // 버전 체크 실패해도 앱 실행은 계속
      debugPrint('버전 체크 실패: $e');
    }
  }

  void _showForceUpdateDialog(BuildContext context, TargetPlatform platform) {
    showDialog(
      context: context,
      barrierDismissible: false, // ← 닫기 불가
      builder: (context) => PopScope(
        canPop: false, // ← 뒤로가기 불가
        child: AlertDialog(
          title: Text(context.l10n.forceUpdateTitle),
          content: Text(context.l10n.forceUpdateContent),
          actions: [
            TextButton(
              onPressed: () async {
                final url = platform == TargetPlatform.android
                    ? _androidStoreUrl
                    : _iosStoreUrl;
                await launchUrl(Uri.parse(url));
              },
              child: Text(context.l10n.forceUpdateAction),
            ),
          ],
        ),
      ),
    );
  }
}
