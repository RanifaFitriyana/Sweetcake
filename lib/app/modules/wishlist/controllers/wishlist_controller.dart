import 'package:get/get.dart';

import '../../../data/models/product_model.dart';

class WishlistController extends GetxController {
  final RxList<ProductModel> wishlist = <ProductModel>[].obs;

  bool isFavorite(String id) {
    return wishlist.any((item) => item.id == id);
  }

  void toggleWishlist(ProductModel product) {
    final index = wishlist.indexWhere((item) => item.id == product.id);

    if (index != -1) {
      wishlist.removeAt(index);

      Get.snackbar("Wishlist", "${product.name} dihapus dari wishlist");
    } else {
      wishlist.add(product);

      Get.snackbar("Wishlist", "${product.name} ditambahkan ke wishlist");
    }
  }
}
