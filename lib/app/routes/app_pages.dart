import 'package:get/get.dart';

import '../../modules/splash/bindings/splash_binding.dart';
import '../../modules/splash/views/splash_screen.dart';

import '../../modules/auth/bindings/auth_binding.dart';
import '../../modules/auth/views/login_screen.dart';
import '../../modules/auth/views/register_screen.dart';
import '../../modules/auth/views/forgot_password_screen.dart';

import '../../modules/product/bindings/product_binding.dart';
import '../../modules/product/views/product_detail_screen.dart';
import '../../modules/product/views/product_list_screen.dart';

import '../../modules/checkout/bindings/checkout_binding.dart';
import '../../modules/checkout/views/checkout_screen.dart';



import '../../modules/orders/views/orders_screen.dart';
import '../../modules/orders/views/order_detail_screen.dart';
import '../../modules/orders/views/order_success_screen.dart';

import '../../modules/address/views/address_screen.dart';
import '../../modules/address/views/address_form_screen.dart';

import '../../modules/payment/views/payment_methods_screen.dart';
import '../../modules/notifications/views/notifications_screen.dart';
import '../../modules/help/views/help_screen.dart';

import '../../modules/settings/views/settings_screen.dart';
import '../../modules/settings/views/edit_profile_screen.dart';

import '../../modules/main/views/main_shell.dart';

import 'app_routes.dart';

class AppPages {
  static final pages = [
    // =========================
    // SPLASH
    // =========================
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
      transition: Transition.fadeIn,
    ),

    // =========================
    // LOGIN
    // =========================
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
    ),

    // =========================
    // REGISTER
    // =========================
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterScreen(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
    ),

    // =========================
    // FORGOT PASSWORD
    // =========================
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
    ),

    // =========================
    // HOME
    // =========================
    GetPage(
      name: AppRoutes.home,
      page: () => const MainShell(initialIndex: 0),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 180),
    ),

    // =========================
    // CATEGORY
    // =========================
    GetPage(
      name: AppRoutes.category,
      page: () => const MainShell(initialIndex: 1),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 180),
    ),

    // =========================
    // PRODUCT LIST
    // =========================
    GetPage(
      name: AppRoutes.productList,
      page: () => const ProductListScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 180),
    ),

    // =========================
    // PRODUCT DETAIL
    // =========================
    GetPage(
      name: AppRoutes.productDetail,
      page: () => const ProductDetailScreen(),
      binding: ProductBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 180),
    ),

    // =========================
    // CART
    // =========================
    GetPage(
      name: AppRoutes.cart,
      page: () => const MainShell(initialIndex: 2),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 180),
    ),

    // =========================
    // CHECKOUT
    // =========================
    GetPage(
      name: AppRoutes.checkout,
      page: () => const CheckoutScreen(),
      binding: CheckoutBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 180),
    ),

    // =========================
    // WISHLIST
    // =========================
    GetPage(
      name: AppRoutes.wishlist,
      page: () => const MainShell(initialIndex: 3),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 180),
    ),

    // =========================
    // PROFILE
    // =========================
    GetPage(
      name: AppRoutes.profile,
      page: () => const MainShell(initialIndex: 4),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 180),
    ),

    // =========================
    // ORDERS
    // =========================
    GetPage(
      name: AppRoutes.orders,
      page: () => const OrdersScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 180),
    ),

    // =========================
    // ORDER DETAIL
    // =========================
    GetPage(
      name: AppRoutes.orderDetail,
      page: () => const OrderDetailScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 180),
    ),

    // =========================
    // ORDER SUCCESS
    // =========================
    GetPage(
      name: AppRoutes.orderSuccess,
      page: () => const OrderSuccessScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 180),
    ),

    // =========================
    // ADDRESSES
    // =========================
    GetPage(
      name: AppRoutes.addresses,
      page: () => const AddressScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 180),
    ),

    // =========================
    // ADDRESS FORM
    // =========================
    GetPage(
      name: AppRoutes.addressForm,
      page: () => const AddressFormScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 180),
    ),

    // =========================
    // PAYMENT METHODS
    // =========================
    GetPage(
      name: AppRoutes.paymentMethods,
      page: () => const PaymentMethodsScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 180),
    ),

    // =========================
    // NOTIFICATIONS
    // =========================
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 180),
    ),

    // =========================
    // HELP & SUPPORT
    // =========================
    GetPage(
      name: AppRoutes.help,
      page: () => const HelpScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 180),
    ),

    // =========================
    // SETTINGS
    // =========================
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 180),
    ),

    // =========================
    // EDIT PROFILE
    // =========================
    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfileScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 180),
    ),
  ];
}