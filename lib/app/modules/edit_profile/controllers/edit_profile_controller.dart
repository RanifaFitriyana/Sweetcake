import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/services/account_service.dart';

class EditProfileController extends GetxController {
  final GetStorage box = GetStorage();

  /// Text Controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  /// Observable
  RxBool isLoading = false.obs;
  RxBool isPasswordHidden = true.obs;
  RxBool isConfirmHidden = true.obs;

  @override
  void onInit() {
    super.onInit();

    emailController.text = box.read("email") ?? "";
  }

  void togglePassword() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPassword() {
    isConfirmHidden.value = !isConfirmHidden.value;
  }

  Future<void> updateProfile() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirm = confirmPasswordController.text.trim();

    if (email.isEmpty) {
      Get.snackbar("Peringatan", "Email tidak boleh kosong.");
      return;
    }

    if (password.isNotEmpty && password.length < 8) {
      Get.snackbar("Peringatan", "Password minimal 8 karakter.");
      return;
    }

    if (password != confirm) {
      Get.snackbar("Peringatan", "Konfirmasi password tidak sesuai.");
      return;
    }

    try {
      isLoading.value = true;

      final token = box.read("token");

      final success = await AccountService.updateProfile(
        token: token,
        email: email,
        password: password,
      );
      
      if (success) {
        box.write("email", email);

        Get.back();

        Get.snackbar("Berhasil", "Profil berhasil diperbarui.");
      } else {
        Get.snackbar("Gagal", "Profil gagal diperbarui.");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.onClose();
  }
}
