import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../app/routes/app_routes.dart';

class SplashController extends GetxController {
  bool _navigated = false;

  @override
  void onReady() {
    super.onReady();
    _navigate();
  }

  Future<void> _navigate() async {
    if (_navigated) return;

    await Future.delayed(
      const Duration(milliseconds: 2200),
    );

    if (_navigated) return;

    _navigated = true;

    final box = GetStorage();

    final bool isLoggedIn =
        box.read<bool>('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}