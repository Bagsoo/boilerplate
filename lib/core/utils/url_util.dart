import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/app_snack_bar.dart';
import '../../l10n/l10n_extension.dart';

class UrlUtil {
  static Future<void> launch(
    BuildContext context,
    String url, {
    String? errorMessage,
  }) async {
    final uri = Uri.parse(url);
    if (!await canLaunchUrl(uri)) {
      if (!context.mounted) return;
      AppSnackBar.show(
        context,
        message: errorMessage ?? context.l10n.commonLinkOpenFailed,
        type: SnackBarType.error,
      );
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
