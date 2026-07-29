import 'package:get/get.dart';

import '../controllers/upload_payment_controller.dart';

class UploadPaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UploadPaymentController>(
      () => UploadPaymentController(),
    );
  }
}