import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/category_controller.dart';
import '../widgets/category_grid_card.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/routes/app_routes.dart';
import '../../../widgets/bottom_nav_bar.dart';
import '../../../data/model/category_model.dart';

class CategoryScreen extends GetView<CategoryController> {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: Get.back,
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.border,
              ),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16,
              color: AppColors.black,
            ),
          ),
        ),
        title: const Text(
          'Categories',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(
              Icons.search_rounded,
              color: AppColors.black,
              size: 24,
            ),
          ),
        ],
      ),
      body: Obx(
            () {
          final categories = controller.categories;

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            cacheExtent: 800,
            keyboardDismissBehavior:
            ScrollViewKeyboardDismissBehavior.onDrag,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.85,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];

              return RepaintBoundary(
                key: ValueKey(category.id),
                child: _AnimatedCategoryCard(
                  index: index,
                  category: category,
                  onTap: () => Get.toNamed(
                    AppRoutes.productList,
                    arguments: category,
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: const PinkoraBottomNav(),
    );
  }
}

class _AnimatedCategoryCard extends StatefulWidget {
  const _AnimatedCategoryCard({
    required this.index,
    required this.category,
    required this.onTap,
  });

  final int index;
  final CategoryModel category;
  final VoidCallback onTap;

  @override
  State<_AnimatedCategoryCard> createState() =>
      _AnimatedCategoryCardState();
}

class _AnimatedCategoryCardState
    extends State<_AnimatedCategoryCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );

    final curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(curve);

    _scaleAnimation = Tween<double>(
      begin: 0.94,
      end: 1,
    ).animate(curve);

    Future<void>.delayed(
      Duration(milliseconds: 45 * widget.index),
          () {
        if (mounted) {
          _controller.forward();
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: CategoryGridCard(
          category: widget.category,
          onTap: widget.onTap,
        ),
      ),
    );
  }
}