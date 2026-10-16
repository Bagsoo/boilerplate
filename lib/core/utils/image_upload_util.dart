// lib/core/utils/image_upload_util.dart
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/permission_service.dart';
import '../widgets/permission_gate.dart';

class ImageUploadUtil {
  static final _picker = ImagePicker();

  // 갤러리에서 선택 (압축 옵션을 호출부가 정함)
  static Future<XFile?> pick({
    double maxWidth = 1080,
    double maxHeight = 1080,
    int quality = 80,
  }) {
    return _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: quality,
    );
  }

  // 카메라 촬영 (권한 확인 후)
  static Future<XFile?> pickFromCamera(
    BuildContext context, {
    double maxWidth = 1080,
    double maxHeight = 1080,
    int quality = 80,
  }) async {
    final ok = await PermissionGate.ensure(context, AppPermission.camera);
    if (!ok) return null;
    return _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: quality,
    );
  }

  // 버킷/경로를 지정해 업로드 → public URL 반환
  // path: 확장자 제외 경로, 예: '$userId/${DateTime.now().millisecondsSinceEpoch}'
  static Future<String> upload({
    required XFile image,
    required String bucket,
    required String path,
    bool upsert = false,
  }) async {
    final client = Supabase.instance.client;
    final ext = image.path.split('.').last;
    final fullPath = '$path.$ext';
    final bytes = await image.readAsBytes();

    await client.storage
        .from(bucket)
        .uploadBinary(
          fullPath,
          bytes,
          fileOptions: FileOptions(upsert: upsert),
        );

    return client.storage.from(bucket).getPublicUrl(fullPath);
  }
}
