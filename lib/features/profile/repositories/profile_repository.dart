import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile_model.dart';
import '../services/profile_service.dart';

class ProfileRepository {
  final _client = Supabase.instance.client;
  final _service = ProfileService();

  // 프로필 조회
  Future<ProfileModel?> getProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    final data = await _client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .single();

    return ProfileModel.fromMap(data, user.email!);
  }

  // 닉네임 수정
  Future<void> updateNickname(String nickname) async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    await _client
        .from('profiles')
        .update({'nickname': nickname})
        .eq('id', user.id);
  }

  // 프로필 이미지 업로드
  Future<String?> uploadAvatar() async {
    return await _service.uploadAvatar();
  }

  // 프로필 이미지 삭제
  Future<void> deleteAvatar() async {
    await _service.deleteAvatar();
  }

  // 약관 동의 시각 저장
  Future<void> saveAgreedAt(String userId) async {
    final now = DateTime.now().toUtc().toIso8601String();
    await _client
        .from('profiles')
        .update({'terms_agreed_at': now, 'privacy_agreed_at': now})
        .eq('id', userId);
  }
}

// Provider 등록
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository();
});
