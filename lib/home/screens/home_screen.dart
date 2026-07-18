import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/profile/providers/profile_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (ref.read(profileProvider) == null) {
        ref.read(profileProvider.notifier).loadProfile();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);

    return Center(
      // ← Scaffold 제거, AppBar 제거
      child: profile == null
          ? const CircularProgressIndicator()
          : Text('안녕하세요, ${profile.nickname}님!'),
    );
  }
}
