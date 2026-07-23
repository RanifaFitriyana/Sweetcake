import 'package:get/get.dart';

class CategoryController extends GetxController {
  var selectedCategory = 0.obs;

  final categories = [
    "Semua",
    "Ulang Tahun",
    "Roti",
    "Cupcake",
    "Cookies",
  ];

  void changeCategory(int index) {
    selectedCategory.value = index;
  }
}