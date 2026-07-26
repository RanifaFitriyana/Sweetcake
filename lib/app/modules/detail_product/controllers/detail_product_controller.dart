import 'package:get/get.dart';

class DetailProductController extends GetxController {
  RxInt quantity = 1.obs;

  RxString selectedSize = "18 cm".obs;

  final sizes = [
    "18 cm",
    "20 cm",
    "22 cm",
  ];

  void increase() {
    quantity++;
  }

  void decrease() {
    if (quantity > 1) {
      quantity--;
    }
  }

  void selectSize(String size) {
    selectedSize.value = size;
  }
}