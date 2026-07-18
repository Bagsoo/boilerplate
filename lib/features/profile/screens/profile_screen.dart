import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/profile_provider.dart';
import '../../../core/widgets/avatar_image.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  // final _client = Supabase.instance.client;
  // Map<String, dynamic>? _profile;
  final _nicknameController = TextEditingController();
  bool _isLoading = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    // _loadProfile();
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  // Future<void> _loadProfile() async {
  //   final userId = _client.auth.currentUser!.id;

  //   final data = await _client
  //       .from('profiles')
  //       .select()
  //       .eq('id', userId)
  //       .single();

  //   setState(() {
  //     _profile = data;
  //     _isLoading = false;
  //   });
  // }

  Future<void> _updateNickname() async {
    setState(() => _isLoading = true);

    try {
      await ref
          .read(profileProvider.notifier)
          .updateNickname(_nicknameController.text.trim());
      setState(() {
        _isEditing = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('업데이트 실패, $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);

    if (profile == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // final email = _client.auth.currentUser!.email ?? '알 수 없음';
    // final nickname = _profile?['nickname'] ?? '알 수 없음';

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AvatarImage(imageUrl: profile.profileImage, radius: 50),
          Text('이메일: ${profile.email}'),
          const SizedBox(height: 8),
          // Text('닉네임: ${profile.nickname}'),
          if (!_isEditing) ...[
            Row(
              children: [
                Text('닉네임: ${profile.nickname}'),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _nicknameController.text = profile.nickname;
                    setState(() => _isEditing = true);
                  },
                ),
              ],
            ),
          ] else ...[
            TextField(
              controller: _nicknameController,
              decoration: const InputDecoration(labelText: '새 닉네임'),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _isLoading ? null : _updateNickname,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('저장'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => setState(() => _isEditing = false),
                  child: const Text('취소'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
