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
    this.cacheWidth,
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

  /// Width (in pixels) the picture is decoded at. Left empty it is worked
  /// out from [width]/[height]. Decoding a 1000px photo just to show it in
  /// a 150px card wastes memory and makes scrolling stutter.
  final int? cacheWidth;

  int get _decodeWidth {
    final override = cacheWidth;

    if (override != null) return override;

    var logical = 160.0;

    if (width != null && width!.isFinite) {
      logical = width!;
    } else if (height != null && height!.isFinite) {
      logical = height! * 1.3;
    }

    return (logical * 3).clamp(150, 900).toInt();
  }

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
      memCacheWidth: _decodeWidth,
      filterQuality: FilterQuality.low,
      // The package default is a 1 second fade-out of the placeholder, which
      // keeps two layers painting on top of each other for every image.
      fadeInDuration: const Duration(milliseconds: 150),
      fadeOutDuration: const Duration(milliseconds: 80),
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
        cacheWidth: _decodeWidth,
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
