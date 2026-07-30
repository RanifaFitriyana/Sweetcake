import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/modules/cart/controllers/cart_controller.dart';
import 'app/modules/wishlist/controllers/wishlist_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  /// Inisialisasi locale Indonesia
  await initializeDateFormatting('id_ID', null);

  Get.put<CartController>(CartController(), permanent: true);

  Get.put<WishlistController>(WishlistController(), permanent: true);

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
