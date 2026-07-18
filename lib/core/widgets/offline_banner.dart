import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/connectivity_provider.dart';

class OfflineBanner extends ConsumerWidget {
  final Widget child;

  const OfflineBanner({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(connectivityProvider);

    return Column(
      children: [
        // 오프라인일 때만 배너 표시
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: isConnected ? 0 : 30,
          color: Colors.red,
          child: isConnected
              ? const SizedBox()
              : const Center(
                  child: Text(
                    '인터넷 연결이 없어요',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ),
        Expanded(child: child),
      ],
    );
  }
}
