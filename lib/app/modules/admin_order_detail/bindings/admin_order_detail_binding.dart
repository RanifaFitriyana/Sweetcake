import 'package:get/get.dart';

import '../controllers/admin_order_detail_controller.dart';

class AdminOrderDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminOrderDetailController>(
      () => AdminOrderDetailController(),
    );
  }
}
