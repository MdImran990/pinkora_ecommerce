import 'package:flutter/material.dart';
import '../app/theme/app_colors.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final double size;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        if (i < rating.floor()) {
          return Icon(Icons.star_rounded,
              color: AppColors.star, size: size);
        } else if (i < rating) {
          return Icon(Icons.star_half_rounded,
              color: AppColors.star, size: size);
        } else {
          return Icon(Icons.star_outline_rounded,
              color: AppColors.star, size: size);
        }
      }),
    );
  }
}