import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/profile_provider.dart';
import '../../../core/widgets/avatar_image.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/app_snack_bar.dart';
import '../../../core/widgets/loading_view.dart';

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
      setState(() => _isEditing = false);
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.show(
        context,
        message: '업데이트 실패: $e',
        type: SnackBarType.error,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);

    if (profile == null || _isLoading) {
      return const LoadingView();
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AvatarImage(imageUrl: profile.profileImage, radius: 50),
          const SizedBox(height: 16),
          Text('이메일: ${profile.email}'),
          const SizedBox(height: 8),

          if (!_isEditing) ...[
            Row(
              children: [
                Text('닉네임: ${profile.nickname}'),
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
              label: '새 닉네임',
              prefixIcon: const Icon(Icons.person_outline),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: '저장',
                    isLoading: _isLoading,
                    onPressed: _updateNickname,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AppButton(
                    label: '취소',
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
