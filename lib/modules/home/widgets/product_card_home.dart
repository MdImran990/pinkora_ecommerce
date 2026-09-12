import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/routes/app_routes.dart';
import '../../../data/model/product_model.dart';
import '../../../modules/cart/controllers/cart_controller.dart';
import '../../../modules/wishlist/controllers/wishlist_controller.dart';

class ProductCardHome extends StatelessWidget {
  final ProductModel product;

  const ProductCardHome({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cartCtrl = Get.find<CartController>();
    final wishCtrl = Get.find<WishlistController>();

    return GestureDetector(
      onTap: () =>
          Get.toNamed(AppRoutes.productDetail, arguments: product),
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 130,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16)),
                  ),
                  child: Center(
                    child: Icon(Icons.shopping_bag_outlined,
                        size: 60,
                        color:
                        AppColors.primary.withValues(alpha: 0.4)),
                  ),
                ),
                Positioned(
                  top: 8, left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        color: AppColors.sale,
                        borderRadius: BorderRadius.circular(8)),
                    child: Text('-${product.discountPercent}%',
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                  ),
                ),
                Positioned(
                  top: 8, right: 8,
                  child: Obx(() {
                    final isWished = wishCtrl.isWished(product.id);
                    return GestureDetector(
                      onTap: () {
                        if (isWished) {
                          wishCtrl.removeItem(product);
                        } else {
                          wishCtrl.addItem(product);
                        }
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Icon(
                          isWished
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size: 16,
                          color: isWished
                              ? AppColors.primary
                              : AppColors.grey,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text('৳ ${product.price.toInt()}',
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary)),
                      const SizedBox(width: 6),
                      Text('৳ ${product.originalPrice.toInt()}',
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.grey,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: AppColors.grey)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              color: AppColors.star, size: 14),
                          const SizedBox(width: 2),
                          Text(
                              '${product.rating} (${product.reviewCount})',
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.grey)),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          cartCtrl.addToCart(product);
                          Get.snackbar(
                            'Added! 🛒',
                            '${product.name} added to cart',
                            backgroundColor: AppColors.primary,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.TOP,
                            borderRadius: 12,
                            margin: const EdgeInsets.all(16),
                            duration: const Duration(seconds: 1),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                              Icons.add_shopping_cart_rounded,
                              size: 16,
                              color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}