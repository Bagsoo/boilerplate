import 'package:flutter/material.dart';
import 'package:flutter_pt/l10n/app_localizations.dart';
import '../../profile/providers/profile_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: profile == null
          ? const CircularProgressIndicator()
          : Text(l10n.homeGreeting(profile.nickname)),
    );
  }
}
