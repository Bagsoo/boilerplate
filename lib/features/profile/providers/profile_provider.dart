import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile_model.dart';
import '../repositories/profile_repository.dart';
import '../../../core/logger.dart';

class ProfileNotifier extends Notifier<ProfileModel?> {
  @override
  ProfileModel? build() => null;

  late final _repository = ref.read(profileRepositoryProvider);

  Future<void> loadProfile() async {
    try {
      final profile = await _repository.getProfile();
      state = profile;
    } catch (e) {
      // JWT 만료 시 세션 갱신 후 재시도
      if (e.toString().contains('JWT expired')) {
        try {
          await Supabase.instance.client.auth.refreshSession();
          final profile = await _repository.getProfile();
          state = profile;
        } catch (retryError) {
          logger.e('loadProfile 재시도 실패', error: retryError);
        }
      } else {
        logger.e('loadProfile 에러', error: e);
      }
    }
  }

  Future<void> updateNickname(String newNickname) async {
    if (state == null) return;

    await _repository.updateNickname(newNickname);
    state = state!.copyWith(nickname: newNickname);
  }

  Future<void> uploadAvatar() async {
    final imageUrl = await _repository.uploadAvatar();
    if (imageUrl == null) return;

    final urlWithTimestamp =
        '$imageUrl?t=${DateTime.now().millisecondsSinceEpoch}';
    state = state?.copyWith(profileImage: urlWithTimestamp);
  }

  void clear() => state = null;
}

final profileProvider = NotifierProvider<ProfileNotifier, ProfileModel?>(() {
  return ProfileNotifier();
});
