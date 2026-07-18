import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final _client = Supabase.instance.client;
  final _picker = ImagePicker();

  // 갤러리에서 이미지 선택 후 업로드
  Future<String?> uploadAvatar() async {
    // ① 갤러리에서 이미지 선택
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80, // 용량 줄이기
    );

    if (image == null) return null; // 선택 취소

    final userId = _client.auth.currentUser!.id;
    final bytes = await image.readAsBytes();
    final fileExt = image.path.split('.').last;
    final fileName = '$userId/avatar.$fileExt'; // ② 경로: userId/avatar.jpg

    // ③ Storage에 업로드
    await _client.storage
        .from('avatars')
        .uploadBinary(
          fileName,
          bytes,
          fileOptions: const FileOptions(upsert: true), // 덮어쓰기 허용
        );

    // ④ 업로드된 이미지 Public URL 반환
    final imageUrl = _client.storage.from('avatars').getPublicUrl(fileName);

    // ⑤ profiles 테이블에 URL 저장
    await _client
        .from('profiles')
        .update({'profile_image': imageUrl})
        .eq('id', userId);

    return imageUrl;
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
