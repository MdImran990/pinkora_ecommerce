import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/category_chip_row.dart';
import '../widgets/flash_sale_section.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/routes/app_routes.dart';
import '../../../widgets/bottom_nav_bar.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── APP BAR ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    const Icon(Icons.location_on_rounded,
                        color: AppColors.primary, size: 18),
                    const SizedBox(width: 4),
                    const Text(
                      'Dhaka, Bangladesh',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down_rounded,
                        color: AppColors.black, size: 18),
                    const Spacer(),
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(Icons.notifications_outlined,
                          color: AppColors.black, size: 20),
                    ),
                  ],
                ),
              ),
            ),

            // ── SEARCH BAR ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 14),
                      const Icon(Icons.search_rounded,
                          color: AppColors.grey, size: 22),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Search products...',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.grey,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(6),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.camera_alt_outlined,
                            color: AppColors.primary, size: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── BANNER ──
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 16),
                child: BannerCarousel(),
              ),
            ),

            // ── CATEGORIES ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: GetBuilder<HomeController>(
                  builder: (ctrl) => CategoryChipRow(
                    categories: ctrl.categories,
                  ),
                ),
              ),
            ),

            // ── FLASH SALE ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: GetBuilder<HomeController>(
                  builder: (ctrl) => FlashSaleSection(
                    products: ctrl.flashSaleProducts,
                    onSeeAll: () => Get.toNamed(AppRoutes.productList),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const PinkoraBottomNav(),
    );
  }
}