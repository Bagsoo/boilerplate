import '../../../core/utils/image_upload_util.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final _client = Supabase.instance.client;

  // 갤러리에서 이미지 선택 후 업로드
  Future<String?> uploadAvatar() async {
    final image = await ImageUploadUtil.pick(maxWidth: 512, maxHeight: 512);
    if (image == null) return null;

    final userId = _client.auth.currentUser!.id;

    final url = await ImageUploadUtil.upload(
      image: image,
      bucket: 'avatars',
      path: '$userId/avatar',
      upsert: true,
    );

    await _client
        .from('profiles')
        .update({'profile_image': url})
        .eq('id', userId);

    return url;
  }

  // 프로필 이미지 삭제 (파일 + profiles 컬럼 비우기)
  Future<void> removeAvatar() async {
    final userId = _client.auth.currentUser!.id;
    await deleteAvatar();
    await _client
        .from('profiles')
        .update({'profile_image': null})
        .eq('id', userId);
  }

  // 회원 탈퇴 시 프로필 이미지 삭제
  Future<void> deleteAvatar() async {
    final userId = _client.auth.currentUser!.id;

    final files = await _client.storage.from('avatars').list(path: userId);

    if (files.isNotEmpty) {
      final paths = files.map((f) => '$userId/${f.name}').toList();
      await _client.storage.from('avatars').remove(paths);
    }
  }
}
