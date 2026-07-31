import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/product_model.dart';
import '../../../theme/app_colors.dart';
import '../controllers/admin_product_controller.dart';
import '../../../widgets/admin_bottom_navbar.dart';

class AdminProductView extends GetView<AdminProductController> {
  const AdminProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Kelola Produk",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),

      bottomNavigationBar: const AdminBottomNavbar(currentIndex: 1),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          controller.clearForm();
          showAddDialog();
        },
      ),

      body: Column(
        children: [
          /// SEARCH
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
            child: TextField(
              controller: controller.searchController,
              onChanged: controller.searchProduct,
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
          ),

          /// LIST PRODUCT
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.products.isEmpty) {
                return const Center(
                  child: Text(
                    "Belum ada produk.",
                    style: TextStyle(fontSize: 14),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refreshProducts,
                child: ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: controller.products.length,
                  itemBuilder: (context, index) {
                    final product = controller.products[index];

                    return _productCard(product);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  /// ===============================
  /// PRODUCT CARD
  /// ===============================
  Widget _productCard(ProductModel product) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      child: Padding(
        padding: const EdgeInsets.all(12),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                product.image,
                width: 85,
                height: 85,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return Container(
                    width: 85,
                    height: 85,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.image_not_supported),
                  );
                },
              ),
            ),

            const SizedBox(width: 12),

            /// CONTENT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    product.category,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Rp ${product.price}",
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 17),

                      const SizedBox(width: 3),

                      Text(
                        product.rating.toString(),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(0, 38),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.edit, size: 18),
                          label: const Text(
                            "Edit",
                            style: TextStyle(fontSize: 13),
                          ),
                          onPressed: () {
                            controller.setForm(product);
                            showEditDialog(product);
                          },
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(0, 38),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.delete, size: 18),
                          label: const Text(
                            "Hapus",
                            style: TextStyle(fontSize: 13),
                          ),
                          onPressed: () {
                            showDeleteDialog(product);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ===============================
  /// DIALOG TAMBAH PRODUK
  /// ===============================
  void showAddDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),

        title: const Text(
          "Tambah Produk",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        content: SizedBox(
          width: 420,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _textField(
                  controller.nameController,
                  "Nama Produk",
                  Icons.cake,
                ),

                const SizedBox(height: 12),

                _textField(
                  controller.priceController,
                  "Harga",
                  Icons.attach_money,
                  TextInputType.number,
                ),

                const SizedBox(height: 12),

                _textField(
                  controller.categoryController,
                  "Kategori",
                  Icons.category,
                ),

                const SizedBox(height: 12),

                _textField(
                  controller.descriptionController,
                  "Deskripsi",
                  Icons.description,
                ),

                const SizedBox(height: 12),

                _textField(
                  controller.imageController,
                  "URL Gambar",
                  Icons.image,
                ),

                const SizedBox(height: 12),

                _textField(
                  controller.ratingController,
                  "Rating",
                  Icons.star,
                  TextInputType.number,
                ),
              ],
            ),
          ),
        ),

        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 90,
                height: 38,
                child: OutlinedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.green),
                    foregroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text(
                    "Batal",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              SizedBox(
                width: 90,
                height: 38,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.zero,
                  ),

                  onPressed: () async {
                    final success = await controller.createProduct();

                    if (success) {
                      Get.back();

                      Get.snackbar(
                        "Berhasil",
                        "Produk berhasil ditambahkan.",
                        snackPosition: SnackPosition.TOP,
                      );
                    }
                  },

                  child: const Text(
                    "Simpan",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ===============================
  /// DIALOG EDIT PRODUK
  /// ===============================
  void showEditDialog(ProductModel product) {
    controller.setForm(product);

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),

        title: const Text(
          "Edit Produk",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        content: SizedBox(
          width: 420,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _textField(
                  controller.nameController,
                  "Nama Produk",
                  Icons.cake,
                ),

                const SizedBox(height: 12),

                _textField(
                  controller.priceController,
                  "Harga",
                  Icons.attach_money,
                  TextInputType.number,
                ),

                const SizedBox(height: 12),

                _textField(
                  controller.categoryController,
                  "Kategori",
                  Icons.category,
                ),

                const SizedBox(height: 12),

                _textField(
                  controller.descriptionController,
                  "Deskripsi",
                  Icons.description,
                ),

                const SizedBox(height: 12),

                _textField(
                  controller.imageController,
                  "URL Gambar",
                  Icons.image,
                ),

                const SizedBox(height: 12),

                _textField(
                  controller.ratingController,
                  "Rating",
                  Icons.star,
                  TextInputType.number,
                ),
              ],
            ),
          ),
        ),

        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 90,
                height: 38,
                child: OutlinedButton(
                  onPressed: () {
                    Get.back();
                  },

                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.green),
                    foregroundColor: Colors.green,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),

                    padding: EdgeInsets.zero,
                  ),

                  child: const Text(
                    "Batal",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              SizedBox(
                width: 90,
                height: 38,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),

                    padding: EdgeInsets.zero,
                  ),

                  onPressed: () async {
                    final success = await controller.updateProduct(product.id);

                    if (success) {
                      Get.back();

                      Get.snackbar(
                        "Berhasil",
                        "Produk berhasil diperbarui.",
                        snackPosition: SnackPosition.TOP,
                      );
                    }
                  },

                  child: const Text(
                    "Update",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ===============================
  /// DIALOG HAPUS PRODUK
  /// ===============================
  void showDeleteDialog(ProductModel product) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),

        title: const Text(
          "Hapus Produk",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        content: Text(
          "Apakah Anda yakin ingin menghapus produk\n'${product.name}'?",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
        ),

        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 90,
                height: 38,
                child: OutlinedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.green),
                    foregroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text(
                    "Batal",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              SizedBox(
                width: 90,
                height: 38,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.zero,
                  ),

                  onPressed: () async {
                    final success = await controller.deleteProduct(product.id);

                    if (success) {
                      Get.back();

                      Get.snackbar(
                        "Berhasil",
                        "Produk berhasil dihapus.",
                        snackPosition: SnackPosition.TOP,
                      );
                    }
                  },

                  child: const Text(
                    "Hapus",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ===============================
  /// TEXT FIELD
  /// ===============================
  Widget _textField(
    TextEditingController controller,
    String hint,
    IconData icon, [
    TextInputType keyboardType = TextInputType.text,
  ]) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
