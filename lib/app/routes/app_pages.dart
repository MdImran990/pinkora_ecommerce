import 'package:get/get.dart';

import '../../modules/splash/views/splash_screen.dart';

class AppPages {
  static const initial = '/splash';

  static final routes = [
    GetPage(
      name: initial,
      page: () => const SplashScreen(),
    ),
  ];
}