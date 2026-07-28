import 'package:get/get.dart';

import '../../../data/models/product_model.dart';
import '../../../data/services/product_service.dart';

class HomeController extends GetxController {
  /// Loading
  RxBool isLoading = false.obs;

  /// List Produk
  RxList<ProductModel> products = <ProductModel>[].obs;
  RxList<ProductModel> bestProducts = <ProductModel>[].obs;

  /// Bottom Navigation
  RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    fetchBestProducts();
  }

  void changeIndex(int index) {
    currentIndex.value = index;
  }

  /// ==========================
  /// GET PRODUCTS
  /// ==========================
  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;

      final result = await ProductService.getProducts();

      products.assignAll(result);
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil data produk");

      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchBestProducts() async {
    try {
      final result = await ProductService.getBestProducts();
      bestProducts.assignAll(result);
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil produk terlaris");
    }
  }

  /// ==========================
  /// REFRESH
  /// ==========================
  Future<void> refreshProducts() async {
    await fetchProducts();
  }
}
