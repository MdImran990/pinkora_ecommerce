import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../data/model/category_model.dart';

class CategoryGridCard extends StatefulWidget {
  const CategoryGridCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  final CategoryModel category;
  final VoidCallback onTap;

  @override
  State<CategoryGridCard> createState() =>
      _CategoryGridCardState();
}

class _CategoryGridCardState extends State<CategoryGridCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      reverseDuration: const Duration(milliseconds: 120),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(
      CurvedAnimation(
        parent: _pressController,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _pressController.forward();
  }

  void _onTapCancel() {
    _pressController.reverse();
  }

  void _onTapUp(TapUpDetails details) {
    _pressController.reverse();

    Future<void>.delayed(
      const Duration(milliseconds: 15),
          () {
        if (mounted) {
          widget.onTap();
        }
      },
    );
  }

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
      case 'bags':
        return Icons.shopping_bag_rounded;
      case 'accessories':
        return Icons.diamond_rounded;
      case 'home & living':
        return Icons.home_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  Color _bgColor(String name) {
    switch (name.toLowerCase()) {
      case 'fashion':
        return const Color(0xFFFFE4F0);
      case 'beauty':
        return const Color(0xFFFFF0E6);
      case 'electronics':
        return const Color(0xFFE8F0FF);
      case 'shoes':
        return const Color(0xFFF0FFE8);
      case 'watches':
        return const Color(0xFFFFF8E1);
      case 'bags':
        return const Color(0xFFFFE4F0);
      case 'accessories':
        return const Color(0xFFF3E5F5);
      case 'home & living':
        return const Color(0xFFE8F5E9);
      default:
        return const Color(0xFFF5F5F5);
    }
  }

  Color _iconColor(String name) {
    switch (name.toLowerCase()) {
      case 'fashion':
        return AppColors.primary;
      case 'beauty':
        return const Color(0xFFFF6B35);
      case 'electronics':
        return const Color(0xFF3D5AFE);
      case 'shoes':
        return const Color(0xFF00C853);
      case 'watches':
        return const Color(0xFFFFAB00);
      case 'bags':
        return AppColors.primary;
      case 'accessories':
        return const Color(0xFF9C27B0);
      case 'home & living':
        return const Color(0xFF4CAF50);
      default:
        return AppColors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryName = widget.category.name;
    final icon = _icon(categoryName);
    final backgroundColor = _bgColor(categoryName);
    final iconColor = _iconColor(categoryName);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _onTapDown,
      onTapCancel: _onTapCancel,
      onTapUp: _onTapUp,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: RepaintBoundary(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: RepaintBoundary(
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ).copyWith(
                        color: backgroundColor,
                      ),
                      child: Center(
                        child: Icon(
                          icon,
                          size: 48,
                          color: iconColor,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          categoryName,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
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
                    left: 10,
                    right: 10,
                    bottom: 10,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${widget.category.itemCount}+ items',
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
        ),
      ),
    );
  }
}