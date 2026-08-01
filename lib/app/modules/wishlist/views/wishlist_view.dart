import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/product_model.dart';
import '../../../routes/app_pages.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/custom_bottom_navbar.dart';
import '../../cart/controllers/cart_controller.dart';
import '../controllers/wishlist_controller.dart';

class WishlistView extends GetView<WishlistController> {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Wishlist",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      bottomNavigationBar: const CustomBottomNavbar(currentIndex: 3),

      body: Obx(() {
        if (controller.wishlist.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.4),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_border_rounded,
                      size: 70,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    "Wishlist Masih Kosong",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Produk favorit yang kamu simpan\nakan muncul di sini.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: 190,
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        Get.offAllNamed(Routes.CATEGORY);
                      },
                      icon: const Icon(Icons.storefront_rounded),
                      label: const Text(
                        "Mulai Belanja",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: controller.wishlist.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: .68,
          ),
          itemBuilder: (context, index) {
            final ProductModel product = controller.wishlist[index];

            return InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {
                Get.toNamed(Routes.DETAIL_PRODUCT, arguments: product);
              },
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Expanded(
                        child: Hero(
                          tag: product.id,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              product.image,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }

                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                              errorBuilder: (_, __, ___) {
                                return Container(
                                  color: Colors.grey.shade200,
                                  child: const Center(
                                    child: Icon(
                                      Icons.image_not_supported,
                                      size: 45,
                                      color: Colors.grey,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        cartController.formatPrice(product.price),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text(product.rating.toString()),
                        ],
                      ),

                      const SizedBox(height: 8),

                      SizedBox(
                        width: double.infinity,
                        height: 36,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            controller.toggleWishlist(product);
                          },
                          icon: const Icon(Icons.favorite, size: 18),
                          label: const Text("Hapus"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
