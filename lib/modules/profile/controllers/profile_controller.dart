import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../data/model/user_model.dart';

class ProfileController extends GetxController {
  final user = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    loadUser();
  }

  void loadUser() {
    user.value = UserModel(
      id: '1',
      name: 'Imran Hossain',
      email: 'imran@gmail.com',
      phone: '01700000000',
      address: 'House 12, Road 5, Dhanmondi, Dhaka, 1205',
    );
  }

  void logout() {
    Get.defaultDialog(
      title: 'Logout',
      middleText: 'Are you sure you want to logout?',
      textConfirm: 'Logout',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.primary,
      onConfirm: () {
        final box = GetStorage();
        box.write('isLoggedIn', false);
        Get.offAllNamed(AppRoutes.login);
      },
    );
  }
}