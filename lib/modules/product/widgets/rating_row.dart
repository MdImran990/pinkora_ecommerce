import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class RatingRow extends StatelessWidget {
  final double rating;
  final int reviewCount;

  const RatingRow({
    super.key,
    required this.rating,
    required this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(5, (i) {
          if (i < rating.floor()) {
            return const Icon(Icons.star_rounded,
                color: AppColors.star, size: 18);
          } else if (i < rating) {
            return const Icon(Icons.star_half_rounded,
                color: AppColors.star, size: 18);
          } else {
            return const Icon(Icons.star_outline_rounded,
                color: AppColors.star, size: 18);
          }
        }),
        const SizedBox(width: 6),
        Text(
          '$rating',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '($reviewCount reviews)',
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.grey,
          ),
        ),
      ],
    );
  }
}