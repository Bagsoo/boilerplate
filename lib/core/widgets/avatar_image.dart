import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AvatarImage extends StatelessWidget {
  final String? imageUrl;
  final double radius;

  const AvatarImage({super.key, this.imageUrl, this.radius = 40});

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return _buildPlaceholder(); // ① 이미지 없을 때
    }

    return CachedNetworkImage(
      imageUrl: imageUrl!,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        radius: radius,
        backgroundImage: imageProvider, // ② 이미지 로드 완료
      ),
      placeholder: (context, url) => _buildShimmer(), // ③ 로딩 중
      errorWidget: (context, url, error) => _buildPlaceholder(), // ④ 에러
    );
  }

  // 이미지 없거나 에러일 때
  Widget _buildPlaceholder() {
    return CircleAvatar(
      radius: radius,
      child: Icon(Icons.person, size: radius),
    );
  }

  // 로딩 중 shimmer 효과
  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: CircleAvatar(radius: radius, backgroundColor: Colors.grey[300]),
    );
  }
}
