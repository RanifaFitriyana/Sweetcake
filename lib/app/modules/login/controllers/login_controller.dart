import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/services/api_service.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final box = GetStorage();

  RxBool isHidden = true.obs;
  RxBool isLoading = false.obs;

  void showPassword() {
    isHidden.value = !isHidden.value;
  }

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar("Error", "Email dan password wajib diisi");
      return;
    }

    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse("${ApiService.baseUrl}/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": emailController.text.trim(),
          "password": passwordController.text,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Simpan token
        box.write("token", data["token"]);

        // Simpan data user
        box.write("id", data["user"]["_id"]);
        box.write("name", data["user"]["name"]);
        box.write("email", data["user"]["email"]);
        box.write("phone", data["user"]["phone"]);
        box.write("role", data["user"]["role"]);

        Get.snackbar(
          "Berhasil",
          data["message"],
          snackPosition: SnackPosition.TOP,
        );

        Get.offAllNamed(Routes.HOME);
      } else {
        Get.snackbar(
          "Login Gagal",
          data["message"],
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.TOP);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
