import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';

class SplashController extends GetxController {
  bool _isNavigating = false;

  @override
  void onReady() {
    super.onReady();
    _startNavigation();
  }

  Future<void> _startNavigation() async {
    if (_isNavigating) return;

    _isNavigating = true;

    await Future.delayed(
      const Duration(milliseconds: 2200),
    );

    if (isClosed) return;

    Get.offAllNamed(AppRoutes.login);
  }
}