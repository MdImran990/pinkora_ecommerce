import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../app/theme/app_colors.dart';

/// Shows a product/category picture.
///
/// [url] can be:
/// - a network URL (http/https)      -> loaded and cached
/// - several URLs joined with '|'    -> the next one is tried if a URL fails
/// - an 'assets/...' path            -> bundled image
/// - a local device file path        -> loaded with Image.file (e.g. a
///                                      profile photo picked from gallery)
/// - empty, or every URL failed      -> pink placeholder with an icon
class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.radius = BorderRadius.zero,
    this.fit = BoxFit.cover,
    this.icon = Icons.shopping_bag_outlined,
    this.iconSize = 32,
    this.backgroundColor = AppColors.primaryLight,
    this.iconColor = AppColors.primary,
  });

  final String url;
  final double? width;
  final double? height;
  final BorderRadius radius;
  final BoxFit fit;
  final IconData icon;
  final double iconSize;
  final Color backgroundColor;
  final Color iconColor;

  Widget _placeholder() {
    return Container(
      color: backgroundColor,
      alignment: Alignment.center,
      child: Icon(
        icon,
        size: iconSize,
        color: iconColor.withValues(alpha: 0.45),
      ),
    );
  }

  Widget _network(List<String> urls) {
    return CachedNetworkImage(
      imageUrl: urls.first,
      fit: fit,
      memCacheWidth: 700,
      fadeInDuration: const Duration(milliseconds: 180),
      placeholder: (context, _) => _placeholder(),
      errorWidget: (context, _, error) {
        // Shown in the debug console so a broken link is easy to find.
        debugPrint('ProductImage failed: ${urls.first} ($error)');

        if (urls.length > 1) {
          return _network(urls.sublist(1));
        }

        return _placeholder();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final urls = url
        .split('|')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final Widget content;

    if (urls.isEmpty) {
      content = _placeholder();
    } else if (urls.first.startsWith('assets/')) {
      content = Image.asset(
        urls.first,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _placeholder(),
      );
    } else if (!urls.first.startsWith('http')) {
      // A path on the device (e.g. a profile photo saved to app storage).
      content = Image.file(
        File(urls.first),
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _placeholder(),
      );
    } else {
      content = _network(urls);
    }

    return ClipRRect(
      borderRadius: radius,
      child: SizedBox(
        width: width,
        height: height,
        child: content,
      ),
    );
  }
}
