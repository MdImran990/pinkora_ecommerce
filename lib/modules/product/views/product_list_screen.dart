import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/routes/app_routes.dart';
import '../../../data/model/product_model.dart';
import '../../../widgets/bottom_nav_bar.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        title: const Text(
          'All Products',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.68,
        ),
        itemCount: products.length,
        itemBuilder: (_, i) {
          final p = products[i];
          return GestureDetector(
            onTap: () => Get.toNamed(
                AppRoutes.productDetail,
                arguments: p),
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
                children: [
                  // Image
                  Stack(
                    children: [
                      Container(
                        height: 130,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16)),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.shopping_bag_outlined,
                            size: 64,
                            color: AppColors.primary
                                .withValues(alpha: 0.35),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8, left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.sale,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '-${p.discountPercent}%',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8, right: 8,
                        child: Container(
                          width: 30, height: 30,
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
                          child: const Icon(
                            Icons.favorite_border_rounded,
                            size: 16,
                            color: AppColors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Info
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '৳ ${p.price.toInt()}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '৳ ${p.originalPrice.toInt()}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                color: AppColors.star, size: 13),
                            const SizedBox(width: 2),
                            Text(
                              '${p.rating}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.grey,
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