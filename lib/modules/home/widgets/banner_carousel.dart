import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../controllers/home_controller.dart';
import '../../../app/theme/app_colors.dart';

class BannerCarousel extends GetView<HomeController> {
  const BannerCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final banners = [
      {'title': 'Big Sale',     'sub': 'Up to 70% OFF', 'btn': 'Shop Now'},
      {'title': 'New Arrivals', 'sub': 'Fresh Styles',  'btn': 'Explore'},
      {'title': 'Flash Deal',   'sub': 'Limited Time',  'btn': 'Grab Now'},
    ];

    return Column(
      children: [
        SizedBox(
          height: 160,
          child: Swiper(
            itemCount: banners.length,
            autoplay: true,
            autoplayDelay: 3000,
            onIndexChanged: (i) => controller.changeBannerIndex(i),
            itemBuilder: (_, i) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE91E8C), Color(0xFFFF6BB3)],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -20, bottom: -20,
                      child: Container(
                        width: 160, height: 160,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 20, bottom: -40,
                      child: Container(
                        width: 120, height: 120,
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
                          Text(banners[i]['title']!,
                              style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white)),
                          const SizedBox(height: 4),
                          Text(banners[i]['sub']!,
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70)),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(banners[i]['btn']!,
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 10),

        Obx(() => AnimatedSmoothIndicator(
          activeIndex: controller.bannerIndex.value,
          count: banners.length,
          effect: ExpandingDotsEffect(
            dotHeight: 6,
            dotWidth: 6,
            activeDotColor: AppColors.primary,
            dotColor: AppColors.primaryLight,
          ),
        )),
      ],
    );
  }
}