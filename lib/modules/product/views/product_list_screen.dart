import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/routes/app_routes.dart';
import '../../../data/model/product_model.dart';
import '../../../modules/cart/controllers/cart_controller.dart';
import '../../../modules/wishlist/controllers/wishlist_controller.dart';
import '../../../widgets/bottom_nav_bar.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartCtrl = Get.find<CartController>();
    final wishCtrl = Get.find<WishlistController>();

    final products = [
      ProductModel(
        id: '1', name: 'Trendy Handbag', image: '',
        price: 2100, originalPrice: 3000, discountPercent: 30,
        rating: 4.8, reviewCount: 120, category: 'Fashion',
        colors: ['#FF6B9D', '#000000'],
      ),
      ProductModel(
        id: '2', name: 'Sport Shoes', image: '',
        price: 3200, originalPrice: 4300, discountPercent: 25,
        rating: 4.6, reviewCount: 98, category: 'Shoes',
      ),
      ProductModel(
        id: '3', name: 'Smart Watch', image: '',
        price: 4500, originalPrice: 7500, discountPercent: 40,
        rating: 4.7, reviewCount: 86, category: 'Watches',
      ),
      ProductModel(
        id: '4', name: 'Lipstick Set', image: '',
        price: 850, originalPrice: 1200, discountPercent: 29,
        rating: 4.5, reviewCount: 210, category: 'Beauty',
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 16, color: AppColors.black),
          ),
        ),
        title: const Text('All Products',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.black)),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.78,
        ),
        itemCount: products.length,
        itemBuilder: (_, i) {
          final p = products[i];
          return GestureDetector(
            onTap: () =>
                Get.toNamed(AppRoutes.productDetail, arguments: p),
            child: Container(
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Image ──
                  Stack(
                    children: [
                      Container(
                        height: 120,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16)),
                        ),
                        child: Center(
                          child: Icon(Icons.shopping_bag_outlined,
                              size: 56,
                              color: AppColors.primary
                                  .withValues(alpha: 0.35)),
                        ),
                      ),
                      // Discount
                      Positioned(
                        top: 8, left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.sale,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text('-${p.discountPercent}%',
                              style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                        ),
                      ),
                      // Wishlist
                      Positioned(
                        top: 6, right: 6,
                        child: Obx(() {
                          final isWished = wishCtrl.wishlistItems
                              .any((e) => e.id == p.id);
                          return GestureDetector(
                            onTap: () {
                              if (isWished) {
                                wishCtrl.wishlistItems
                                    .removeWhere((e) => e.id == p.id);
                              } else {
                                wishCtrl.wishlistItems.add(p);
                              }
                            },
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withValues(alpha: 0.08),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Icon(
                                isWished
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                size: 14,
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

                  // ── Info ──
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(p.name,
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.black),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Text('৳ ${p.price.toInt()}',
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary)),
                            const SizedBox(width: 4),
                            Text('৳ ${p.originalPrice.toInt()}',
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.grey,
                                    decoration:
                                    TextDecoration.lineThrough,
                                    decorationColor: AppColors.grey)),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.star_rounded,
                                    color: AppColors.star, size: 12),
                                const SizedBox(width: 2),
                                Text('${p.rating}',
                                    style: const TextStyle(
                                        fontSize: 10,
                                        color: AppColors.grey)),
                              ],
                            ),
                            // Add to Cart
                            GestureDetector(
                              onTap: () {
                                cartCtrl.addToCart(p);
                                Get.snackbar(
                                  'Added! 🛒',
                                  '${p.name} added to cart',
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
                                  borderRadius:
                                  BorderRadius.circular(6),
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
        },
      ),
      bottomNavigationBar: const PinkoraBottomNav(),
    );
  }
}