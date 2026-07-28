import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  /// ==========================
  /// LIST KERANJANG
  /// ==========================
  final RxList<Map<String, dynamic>> cartItems = <Map<String, dynamic>>[].obs;

  /// Ongkir
  final int shippingCost = 15000;

  /// ==========================
  /// TAMBAH KE KERANJANG
  /// ==========================
  void addToCart(Map<String, dynamic> product) {
    int index = cartItems.indexWhere((item) => item["id"] == product["id"]);

    if (index != -1) {
      cartItems[index]["qty"] += product["qty"];
      cartItems.refresh();
    } else {
      cartItems.add({...product});
    }
  }

  /// ==========================
  /// TAMBAH JUMLAH
  /// ==========================
  void increaseQty(int index) {
    cartItems[index]["qty"]++;
    cartItems.refresh();
  }

  /// ==========================
  /// KURANG JUMLAH
  /// ==========================
  void decreaseQty(int index) {
    if (cartItems[index]["qty"] > 1) {
      cartItems[index]["qty"]--;
      cartItems.refresh();
    } else {
      showDeleteDialog(index);
    }
  }

  /// ==========================
  /// HAPUS PRODUK
  /// ==========================
  void removeItem(int index) {
    cartItems.removeAt(index);
  }

  /// ==========================
  /// POPUP HAPUS
  /// ==========================
  void showDeleteDialog(int index) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          "Hapus Produk",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Apakah Anda yakin ingin menghapus produk ini dari keranjang?",
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              removeItem(index);
              Get.back();
            },
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }

  /// ==========================
  /// SUBTOTAL
  /// ==========================
  int get subtotal {
    int total = 0;

    for (final item in cartItems) {
      total += (item["price"] as int) * (item["qty"] as int);
    }

    return total;
  }

  /// ==========================
  /// TOTAL ITEM
  /// ==========================
  int get totalItems {
    int total = 0;

    for (final item in cartItems) {
      total += item["qty"] as int;
    }

    return total;
  }

  /// ==========================
  /// TOTAL PEMBAYARAN
  /// ==========================
  int get total {
    if (cartItems.isEmpty) return 0;

    return subtotal + shippingCost;
  }

  /// ==========================
  /// FORMAT RUPIAH
  /// ==========================
  String formatPrice(int value) {
    final text = value.toString();
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);

      final position = text.length - i - 1;

      if (position > 0 && position % 3 == 0) {
        buffer.write(".");
      }
    }

    return "Rp $buffer";
  }

  /// ==========================
  /// KOSONGKAN KERANJANG
  /// ==========================
  void clearCart() {
    cartItems.clear();
  }
}
