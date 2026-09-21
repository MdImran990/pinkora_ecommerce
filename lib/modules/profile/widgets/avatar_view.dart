import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../widgets/product_image.dart';

/// Round profile picture.
///
/// [avatar] can be:
/// - empty                 -> the first letter of the name
/// - an emoji (preset)     -> shown as text
/// - http(s) URL / assets  -> a real photo (used once the backend gives one)
class AvatarView extends StatelessWidget {
  const AvatarView({
    super.key,
    required this.avatar,
    required this.name,
    this.size = 90,
  });

  final String avatar;
  final String name;
  final double size;

  bool get _isPicture {
    return avatar.startsWith('http') || avatar.startsWith('assets/');
  }

  @override
  Widget build(BuildContext context) {
    final Widget content;

    if (_isPicture) {
      content = ProductImage(
        url: avatar,
        width: size,
        height: size,
        icon: Icons.person_rounded,
        iconSize: size * 0.55,
        radius: BorderRadius.circular(size / 2),
      );
    } else {
      final text = avatar.isNotEmpty
          ? avatar
          : (name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase());

      content = Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: avatar.isNotEmpty ? size * 0.5 : size * 0.42,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primary,
          width: 2.5,
        ),
      ),
      child: ClipOval(child: content),
    );
  }
}
