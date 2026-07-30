import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/product_model.dart';
import '../../../data/services/admin_service.dart';

class AdminProductController extends GetxController {
  /// ===============================
  /// OBSERVABLE
  /// ===============================
  final products = <ProductModel>[].obs;
  final allProducts = <ProductModel>[].obs;
  final isLoading = false.obs;

  /// ===============================
  /// FORM CONTROLLER
  /// ===============================
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final categoryController = TextEditingController();
  final descriptionController = TextEditingController();
  final imageController = TextEditingController();
  final ratingController = TextEditingController();
  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  @override
  void onClose() {
    nameController.dispose();
    priceController.dispose();
    categoryController.dispose();
    descriptionController.dispose();
    imageController.dispose();
    ratingController.dispose();
    searchController.dispose();
    super.onClose();
  }

  /// ===============================
  /// GET ALL PRODUCT
  /// ===============================
  Future<void> loadProducts() async {
    try {
      isLoading.value = true;

      final data = await AdminService.getProducts();

      allProducts.assignAll(data);
      products.assignAll(data);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshProducts() async {
    await loadProducts();
  }

  void searchProduct(String keyword) {
    if (keyword.trim().isEmpty) {
      products.assignAll(allProducts);
      return;
    }

    final result = allProducts.where((product) {
      return product.name.toLowerCase().contains(keyword.toLowerCase());
    }).toList();

    products.assignAll(result);
  }

  /// ===============================
  /// CLEAR FORM
  /// ===============================
  void clearForm() {
    nameController.clear();
    priceController.clear();
    categoryController.clear();
    descriptionController.clear();
    imageController.clear();
    ratingController.clear();
  }

  /// ===============================
  /// SET FORM
  /// ===============================
  void setForm(ProductModel product) {
    nameController.text = product.name;
    priceController.text = product.price.toString();
    categoryController.text = product.category;
    descriptionController.text = product.description;
    imageController.text = product.image;
    ratingController.text = product.rating.toString();
  }

  /// ===============================
  /// VALIDATION
  /// ===============================
  bool validateForm() {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar("Peringatan", "Nama produk wajib diisi.");
      return false;
    }

    if (priceController.text.trim().isEmpty) {
      Get.snackbar("Peringatan", "Harga wajib diisi.");
      return false;
    }

    if (categoryController.text.trim().isEmpty) {
      Get.snackbar("Peringatan", "Kategori wajib diisi.");
      return false;
    }

    if (descriptionController.text.trim().isEmpty) {
      Get.snackbar("Peringatan", "Deskripsi wajib diisi.");
      return false;
    }

    if (imageController.text.trim().isEmpty) {
      Get.snackbar("Peringatan", "URL gambar wajib diisi.");
      return false;
    }

    if (ratingController.text.trim().isEmpty) {
      Get.snackbar("Peringatan", "Rating wajib diisi.");
      return false;
    }

    return true;
  }

  /// ===============================
  /// CREATE PRODUCT
  /// ===============================
  Future<bool> createProduct() async {
    if (!validateForm()) return false;

    try {
      final success = await AdminService.createProduct(
        data: {
          "name": nameController.text.trim(),
          "price": int.parse(priceController.text),
          "category": categoryController.text.trim(),
          "description": descriptionController.text.trim(),
          "image": imageController.text.trim(),
          "rating": double.parse(ratingController.text),
        },
      );

      if (success) {
        clearForm();
        await loadProducts();
      }

      return success;
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    }
  }

  /// ===============================
  /// UPDATE PRODUCT
  /// ===============================
  Future<bool> updateProduct(String id) async {
    if (!validateForm()) return false;

    try {
      final success = await AdminService.updateProduct(
        id: id,
        data: {
          "name": nameController.text.trim(),
          "price": int.parse(priceController.text),
          "category": categoryController.text.trim(),
          "description": descriptionController.text.trim(),
          "image": imageController.text.trim(),
          "rating": double.parse(ratingController.text),
        },
      );

      if (success) {
        clearForm();
        await loadProducts();
      }

      return success;
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    }
  }

  /// ===============================
  /// DELETE PRODUCT
  /// ===============================
  Future<bool> deleteProduct(String id) async {
    try {
      final success = await AdminService.deleteProduct(id);

      if (success) {
        await loadProducts();
      }

      return success;
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    }
  }
}
