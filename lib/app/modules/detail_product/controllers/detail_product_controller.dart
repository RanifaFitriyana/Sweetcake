import 'package:get/get.dart';

class DetailProductController extends GetxController {
  RxInt quantity = 1.obs;

  void increase() {
    quantity++;
  }

  void decrease() {
    if (quantity > 1) {
      quantity--;
    }
  }
}