import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/product_model.dart';
import '../../../routes/app_pages.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/custom_bottom_navbar.dart';
import '../../../widgets/custom_drawer.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      drawer: CustomDrawer(),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          "SweetCake",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),

      bottomNavigationBar: const CustomBottomNavbar(currentIndex: 0),

      body: RefreshIndicator(
        onRefresh: controller.refreshProducts,

        child: ListView(
          padding: const EdgeInsets.all(20),

          children: [
            /// ==========================
            /// GREETING
            /// ==========================
            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.userName.value.isEmpty
                        ? "Halo, Pelanggan 👋"
                        : "Halo, ${controller.userName.value} 👋",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    "Selamat datang di SweetCake 🍰",
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// ==========================
            /// BANNER
            /// ==========================
            Container(
              height: 170,

              decoration: BoxDecoration(
                color: const Color(0xffFFE7EB),
                borderRadius: BorderRadius.circular(20),
              ),

              child: Padding(
                padding: const EdgeInsets.all(15),

                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          const Text(
                            "Kue Lezat\nUntuk Momen\nSpesial Anda",

                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 15),

                          SizedBox(
                            width: 120,
                            height: 35,

                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,

                                foregroundColor: Colors.white,

                                elevation: 0,

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),

                              onPressed: () {
                                Get.toNamed(Routes.CATEGORY);
                              },

                              child: const Text(
                                "Belanja",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Image.asset(
                        "assets/images/cake.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// ==========================
            /// PRODUK TERLARIS
            /// ==========================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                const Text(
                  "Produk Terlaris",

                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),

                TextButton(
                  onPressed: () {
                    Get.toNamed(Routes.CATEGORY);
                  },

                  child: const Text(
                    "Lihat Semua",

                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Obx(() {
              if (controller.isLoading.value) {
                return const Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (controller.bestProducts.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(
                    child: Text(
                      "Belum ada produk",
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                );
              }

              return GridView.builder(
                shrinkWrap: true,

                physics: const NeverScrollableScrollPhysics(),

                itemCount: controller.bestProducts.length,

                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: .72,
                ),

                itemBuilder: (context, index) {
                  final ProductModel product = controller.bestProducts[index];

                  return InkWell(
                    borderRadius: BorderRadius.circular(18),

                    onTap: () {
                      Get.toNamed(Routes.DETAIL_PRODUCT, arguments: product);
                    },

                    child: productCard(product),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  /// ==========================
  /// CATEGORY
  /// ==========================
  Widget category(String emoji, String title) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.pink.shade100,
            child: Text(emoji, style: const TextStyle(fontSize: 20)),
          ),

          const SizedBox(height: 6),

          Text(title, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  /// ==========================
  /// PRODUCT CARD
  /// ==========================
  Widget productCard(ProductModel product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Padding(
        padding: const EdgeInsets.all(10),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

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

                    errorBuilder: (_, __, ___) {
                      return const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 42,
                          color: Colors.grey,
                        ),
                      );
                    },

                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }

                      return const Center(child: CircularProgressIndicator());
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
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),

            const SizedBox(height: 5),

            Text(
              "Rp ${product.price}",
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 6),

            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 14),

                const SizedBox(width: 4),

                Text(
                  product.rating.toString(),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
