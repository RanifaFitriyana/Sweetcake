import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/modules/cart/controllers/cart_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';

void main() {
  Get.put<CartController>(CartController(), permanent: true);

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SweetCake',
      theme: AppTheme.lightTheme,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
