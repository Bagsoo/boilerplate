import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/app_snack_bar.dart';
import '../../l10n/l10n_extension.dart';

class ClipboardUtil {
  // 복사 + 스낵바 알림
  static Future<void> copy(
    BuildContext context,
    String text, {
    String? message,
  }) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!context.mounted) return;
    AppSnackBar.show(
      context,
      message: message ?? context.l10n.commonCopied,
      type: SnackBarType.success,
    );
  }
}
