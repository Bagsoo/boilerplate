import 'package:flutter/material.dart';

enum AppButtonType { primary, secondary, danger, ghost }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final AppButtonType type;
  final IconData? icon;
  final double? width;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.type = AppButtonType.primary,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 타입별 컬러
    final colors = _getColors(theme);

    return SizedBox(
      width: width ?? double.infinity,
      height: 52,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.$1,
            foregroundColor: colors.$2,
            disabledBackgroundColor: colors.$1.withOpacity(0.5),
            elevation: type == AppButtonType.ghost ? 0 : 2,
            shadowColor: colors.$1.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: type == AppButtonType.ghost
                  ? BorderSide(color: colors.$1, width: 1.5)
                  : BorderSide.none,
            ),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: isLoading
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: colors.$2,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, size: 18),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  // (배경색, 글자색) 반환
  (Color, Color) _getColors(ThemeData theme) {
    switch (type) {
      case AppButtonType.primary:
        return (theme.colorScheme.primary, Colors.white);
      case AppButtonType.secondary:
        return (theme.colorScheme.secondary, Colors.white);
      case AppButtonType.danger:
        return (const Color(0xFFEF4444), Colors.white);
      case AppButtonType.ghost:
        return (theme.colorScheme.primary, theme.colorScheme.primary);
    }
  }
}
