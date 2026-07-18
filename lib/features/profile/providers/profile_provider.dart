import 'package:flutter_pt/core/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile_model.dart';
import '../services/profile_service.dart';

class ProfileNotifier extends Notifier<ProfileModel?> {
  @override
  ProfileModel? build() => null;

  final _client = Supabase.instance.client;
  final _profileService = ProfileService();

  // 프로필 불러오기
  Future<void> loadProfile() async {
    final user = _client.auth.currentUser;

    if (user == null) return;

    try {
      final data = await _client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      state = ProfileModel.fromMap(data, user.email!);
    } catch (e) {
      logger.e('loadProfile 에러', error: e);
    }
  }

  // 닉네임 변경
  Future<void> updateNickname(String newNickname) async {
    final user = _client.auth.currentUser;
    if (user == null || state == null) return;

    await _client
        .from('profiles')
        .update({'nickname': newNickname})
        .eq('id', user.id);

    state = state!.copyWith(nickname: newNickname);
  }

  // 프로필 사진 업로드
  Future<void> uploadAvatar() async {
    final imageUrl = await _profileService.uploadAvatar();
    if (imageUrl == null) return;

    // 캐시 URL 방지 - 매번 새 이미지로 보이게
    final urlWithTimestamp =
        '$imageUrl?t=${DateTime.now().millisecondsSinceEpoch}';

    state = state?.copyWith(profileImage: urlWithTimestamp);
  }

  void clear() {
    state = null;
  }
}

// 프로바이더 등록
final profileProvider = NotifierProvider<ProfileNotifier, ProfileModel?>(() {
  return ProfileNotifier();
});
