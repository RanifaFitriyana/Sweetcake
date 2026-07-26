import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/app_colors.dart';
import '../controllers/detail_product_controller.dart';
import '../../cart/controllers/cart_controller.dart';

class DetailProductView extends GetView<DetailProductController> {
  const DetailProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Get.arguments;
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
                  "name": product["name"],
                  "image": product["image"],
                  "price": product["priceInt"],
                  "priceText": product["price"],
                  "rating": product["rating"],
                  "description": product["description"],
                  "size": controller.selectedSize.value,
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
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 10),

                            Text(
                              "Produk berhasil ditambahkan\nke keranjang.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
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
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
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
                  child: Image.asset(
                    product["image"],
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
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
                    child: IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () {},
                    ),
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
                    product["name"],
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Text(
                        product["price"],
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                        ),
                      ),

                      const Spacer(),

                      const Icon(Icons.star, color: Colors.amber),

                      const SizedBox(width: 5),

                      Text(
                        product["rating"],
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Deskripsi",
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Kue premium dengan tekstur yang lembut dan rasa yang lezat. "
                    "Dibuat menggunakan bahan-bahan berkualitas tinggi sehingga cocok "
                    "untuk ulang tahun, perayaan keluarga, maupun acara spesial lainnya.",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "Pilih Ukuran",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                  ),

                  const SizedBox(height: 15),

                  Obx(
                    () => Wrap(
                      spacing: 12,
                      children: controller.sizes.map((size) {
                        final active = controller.selectedSize.value == size;

                        return ChoiceChip(
                          label: Text(size),
                          selected: active,
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: active ? Colors.white : Colors.black,
                          ),
                          onSelected: (_) {
                            controller.selectSize(size);
                          },
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "Jumlah",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                  ),

                  const SizedBox(height: 15),

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
                              fontSize: 18,
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
