import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

enum SnapShareImageShape { rectangle, circle }

class SnapShareImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final SnapShareImageShape shape;
  final Widget? errorWidget;
  final Map<String, String>? httpHeaders;
  final int? memCacheWidth;
  final int? memCacheHeight;

  const SnapShareImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 0.0,
    this.shape = SnapShareImageShape.rectangle,
    this.errorWidget,
    this.httpHeaders,
    this.memCacheWidth,
    this.memCacheHeight,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return _buildErrorWidget();
    }

    Widget imageWidget = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      httpHeaders: httpHeaders,
      memCacheWidth: memCacheWidth,
      memCacheHeight: memCacheHeight,
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
      placeholderFadeInDuration: Duration.zero,
      placeholder: (context, url) => _buildPlaceholder(context),
      errorWidget: (context, url, error) => _buildErrorWidget(),
    );

    if (shape == SnapShareImageShape.circle) {
      return ClipOval(child: imageWidget);
    } else if (borderRadius > 0) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildPlaceholder(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDarkMode ? Colors.grey[900]! : Colors.grey[300]!,
      highlightColor: isDarkMode ? Colors.grey[800]! : Colors.grey[100]!,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 200, // Providing a default height for placeholder
        decoration: BoxDecoration(
          color: Colors.white,
          shape: shape == SnapShareImageShape.circle
              ? BoxShape.circle
              : BoxShape.rectangle,
          borderRadius: shape == SnapShareImageShape.circle
              ? null
              : BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return errorWidget ??
        Container(
          width: width ?? double.infinity,
          height: height ?? 200,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            shape: shape == SnapShareImageShape.circle
                ? BoxShape.circle
                : BoxShape.rectangle,
            borderRadius: shape == SnapShareImageShape.circle
                ? null
                : BorderRadius.circular(borderRadius),
          ),
          child: const Icon(Icons.broken_image, color: Colors.grey),
        );
  }
}
