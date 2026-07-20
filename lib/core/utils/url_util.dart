import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/app_snack_bar.dart';

class UrlUtil {
  static Future<void> launch(
    BuildContext context,
    String url, {
    String errorMessage = '링크를 열 수 없어요',
  }) async {
    final uri = Uri.parse(url);
    if (!await canLaunchUrl(uri)) {
      if (!context.mounted) return;
      AppSnackBar.show(
        context,
        message: errorMessage,
        type: SnackBarType.error,
      );
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
