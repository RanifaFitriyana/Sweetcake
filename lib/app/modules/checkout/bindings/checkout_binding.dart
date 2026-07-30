import 'package:get/get.dart';

import '../controllers/checkout_controller.dart';
import '../../address/controllers/address_controller.dart';

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddressController>(() => AddressController());

    Get.lazyPut<CheckoutController>(() => CheckoutController());
  }
}
