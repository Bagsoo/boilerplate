import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/version_util.dart';

class ForceUpdateService {
  final _client = Supabase.instance.client;

  // 스토어 URL (교체 필요)
  static const _androidStoreUrl =
      'https://play.google.com/store/apps/details?id=com.example.flutter_pt';
  static const _iosStoreUrl = 'https://apps.apple.com/app/idXXXXXXXXX';

  Future<void> checkForceUpdate(BuildContext context) async {
    try {
      final info = await PackageInfo.fromPlatform();
      final currentVersion = info.version;
      final platform = Theme.of(context).platform;

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
          title: const Text('업데이트 필요'),
          content: const Text('새로운 버전이 출시되었어요.\n계속 사용하려면 업데이트해주세요.'),
          actions: [
            TextButton(
              onPressed: () async {
                final url = platform == TargetPlatform.android
                    ? _androidStoreUrl
                    : _iosStoreUrl;
                await launchUrl(Uri.parse(url));
              },
              child: const Text('업데이트'),
            ),
          ],
        ),
      ),
    );
  }
}
