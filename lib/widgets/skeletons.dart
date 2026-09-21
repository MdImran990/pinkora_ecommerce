import 'package:flutter/material.dart';

import '../app/theme/app_colors.dart';
import 'shimmer_loader.dart';

/// Placeholder shown while data is loading (looks like a product card).
class ProductCardSkeleton extends StatelessWidget {
  const ProductCardSkeleton({
    super.key,
    this.width,
    this.imageHeight = 120,
  });

  final double? width;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerLoader(
            width: double.infinity,
            height: imageHeight,
            borderRadius: 16,
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(10, 12, 10, 0),
            child: ShimmerLoader(width: 90, height: 12, borderRadius: 6),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(10, 8, 10, 0),
            child: ShimmerLoader(width: 60, height: 12, borderRadius: 6),
          ),
        ],
      ),
    );
  }
}

/// Grid of product skeletons (product list).
class ProductGridSkeleton extends StatelessWidget {
  const ProductGridSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.78,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => const ProductCardSkeleton(),
    );
  }
}

/// Grid of category skeletons.
class CategoryGridSkeleton extends StatelessWidget {
  const CategoryGridSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.85,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => const ShimmerLoader(
        width: double.infinity,
        height: double.infinity,
        borderRadius: 16,
      ),
    );
  }
}

/// Flash sale row skeleton for the home screen.
class FlashSaleSkeleton extends StatelessWidget {
  const FlashSaleSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                'Flash Sale',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 230,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) => const SizedBox(
              width: 160,
              child: ProductCardSkeleton(imageHeight: 130),
            ),
          ),
        ),
      ],
    );
  }
}
