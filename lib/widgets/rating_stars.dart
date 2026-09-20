import 'package:flutter/material.dart';

import '../app/theme/app_colors.dart';

class RatingStars extends StatelessWidget {
  const RatingStars({
    super.key,
    required this.rating,
    this.size = 16,
  });

  final double rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
            (index) {
          if (index < rating.floor()) {
            return Icon(
              Icons.star_rounded,
              color: AppColors.star,
              size: size,
            );
          }

          if (index < rating) {
            return Icon(
              Icons.star_half_rounded,
              color: AppColors.star,
              size: size,
            );
          }

          return Icon(
            Icons.star_outline_rounded,
            color: AppColors.star,
            size: size,
          );
        },
      ),
    );
  }
}