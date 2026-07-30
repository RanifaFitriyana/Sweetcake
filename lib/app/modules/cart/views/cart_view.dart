import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/app_colors.dart';
import '../controllers/cart_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/custom_bottom_navbar.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        title: const Text(
          "Keranjang Belanja",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),

        iconTheme: const IconThemeData(color: Colors.black),
      ),

      bottomNavigationBar: const CustomBottomNavbar(currentIndex: 2),

      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                const Icon(
                  Icons.shopping_cart_outlined,
                  size: 75,
                  color: Colors.grey,
                ),

                const SizedBox(height: 15),

                const Text(
                  "Keranjang masih kosong",

                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Yuk mulai belanja sekarang!",

                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,

                    foregroundColor: Colors.white,
                  ),

                  onPressed: () {
                    Get.offAllNamed(Routes.HOME);
                  },

                  child: const Text(
                    "Belanja Sekarang",

                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),

                itemCount: controller.cartItems.length,

                itemBuilder: (context, index) {
                  final item = controller.cartItems[index];

                  return cartItem(item, index);
                },
              ),
            ),

            Container(
              padding: const EdgeInsets.all(20),

              decoration: const BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),

              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Subtotal (${controller.totalItems} Produk)",

                        style: const TextStyle(fontSize: 13),
                      ),

                      const Spacer(),

                      Text(
                        controller.formatPrice(controller.subtotal),

                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Text("Ongkir", style: TextStyle(fontSize: 13)),

                      const Spacer(),

                      Text(
                        controller.formatPrice(controller.shippingCost),

                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),

                  const Divider(height: 25),

                  Row(
                    children: [
                      const Text(
                        "Total",

                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Spacer(),

                      Text(
                        controller.formatPrice(controller.total),

                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,

                    height: 55,

                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,

                        foregroundColor: Colors.white,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),

                      onPressed: () {
                        Get.toNamed(Routes.CHECKOUT);
                      },

                      child: const Text(
                        "Checkout",

                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget cartItem(Map<String, dynamic> item, int index) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.DETAIL_PRODUCT, arguments: item);
      },

      child: Card(
        margin: const EdgeInsets.only(bottom: 15),

        elevation: 2,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),

        child: Padding(
          padding: const EdgeInsets.all(12),

          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),

                child: Image.network(
                  item["image"],

                  width: 80,

                  height: 80,

                  fit: BoxFit.cover,

                  errorBuilder: (_, __, ___) {
                    return Container(
                      width: 80,

                      height: 80,

                      color: Colors.grey.shade200,

                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      item["name"],

                      maxLines: 2,

                      overflow: TextOverflow.ellipsis,

                      style: const TextStyle(
                        fontWeight: FontWeight.bold,

                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      controller.formatPrice(item["price"]),

                      style: const TextStyle(
                        color: AppColors.primary,

                        fontWeight: FontWeight.bold,

                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),

                  borderRadius: BorderRadius.circular(10),
                ),

                child: Row(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 18),

                      onPressed: () {
                        controller.decreaseQty(index);
                      },
                    ),

                    Text(
                      "${item["qty"]}",

                      style: const TextStyle(
                        fontWeight: FontWeight.bold,

                        fontSize: 14,
                      ),
                    ),

                    IconButton(
                      icon: const Icon(Icons.add, size: 18),

                      onPressed: () {
                        controller.increaseQty(index);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
