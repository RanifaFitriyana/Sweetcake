import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/app_colors.dart';
import '../controllers/detail_product_controller.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../wishlist/controllers/wishlist_controller.dart';
import '../../../data/models/product_model.dart';

class DetailProductView extends GetView<DetailProductController> {
  const DetailProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductModel product = Get.arguments as ProductModel;

    final WishlistController wishlistController =
        Get.find<WishlistController>();

    final CartController cartController = Get.find<CartController>();

    return Scaffold(
      backgroundColor: AppColors.background,

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),

              onPressed: () {
                cartController.addToCart({
                  "id": product.id,
                  "name": product.name,
                  "image": product.image,
                  "price": product.price,
                  "rating": product.rating,
                  "description": product.description,
                  "category": product.category,
                  "qty": controller.quantity.value,
                });

                Get.dialog(
                  Center(
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        width: 260,
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.green,
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),

                            SizedBox(height: 18),

                            Text(
                              "Berhasil!",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 10),

                            Text(
                              "Produk berhasil ditambahkan\nke keranjang.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  barrierDismissible: false,
                );

                Future.delayed(const Duration(milliseconds: 1500), () {
                  if (Get.isDialogOpen ?? false) {
                    Get.back();
                  }
                });
              },

              child: const Text(
                "Tambah ke Keranjang",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: ListView(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),

                  child: Hero(
                    tag: product.id,

                    child: Image.network(
                      product.image,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,

                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),

                Positioned(
                  top: 15,
                  left: 15,

                  child: CircleAvatar(
                    backgroundColor: Colors.white,

                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),

                      onPressed: () => Get.back(),
                    ),
                  ),
                ),

                Positioned(
                  top: 15,
                  right: 15,

                  child: CircleAvatar(
                    backgroundColor: Colors.white,

                    child: Obx(() {
                      final isFavorite = wishlistController.isFavorite(
                        product.id,
                      );

                      return IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,

                          color: isFavorite ? Colors.red : Colors.black,
                        ),

                        onPressed: () {
                          wishlistController.toggleWishlist(product);
                        },
                      );
                    }),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    product.name,

                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Text(
                        cartController.formatPrice(product.price),

                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),

                      const Spacer(),

                      const Icon(Icons.star, color: Colors.amber, size: 20),

                      const SizedBox(width: 5),

                      Text(
                        product.rating.toString(),

                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Deskripsi",

                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    product.description,

                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Jumlah",

                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),

                  const SizedBox(height: 12),

                  Obx(
                    () => Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),

                            borderRadius: BorderRadius.circular(10),
                          ),

                          child: IconButton(
                            icon: const Icon(Icons.remove),

                            onPressed: controller.decrease,
                          ),
                        ),

                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),

                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 10,
                          ),

                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),

                            borderRadius: BorderRadius.circular(10),
                          ),

                          child: Text(
                            controller.quantity.value.toString(),

                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),

                            borderRadius: BorderRadius.circular(10),
                          ),

                          child: IconButton(
                            icon: const Icon(Icons.add),

                            onPressed: controller.increase,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
