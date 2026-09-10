import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../data/model/category_model.dart';

class CategoryGridCard extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onTap;

  const CategoryGridCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  IconData _icon(String name) {
    switch (name.toLowerCase()) {
      case 'fashion':       return Icons.checkroom_rounded;
      case 'beauty':        return Icons.face_retouching_natural;
      case 'electronics':   return Icons.phone_android_rounded;
      case 'shoes':         return Icons.hiking_rounded;
      case 'watches':       return Icons.watch_rounded;
      case 'bags':          return Icons.shopping_bag_rounded;
      case 'accessories':   return Icons.diamond_rounded;
      case 'home & living': return Icons.home_rounded;
      default:              return Icons.category_rounded;
    }
  }

  Color _bgColor(String name) {
    switch (name.toLowerCase()) {
      case 'fashion':       return const Color(0xFFFFE4F0);
      case 'beauty':        return const Color(0xFFFFF0E6);
      case 'electronics':   return const Color(0xFFE8F0FF);
      case 'shoes':         return const Color(0xFFF0FFE8);
      case 'watches':       return const Color(0xFFFFF8E1);
      case 'bags':          return const Color(0xFFFFE4F0);
      case 'accessories':   return const Color(0xFFF3E5F5);
      case 'home & living': return const Color(0xFFE8F5E9);
      default:              return const Color(0xFFF5F5F5);
    }
  }

  Color _iconColor(String name) {
    switch (name.toLowerCase()) {
      case 'fashion':       return AppColors.primary;
      case 'beauty':        return const Color(0xFFFF6B35);
      case 'electronics':   return const Color(0xFF3D5AFE);
      case 'shoes':         return const Color(0xFF00C853);
      case 'watches':       return const Color(0xFFFFAB00);
      case 'bags':          return AppColors.primary;
      case 'accessories':   return const Color(0xFF9C27B0);
      case 'home & living': return const Color(0xFF4CAF50);
      default:              return AppColors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Image area
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: _bgColor(category.name),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Center(
                  child: Icon(
                    _icon(category.name),
                    size: 48,
                    color: _iconColor(category.name),
                  ),
                ),
              ),
            ),

            // Name + count
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      category.name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                    color: AppColors.grey,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, bottom: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${category.itemCount}+ items',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}