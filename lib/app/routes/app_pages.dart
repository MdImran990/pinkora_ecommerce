import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/model/product_model.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/routes/app_routes.dart';
import '../../modules/splash/bindings/splash_binding.dart';
import '../../modules/splash/views/splash_screen.dart';
import '../../modules/auth/bindings/auth_binding.dart';
import '../../modules/auth/views/login_screen.dart';
import '../../modules/auth/views/register_screen.dart';
import '../../modules/auth/views/forgot_password_screen.dart';
import '../../modules/home/bindings/home_binding.dart';
import '../../modules/home/views/home_screen.dart';
import '../../modules/category/bindings/category_binding.dart';
import '../../modules/category/views/category_screen.dart';
import '../../modules/product/bindings/product_binding.dart';
import '../../modules/product/views/product_detail_screen.dart';
import '../../modules/product/views/product_list_screen.dart';
import '../../modules/cart/bindings/cart_binding.dart';
import '../../modules/cart/views/cart_screen.dart';
import '../../modules/checkout/bindings/checkout_binding.dart';
import '../../modules/checkout/views/checkout_screen.dart';
import '../../modules/wishlist/bindings/wishlist_binding.dart';
import '../../modules/wishlist/views/wishlist_screen.dart';
import '../../modules/profile/bindings/profile_binding.dart';
import '../../modules/profile/views/profile_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.category,
      page: () => const CategoryScreen(),
      binding: CategoryBinding(),
    ),
    GetPage(
      name: AppRoutes.productList,
      page: () => const ProductListScreen(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: AppRoutes.productDetail,
      page: () => const ProductDetailScreen(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: AppRoutes.cart,
      page: () => const CartScreen(),
      binding: CartBinding(),
    ),
    GetPage(
      name: AppRoutes.checkout,
      page: () => const CheckoutScreen(),
      binding: CheckoutBinding(),
    ),
    GetPage(
      name: AppRoutes.wishlist,
      page: () => const WishlistScreen(),
      binding: WishlistBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileScreen(),
      binding: ProfileBinding(),
    ),
  ];
}