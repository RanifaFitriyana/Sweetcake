import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  final box = GetStorage();

  final RxString name = "".obs;
  final RxString email = "".obs;
  final RxString phone = "".obs;

  @override
  void onInit() {
    super.onInit();

    name.value = box.read("name") ?? "Guest";
    email.value = box.read("email") ?? "-";
    phone.value = box.read("phone") ?? "-";
  }

  void logout() {
    box.erase();

    Get.offAllNamed(Routes.LOGIN);
  }
}
