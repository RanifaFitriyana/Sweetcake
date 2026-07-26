import 'package:get/get.dart';

class CategoryController extends GetxController {
  int selectedCategory = 0;

  final List<String> categories = const [
    "Semua",
    "Ulang Tahun",
    "Roti",
    "Cupcake",
    "Cookies",
  ];

  /// nanti akan diisi dari API
  final List<Map<String, dynamic>> products = [];

  void changeCategory(int index) {
    if (selectedCategory == index) return;

    selectedCategory = index;
    update();
  }
}
