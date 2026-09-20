import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app/theme/app_colors.dart';

/// Standard app bar used by the inner screens (back button + centered title).
PreferredSizeWidget pinkoraAppBar(
    String title, {
      List<Widget>? actions,
    }) {
  return AppBar(
    backgroundColor: AppColors.scaffoldBg,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: true,
    leading: const _AppBarBackButton(),
    title: Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.black,
      ),
    ),
    actions: actions,
  );
}

class _AppBarBackButton extends StatelessWidget {
  const _AppBarBackButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: Get.back,
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.border,
          ),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 16,
          color: AppColors.black,
        ),
      ),
    );
  }
}
