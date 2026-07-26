import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  /// ==========================
  /// DATA USER
  /// ==========================
  final RxString name = "Ranifa Fitriyana".obs;
  final RxString email = "ranifa@gmail.com".obs;

  /// ==========================
  /// LOGOUT
  /// ==========================
  void logout() {
    Get.offAllNamed(Routes.LOGIN);
  }
}
