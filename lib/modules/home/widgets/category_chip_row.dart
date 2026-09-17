import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../data/model/category_model.dart';
import '../../../app/routes/app_routes.dart';

class CategoryChipRow extends StatelessWidget {
  final List<CategoryModel> categories;

  const CategoryChipRow({
    super.key,
    required this.categories,
  });

  IconData _icon(String name) {
    switch (name.toLowerCase()) {
      case 'fashion':
        return Icons.checkroom_rounded;
      case 'beauty':
        return Icons.face_retouching_natural;
      case 'electronics':
        return Icons.phone_android_rounded;
      case 'shoes':
        return Icons.hiking_rounded;
      case 'watches':
        return Icons.watch_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        cacheExtent: 300,
        itemCount: categories.length,
        separatorBuilder: (_, __) =>
        const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final category = categories[index];

          return GestureDetector(
            key: ValueKey(category.id),
            onTap: () => Get.toNamed(
              AppRoutes.category,
            ),
            child: Column(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    _icon(category.name),
                    color: AppColors.primary,
                    size: 26,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  category.name,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.darkGrey,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}