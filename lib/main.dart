import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const PinkoraApp());
}

class PinkoraApp extends StatelessWidget {
  const PinkoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),

      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,

          title: 'Pinkora',

          theme: AppTheme.lightTheme,

          initialRoute: AppPages.initial,

          getPages: AppPages.routes,
        );
      },
    );
  }
}