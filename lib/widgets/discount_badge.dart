import 'package:flutter/material.dart';
import '../app/theme/app_colors.dart';

class DiscountBadge extends StatelessWidget {
  final int percent;

  const DiscountBadge({super.key, required this.percent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.sale,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '-$percent%',
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}