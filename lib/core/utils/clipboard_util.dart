import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/app_snack_bar.dart';

class ClipboardUtil {
  // 복사 + 스낵바 알림
  static Future<void> copy(
    BuildContext context,
    String text, {
    String message = '복사되었어요',
  }) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!context.mounted) return;
    AppSnackBar.show(context, message: message, type: SnackBarType.success);
  }
}
