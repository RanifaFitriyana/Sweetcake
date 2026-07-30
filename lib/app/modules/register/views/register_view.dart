import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  Widget buildField({
    required TextEditingController controllerText,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controllerText,
      keyboardType: keyboardType,
      obscureText: obscure,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13),
        prefixIcon: Icon(icon, size: 20),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const SizedBox(height: 30),

              Center(child: Image.asset("assets/images/logo.png", width: 95)),

              const SizedBox(height: 25),

              Row(
                children: [
                  Text(
                    "Halo!",
                    style: AppTextStyles.title.copyWith(fontSize: 22),
                  ),
                  const SizedBox(width: 6),
                  const Text("👋", style: TextStyle(fontSize: 24)),
                ],
              ),

              const SizedBox(height: 6),

              Text(
                "Buat akun untuk mulai berbelanja",
                style: AppTextStyles.body.copyWith(fontSize: 13),
              ),

              const SizedBox(height: 28),

              buildField(
                controllerText: controller.nameController,
                hint: "Nama Lengkap",
                icon: Icons.person_outline,
              ),

              const SizedBox(height: 16),

              buildField(
                controllerText: controller.emailController,
                hint: "Email",
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 16),

              buildField(
                controllerText: controller.phoneController,
                hint: "Nomor HP",
                icon: Icons.phone_android,
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 16),

              Obx(
                () => buildField(
                  controllerText: controller.passwordController,
                  hint: "Password",
                  icon: Icons.lock_outline,
                  obscure: controller.isPasswordHidden.value,
                  suffix: IconButton(
                    icon: Icon(
                      controller.isPasswordHidden.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      size: 20,
                    ),
                    onPressed: controller.togglePassword,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Obx(
                () => buildField(
                  controllerText: controller.confirmPasswordController,
                  hint: "Konfirmasi Password",
                  icon: Icons.lock_outline,
                  obscure: controller.isConfirmHidden.value,
                  suffix: IconButton(
                    icon: Icon(
                      controller.isConfirmHidden.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      size: 20,
                    ),
                    onPressed: controller.toggleConfirmPassword,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.register,
                    child: controller.isLoading.value
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Daftar",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// Sudah punya akun
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Sudah punya akun?",
                    style: TextStyle(color: Colors.black54, fontSize: 13),
                  ),

                  TextButton(
                    onPressed: () {
                      Get.back();

                      // atau bisa juga:
                      // Get.offNamed(Routes.LOGIN);
                    },

                    child: const Text(
                      "Masuk di sini",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
