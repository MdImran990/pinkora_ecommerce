import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/category_chip_row.dart';
import '../widgets/flash_sale_section.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/routes/app_routes.dart';
import '../../notifications/controllers/notification_controller.dart';
import '../../../widgets/skeletons.dart';
import '../../../core/services/location_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: CustomScrollView(
          keyboardDismissBehavior:
          ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            // ── APP BAR ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () =>
                            Get.find<LocationController>().handleTap(),
                        child: Obx(
                              () {
                            final location =
                            Get.find<LocationController>();
                            final loading = location.status.value ==
                                LocationStatus.loading;

                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.location_on_rounded,
                                  color: AppColors.primary,
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    location.label.value,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 2),
                                if (loading)
                                  const SizedBox(
                                    width: 12,
                                    height: 12,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.primary,
                                    ),
                                  )
                                else
                                  const Icon(
                                    Icons.refresh_rounded,
                                    color: AppColors.grey,
                                    size: 15,
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Get.toNamed(AppRoutes.notifications),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const SizedBox(
                            width: 38,
                            height: 38,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                border: Border.fromBorderSide(
                                  BorderSide(
                                    color: AppColors.border,
                                  ),
                                ),
                              ),
                              child: Icon(
                                Icons.notifications_outlined,
                                color: AppColors.black,
                                size: 20,
                              ),
                            ),
                          ),
                          Positioned(
                            right: -2,
                            top: -2,
                            child: Obx(
                                  () {
                                final unread = Get.find<NotificationController>()
                                    .unreadCount;

                                if (unread == 0) {
                                  return const SizedBox.shrink();
                                }

                                return Container(
                                  constraints: const BoxConstraints(
                                    minWidth: 16,
                                    minHeight: 16,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.sale,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    unread > 9 ? '9+' : '$unread',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── SEARCH BAR ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Get.toNamed(
                    AppRoutes.productList,
                    arguments: {'focusSearch': true},
                  ),
                  child: const SizedBox(
                    height: 48,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(14),
                        ),
                        border: Border.fromBorderSide(
                          BorderSide(
                            color: AppColors.border,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 14),
                          Icon(
                            Icons.search_rounded,
                            color: AppColors.grey,
                            size: 22,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Search products...',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.grey,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(6),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(6),
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  color: AppColors.primary,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── BANNER ──
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 16),
                child: RepaintBoundary(
                  child: BannerCarousel(),
                ),
              ),
            ),

            // ── CATEGORIES ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: GetBuilder<HomeController>(
                  builder: (ctrl) {
                    return CategoryChipRow(
                      categories: ctrl.categories,
                    );
                  },
                ),
              ),
            ),

            // ── FLASH SALE ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: GetBuilder<HomeController>(
                  builder: (ctrl) {
                    if (ctrl.isLoading) {
                      return const FlashSaleSkeleton();
                    }

                    return FlashSaleSection(
                      products: ctrl.flashSaleProducts,
                      onSeeAll: () => Get.toNamed(
                        AppRoutes.productList,
                        arguments: {'flashSale': true},
                      ),
                    );
                  },
                ),
              ),
            ),

            // ── BOTTOM SPACE ──
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
    );
  }
}