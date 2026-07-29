import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UploadPaymentController extends GetxController {
  /// Image Picker
  final ImagePicker _picker = ImagePicker();

  /// Bukti pembayaran
  final Rx<File?> paymentProof = Rx<File?>(null);

  /// Loading
  RxBool isLoading = false.obs;

  /// ==========================
  /// Ambil dari Galeri
  /// ==========================
  Future<void> pickFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      paymentProof.value = File(image.path);
    }
  }

  /// ==========================
  /// Ambil dari Kamera
  /// ==========================
  Future<void> pickFromCamera() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (image != null) {
      paymentProof.value = File(image.path);
    }
  }

  /// ==========================
  /// Upload Bukti Pembayaran
  /// ==========================
  Future<void> uploadPaymentProof() async {
    if (paymentProof.value == null) {
      Get.snackbar(
        "Peringatan",
        "Silakan pilih bukti pembayaran terlebih dahulu.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade100,
      );
      return;
    }

    isLoading.value = true;

    try {
      /// ==========================
      /// TODO:
      /// Upload ke Backend Express
      /// ==========================
      await Future.delayed(const Duration(seconds: 2));

      isLoading.value = false;

      Get.offAllNamed('/success');
    } catch (e) {
      isLoading.value = false;

      Get.snackbar(
        "Gagal",
        "Upload bukti pembayaran gagal.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
