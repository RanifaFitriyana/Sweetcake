import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/custom_bottom_navbar.dart';
import '../../../widgets/custom_drawer.dart';
import '../controllers/category_controller.dart';

class CategoryView extends GetView<CategoryController> {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      drawer: const CustomDrawer(),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Kategori",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// SEARCH
            TextField(
              decoration: InputDecoration(
                hintText: "Cari produk...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// TAB KATEGORI
            SizedBox(
              height: 45,
              child: GetBuilder<CategoryController>(
                builder: (controller) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.categories.length,
                    itemBuilder: (context, index) {
                      final active = controller.selectedCategory == index;

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
                                color: active ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            /// GRID PRODUK
            Expanded(
              child: GridView.builder(
                itemCount: 8,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: .68,
                ),
                itemBuilder: (context, index) {
                  return productCard(
                    title: "Red Velvet Cake",
                    price: "Rp 85.000",
                    priceInt: 85000,
                    image: "assets/images/cake.png",
                    rating: "4.9",
                    description:
                        "Kue Red Velvet premium dengan tekstur lembut dan cream cheese berkualitas tinggi. Cocok untuk ulang tahun maupun acara spesial.",
                  );
                },
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: const CustomBottomNavbar(currentIndex: 1),
    );
  }

  Widget productCard({
    required String title,
    required String price,
    required int priceInt,
    required String image,
    required String rating,
    required String description,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Get.toNamed(
          Routes.DETAIL_PRODUCT,
          arguments: {
            "name": title,
            "price": price,
            "priceInt": priceInt,
            "image": image,
            "rating": rating,
            "description": description,
          },
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                child: Hero(
                  tag: title,
                  child: Image.asset(image, fit: BoxFit.contain),
                ),
              ),

              const SizedBox(height: 10),

              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 5),

              Text(
                price,
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
                  Text(rating),
                ],
              ),

              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                height: 36,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Get.toNamed(
                      Routes.DETAIL_PRODUCT,
                      arguments: {
                        "name": title,
                        "price": price,
                        "priceInt": priceInt,
                        "image": image,
                        "rating": rating,
                        "description": description,
                      },
                    );
                  },
                  child: const Text("Beli"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
