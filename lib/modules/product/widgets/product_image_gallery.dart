import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../../../app/theme/app_colors.dart';

class ProductImageGallery extends GetView<ProductController> {
  const ProductImageGallery({super.key});

  @override
  Widget build(BuildContext context) {
    final thumbColors = [
      AppColors.primaryLight,
      const Color(0xFFE8E8E8),
      const Color(0xFFF5ECD7),
      const Color(0xFFF0EEE8),
    ];

    return Column(
      children: [
        // Main image
        Obx(() => Container(
          height: 280,
          width: double.infinity,
          color: AppColors.primaryLight,
          child: Stack(
            children: [
              Center(
                child: Icon(
                  Icons.shopping_bag_rounded,
                  size: 140,
                  color: AppColors.primary.withOpacity(0.3),
                ),
              ),
              // Discount badge
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.sale,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${controller.product.value?.discountPercent ?? 0}% OFF',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )),

        const SizedBox(height: 12),

        // Thumbnails
        SizedBox(
          height: 60,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 4,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              return Obx(() {
                final isSelected =
                    controller.currentImageIndex.value == i;
                return GestureDetector(
                  onTap: () => controller.changeImage(i),
                  child: Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: thumbColors[i % thumbColors.length],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.border,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      size: 28,
                      color: AppColors.primary.withOpacity(0.4),
                    ),
                  ),
                );
              });
            },
          ),
        ),
      ],
    );
  }
}