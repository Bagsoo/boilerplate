import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../profile/providers/profile_provider.dart';
import '../../../l10n/l10n_extension.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../core/widgets/notification_permission_sheet.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationPermissionSheet.showIfNeeded(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);

    return Center(
      child: profile == null
          ? const LoadingView()
          : Text(context.l10n.homeGreeting(profile.nickname)),
    );
  }
}
