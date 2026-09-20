import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../controllers/home_controller.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/routes/app_routes.dart';

class BannerCarousel extends GetView<HomeController> {
  const BannerCarousel({super.key});

  static const List<_BannerData> _banners = [
    _BannerData(
      title: 'Big Sale',
      sub: 'Up to 70% OFF',
      button: 'Shop Now',
    ),
    _BannerData(
      title: 'New Arrivals',
      sub: 'Fresh Styles',
      button: 'Explore',
    ),
    _BannerData(
      title: 'Flash Deal',
      sub: 'Limited Time',
      button: 'Grab Now',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: Swiper(
            itemCount: _banners.length,
            autoplay: true,
            autoplayDelay: 3000,
            duration: 500,
            loop: true,
            onIndexChanged: controller.changeBannerIndex,
            itemBuilder: (context, index) {
              return RepaintBoundary(
                child: _BannerCard(
                  key: ValueKey(_banners[index].title),
                  banner: _banners[index],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Obx(
              () => AnimatedSmoothIndicator(
            activeIndex: controller.bannerIndex.value,
            count: _banners.length,
            duration: const Duration(milliseconds: 250),
            effect: const ExpandingDotsEffect(
              dotHeight: 6,
              dotWidth: 6,
              activeDotColor: AppColors.primary,
              dotColor: AppColors.primaryLight,
            ),
          ),
        ),
      ],
    );
  }
}

class _BannerData {
  final String title;
  final String sub;
  final String button;

  const _BannerData({
    required this.title,
    required this.sub,
    required this.button,
  });
}

class _BannerCard extends StatelessWidget {
  const _BannerCard({
    super.key,
    required this.banner,
  });

  final _BannerData banner;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFE91E8C),
            Color(0xFFFF6BB3),
          ],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              bottom: -20,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              right: 20,
              bottom: -40,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    banner.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    banner.sub,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 14),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Get.toNamed(
                      AppRoutes.productList,
                      arguments: {
                        'flashSale': banner.title == 'Flash Deal',
                      },
                    ),
                    child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      banner.button,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
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