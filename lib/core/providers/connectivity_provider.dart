import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectivityNotifier extends Notifier<bool> {
  late StreamSubscription _subscription;

  @override
  bool build() {
    // 연결 상태 변화 구독
    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      state = results.any((r) => r != ConnectivityResult.none);
    });

    // Notifier 해제 시 구독 취소
    ref.onDispose(() => _subscription.cancel());

    return true; // 초기값 true (연결된 상태로 가정)
  }
}

final connectivityProvider = NotifierProvider<ConnectivityNotifier, bool>(() {
  return ConnectivityNotifier();
});
