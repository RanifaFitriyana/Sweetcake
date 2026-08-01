import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/product_model.dart';
import '../../../routes/app_pages.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/custom_bottom_navbar.dart';
import '../controllers/category_controller.dart';

class CategoryView extends GetView<CategoryController> {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),

        title: const Text(
          "Kategori",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),

      bottomNavigationBar: const CustomBottomNavbar(currentIndex: 1),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            /// ==========================
            /// SEARCH
            /// ==========================
            TextField(
              controller: controller.searchController,
              style: const TextStyle(fontSize: 14),

              decoration: InputDecoration(
                hintText: "Cari produk...",
                hintStyle: const TextStyle(fontSize: 14),

                prefixIcon: const Icon(Icons.search, size: 20),

                suffixIcon: controller.searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          controller.searchController.clear();
                          controller.filterProducts();
                        },
                      )
                    : null,

                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// ==========================
            /// TAB KATEGORI
            /// ==========================
            GetBuilder<CategoryController>(
              builder: (controller) {
                return SizedBox(
                  height: 45,

                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,

                    itemCount: controller.categories.length,

                    itemBuilder: (context, index) {
                      final active = controller.selectedCategory.value == index;

                      return GestureDetector(
                        onTap: () {
                          controller.changeCategory(index);
                        },

                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),

                          margin: const EdgeInsets.only(right: 10),

                          padding: const EdgeInsets.symmetric(horizontal: 18),

                          decoration: BoxDecoration(
                            color: active ? AppColors.primary : Colors.white,

                            borderRadius: BorderRadius.circular(25),

                            border: Border.all(
                              color: active
                                  ? AppColors.primary
                                  : Colors.grey.shade300,
                            ),
                          ),

                          child: Center(
                            child: Text(
                              controller.categories[index],
                              style: TextStyle(
                                fontSize: 13,
                                color: active ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            /// ==========================
            /// GRID PRODUK
            /// ==========================
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.products.isEmpty) {
                  return const Center(
                    child: Text(
                      "Produk tidak ditemukan",
                      style: TextStyle(fontSize: 14),
                    ),
                  );
                }

                return GridView.builder(
                  itemCount: controller.products.length,

                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: .68,
                  ),

                  itemBuilder: (context, index) {
                    final product = controller.products[index];

                    return productCard(product);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  /// ==========================
  /// PRODUCT CARD
  /// ==========================
  Widget productCard(ProductModel product) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Get.toNamed(Routes.DETAIL_PRODUCT, arguments: product);
      },

      child: Container(
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
              /// ==========================
              /// GAMBAR PRODUK
              /// ==========================
              Expanded(
                child: Hero(
                  tag: product.id,

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),

                    child: Image.network(
                      product.image,
                      width: double.infinity,
                      fit: BoxFit.cover,

                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }

                        return const Center(child: CircularProgressIndicator());
                      },

                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 45,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              /// ==========================
              /// NAMA PRODUK
              /// ==========================
              Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 5),

              /// ==========================
              /// HARGA
              /// ==========================
              Text(
                "Rp ${product.price}",
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 6),

              /// ==========================
              /// RATING
              /// ==========================
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

              const SizedBox(height: 8),

              /// ==========================
              /// TOMBOL BELI
              /// ==========================
              SizedBox(
                width: double.infinity,
                height: 34,
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
                    Get.toNamed(Routes.DETAIL_PRODUCT, arguments: product);
                  },
                  child: const Text(
                    "Beli",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
