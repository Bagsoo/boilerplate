import 'package:flutter/material.dart';

class KeyboardDismisser extends StatelessWidget {
  final Widget child;

  const KeyboardDismisser({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // ① 탭하면 키보드 내림
      behavior: HitTestBehavior.opaque, // ② 빈 공간도 터치 감지
      child: child,
    );
  }
}
