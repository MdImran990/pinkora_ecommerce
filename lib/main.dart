import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/theme/app_theme.dart';
import 'data/providers/dio_provider.dart';
import 'data/repositories/address_repository.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/cart_repository.dart';
import 'data/repositories/notification_repository.dart';
import 'data/repositories/order_repository.dart';
import 'data/repositories/product_repository.dart';
import 'modules/address/controllers/address_controller.dart';
import 'modules/auth/controllers/auth_controller.dart';
import 'modules/cart/controllers/cart_controller.dart';
import 'modules/category/controllers/category_controller.dart';
import 'modules/home/controllers/home_controller.dart';
import 'core/services/location_controller.dart';
import 'modules/main/controllers/main_controller.dart';
import 'modules/profile/controllers/profile_controller.dart';
import 'modules/notifications/controllers/notification_controller.dart';
import 'modules/orders/controllers/orders_controller.dart';
import 'modules/wishlist/controllers/wishlist_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  await SystemChrome.setPreferredOrientations(
    const [
      DeviceOrientation.portraitUp,
    ],
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const PinkoraApp());
}

class PinkoraApp extends StatelessWidget {
  const PinkoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pinkora',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,

      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,

      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 180),

      initialBinding: AppBinding(),

      scrollBehavior: const MaterialScrollBehavior().copyWith(
        physics: const BouncingScrollPhysics(),
      ),
    );
  }
}

/// App-wide dependencies (kept alive for the whole session).
///
/// Repositories are the only place that talks to data. When the backend is
/// ready, swap the repository implementations here - screens and controllers
/// stay the same.
class AppBinding extends Bindings {
  void _putOnce<T>(T Function() create) {
    if (!Get.isRegistered<T>()) {
      Get.put<T>(create(), permanent: true);
    }
  }

  @override
  void dependencies() {
    // Repositories (must come first: controllers read them)
    _putOnce<DioProvider>(DioProvider.new);
    _putOnce<AuthRepository>(AuthRepository.new);
    _putOnce<ProductRepository>(ProductRepository.new);
    _putOnce<CartRepository>(CartRepository.new);
    _putOnce<OrderRepository>(OrderRepository.new);
    _putOnce<AddressRepository>(AddressRepository.new);
    _putOnce<NotificationRepository>(NotificationRepository.new);

    // Global controllers
    _putOnce<AuthController>(AuthController.new);
    _putOnce<CartController>(CartController.new);
    _putOnce<WishlistController>(WishlistController.new);
    _putOnce<AddressController>(AddressController.new);
    _putOnce<OrdersController>(OrdersController.new);
    _putOnce<NotificationController>(NotificationController.new);

    // Bottom-tab screens (kept alive so tabs switch instantly)
    _putOnce<MainController>(MainController.new);
    _putOnce<HomeController>(HomeController.new);
    _putOnce<LocationController>(LocationController.new);
    _putOnce<CategoryController>(CategoryController.new);
    _putOnce<ProfileController>(ProfileController.new);
  }
}
