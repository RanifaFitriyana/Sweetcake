import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/product_model.dart';
import '../../../data/services/product_service.dart';

class CategoryController extends GetxController {
  /// Loading
  RxBool isLoading = false.obs;

  /// Search
  final TextEditingController searchController = TextEditingController();

  /// Semua produk dari API
  RxList<ProductModel> allProducts = <ProductModel>[].obs;

  /// Produk yang ditampilkan
  RxList<ProductModel> products = <ProductModel>[].obs;

  /// Index kategori aktif
  RxInt selectedCategory = 0.obs;

  final List<String> categories = [
    "Semua",
    "Kue Ulang Tahun",
    "Cupcake",
    "Roti",
    "Cookies",
  ];

  @override
  void onInit() {
    super.onInit();

    fetchProducts();

    searchController.addListener(() {
      filterProducts();
    });
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;

      final result = await ProductService.getProducts();

      allProducts.assignAll(result);

      filterProducts();
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil produk");
    } finally {
      isLoading.value = false;
    }
  }

  void changeCategory(int index) {
    selectedCategory.value = index;
    filterProducts();
    update();
  }

  void filterProducts() {
    List<ProductModel> temp = List.from(allProducts);

    /// Filter kategori
    if (selectedCategory.value != 0) {
      temp = temp.where((product) {
        return product.category.toLowerCase() ==
            categories[selectedCategory.value].toLowerCase();
      }).toList();
    }

    /// Filter search
    final keyword = searchController.text.trim().toLowerCase();

    if (keyword.isNotEmpty) {
      temp = temp.where((product) {
        return product.name.toLowerCase().contains(keyword);
      }).toList();
    }

    products.assignAll(temp);
  }

  Future<void> refreshProducts() async {
    await fetchProducts();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
