import 'package:flutter/material.dart';

class AppBottomSheet {
  // ① 기본 바텀 시트
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
    double? height,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _BottomSheetContainer(height: height, child: child),
    );
  }

  // ② 옵션 선택 바텀 시트
  static Future<T?> showOptions<T>(
    BuildContext context, {
    String? title,
    required List<BottomSheetOption<T>> options,
  }) {
    return show<T>(
      context,
      child: _OptionsContent<T>(title: title, options: options),
    );
  }
}

// ③ 바텀 시트 컨테이너
class _BottomSheetContainer extends StatelessWidget {
  final Widget child;
  final double? height;

  const _BottomSheetContainer({required this.child, this.height});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 드래그 핸들
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

// ④ 옵션 모델
class BottomSheetOption<T> {
  final String label;
  final IconData? icon;
  final T value;
  final Color? color;
  final bool isDestructive;

  const BottomSheetOption({
    required this.label,
    required this.value,
    this.icon,
    this.color,
    this.isDestructive = false,
  });
}

// ⑤ 옵션 리스트 위젯
class _OptionsContent<T> extends StatelessWidget {
  final String? title;
  final List<BottomSheetOption<T>> options;

  const _OptionsContent({this.title, required this.options});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 타이틀
        if (title != null) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
            child: Text(
              title!,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ),
          Divider(height: 1, color: theme.colorScheme.outline.withOpacity(0.1)),
        ],

        // 옵션 목록
        ...options.map(
          (option) => ListTile(
            leading: option.icon != null
                ? Icon(
                    option.icon,
                    color: option.isDestructive
                        ? const Color(0xFFEF4444)
                        : option.color ?? theme.colorScheme.onSurface,
                  )
                : null,
            title: Text(
              option.label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: option.isDestructive
                    ? const Color(0xFFEF4444)
                    : option.color ?? theme.colorScheme.onSurface,
              ),
            ),
            onTap: () => Navigator.pop(context, option.value),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
      ],
    );
  }
}
