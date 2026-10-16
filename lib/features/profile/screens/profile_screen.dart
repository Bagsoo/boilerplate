import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/profile_provider.dart';
import '../../../core/widgets/avatar_image.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/app_snack_bar.dart';
import '../../../core/utils/clipboard_util.dart';
import '../../../core/widgets/skeleton_loader.dart';
import '../../../l10n/l10n_extension.dart';
import '../../../core/errors/app_error.dart';
import '../../../core/errors/app_error_l10n.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _nicknameController = TextEditingController();
  bool _isLoading = false;
  bool _isEditing = false;

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _updateNickname() async {
    setState(() => _isLoading = true);

    try {
      await ref
          .read(profileProvider.notifier)
          .updateNickname(_nicknameController.text.trim());
      if (!mounted) return;
      setState(() => _isEditing = false);
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.show(
        context,
        message: mapToAppError(e).message(context),
        type: SnackBarType.error,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);

    if (profile == null || _isLoading) {
      return const SkeletonProfile();
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AvatarImage(imageUrl: profile.profileImage, radius: 50),
          const SizedBox(height: 16),
          GestureDetector(
            onLongPress: () => ClipboardUtil.copy(
              context,
              profile.email,
              message: context.l10n.profileEmailCopied,
            ),
            child: Text(context.l10n.profileEmail(profile.email)),
          ),
          const SizedBox(height: 8),

          if (!_isEditing) ...[
            Row(
              children: [
                Text(context.l10n.profileNickname(profile.nickname)),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () {
                    _nicknameController.text = profile.nickname;
                    setState(() => _isEditing = true);
                  },
                ),
              ],
            ),
          ] else ...[
            AppTextField(
              controller: _nicknameController,
              label: context.l10n.profileNewNickname,
              prefixIcon: const Icon(Icons.person_outline),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: context.l10n.save,
                    isLoading: _isLoading,
                    onPressed: _updateNickname,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AppButton(
                    label: context.l10n.cancel,
                    type: AppButtonType.ghost,
                    onPressed: () => setState(() => _isEditing = false),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
