import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../../../routes/app_pages.dart';
import '../../cart/controllers/cart_controller.dart';

class CheckoutController extends GetxController {
  /// ==========================
  /// CART
  /// ==========================
  final CartController cartController = Get.find<CartController>();

  /// ==========================
  /// TEXTFIELD
  /// ==========================
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  /// ==========================
  /// LOKASI
  /// ==========================
  RxString address = "".obs;

  /// ==========================
  /// METODE PEMBAYARAN
  /// ==========================
  RxString paymentMethod = "Transfer Bank".obs;

  void changePayment(dynamic value) {
    paymentMethod.value = value.toString();
  }

  /// ==========================
  /// AMBIL GPS
  /// ==========================
  Future<void> getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      Get.snackbar("GPS", "GPS belum diaktifkan.");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar("Lokasi", "Izin lokasi ditolak.");
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemark = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    final place = placemark.first;

    address.value =
        "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}";
  }

  /// ==========================
  /// POPUP PEMBAYARAN
  /// ==========================
  void showPaymentDialog() {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar("Peringatan", "Nama lengkap harus diisi.");
      return;
    }

    if (phoneController.text.trim().isEmpty) {
      Get.snackbar("Peringatan", "Nomor HP harus diisi.");
      return;
    }

    if (address.value.isEmpty) {
      Get.snackbar(
        "Peringatan",
        "Silakan ambil lokasi pengiriman terlebih dahulu.",
      );
      return;
    }

    if (cartController.cartItems.isEmpty) {
      Get.snackbar("Peringatan", "Keranjang belanja masih kosong.");
      return;
    }

    Widget content;

    if (paymentMethod.value == "Transfer Bank") {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.account_balance, size: 60, color: Colors.blue),

          const SizedBox(height: 15),

          const Text(
            "Silakan transfer ke rekening berikut:",
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 15),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              children: [
                Text("Bank BCA", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(
                  "1234567890",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text("a.n SweetCake"),
              ],
            ),
          ),
        ],
      );
    } else if (paymentMethod.value == "QRIS") {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Scan QR Code Berikut",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),

          const SizedBox(height: 20),

          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              "assets/images/qris.png",
              width: 220,
              height: 220,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 15),

          const Text(
            "Silakan scan QRIS menggunakan\nMobile Banking atau E-Wallet.",
            textAlign: TextAlign.center,
          ),
        ],
      );
    } else {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.local_shipping, size: 70, color: Colors.orange),

          const SizedBox(height: 15),

          const Text(
            "Cash On Delivery",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),

          const SizedBox(height: 10),

          const Text(
            "Pembayaran dilakukan ketika pesanan diterima.\n"
            "Pastikan menyiapkan uang tunai sesuai total pembayaran.",
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 15),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: Colors.orange),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Kurir akan menerima pembayaran ketika pesanan sampai di alamat tujuan.",
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    Get.defaultDialog(
      title: "Pembayaran",
      radius: 15,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          content,

          const SizedBox(height: 25),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Get.back();

                if (paymentMethod.value == "COD") {
                  Get.offAllNamed(Routes.SUCCESS);
                } else {
                  Get.toNamed(Routes.UPLOAD_PAYMENT);
                }
              },
              child: Text(
                paymentMethod.value == "COD" ? "Konfirmasi Pesanan" : "Selesai",
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
