import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'image_viewer.dart';

class AvatarImage extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final bool tappable;
  final String? heroTag;

  const AvatarImage({
    super.key,
    this.imageUrl,
    this.radius = 40,
    this.tappable = false,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return _buildPlaceholder(); // ① 이미지 없을 때
    }

    final image = CachedNetworkImage(
      imageUrl: imageUrl!,
      imageBuilder: (context, imageProvider) => Hero(
        // ③ Hero 추가
        tag: heroTag ?? imageUrl!,
        child: CircleAvatar(radius: radius, backgroundImage: imageProvider),
      ),
      placeholder: (context, url) => _buildShimmer(),
      errorWidget: (context, url, error) => _buildPlaceholder(),
    );

    // tappable이면 탭 시 ImageViewer로
    if (tappable && imageUrl != null) {
      return GestureDetector(
        onTap: () => ImageViewer.show(
          context,
          imageUrl: imageUrl!,
          heroTag: heroTag ?? imageUrl!,
        ),
        child: image,
      );
    }

    return image;
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
