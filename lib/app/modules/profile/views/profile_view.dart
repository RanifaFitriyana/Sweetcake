import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/custom_bottom_navbar.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Profil",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      bottomNavigationBar: const CustomBottomNavbar(currentIndex: 3),

      body: Obx(
        () => ListView(
          padding: const EdgeInsets.all(20),

          children: [
            /// ==========================
            /// FOTO PROFIL
            /// ==========================
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 45,
                    backgroundColor: AppColors.primary,
                    child: Icon(Icons.person, color: Colors.white, size: 50),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    controller.name.value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    controller.email.value,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: 145,
                    height: 42,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Get.toNamed(Routes.EDIT_PROFILE);
                      },
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text(
                        "Edit Profil",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            /// ==========================
            /// AKUN SAYA
            /// ==========================
            const Text(
              "Akun Saya",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.shopping_bag_outlined,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    title: const Text(
                      "Pesanan Saya",
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: const Icon(Icons.chevron_right, size: 20),
                    onTap: () {
                      Get.toNamed(Routes.ORDER);
                    },
                  ),

                  const Divider(height: 1),

                  ListTile(
                    leading: const Icon(
                      Icons.favorite_border,
                      color: Colors.red,
                      size: 20,
                    ),
                    title: const Text(
                      "Wishlist",
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: const Icon(Icons.chevron_right, size: 20),
                    onTap: () {
                      Get.toNamed(Routes.WISHLIST);
                    },
                  ),

                  const Divider(height: 1),

                  ListTile(
                    leading: const Icon(
                      Icons.location_on_outlined,
                      color: Colors.blue,
                      size: 20,
                    ),
                    title: const Text(
                      "Alamat Saya",
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: const Icon(Icons.chevron_right, size: 20),
                    onTap: () {
                      Get.toNamed(Routes.ADDRESS);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// ==========================
            /// LAINNYA
            /// ==========================
            const Text(
              "Lainnya",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.info_outline,
                      color: Colors.teal,
                      size: 20,
                    ),
                    title: const Text(
                      "Tentang Kami",
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: const Icon(Icons.chevron_right, size: 20),
                    onTap: () {
                      Get.toNamed(Routes.ABOUT);
                    },
                  ),

                  const Divider(height: 1),

                  ListTile(
                    leading: const Icon(
                      Icons.logout,
                      color: Colors.red,
                      size: 20,
                    ),
                    title: const Text("Keluar", style: TextStyle(fontSize: 14)),
                    trailing: const Icon(Icons.chevron_right, size: 20),
                    onTap: () {
                      Get.defaultDialog(
                        title: "Konfirmasi Logout",
                        titleStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        middleText:
                            "Apakah Anda yakin ingin keluar dari akun ini?",
                        middleTextStyle: const TextStyle(fontSize: 13),
                        radius: 15,
                        textCancel: "Batal",
                        textConfirm: "Keluar",
                        cancelTextColor: Colors.black,
                        confirmTextColor: Colors.white,
                        buttonColor: AppColors.primary,
                        onConfirm: () {
                          controller.logout();
                        },
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Center(
              child: Text(
                "SweetCake v1.0.0",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
