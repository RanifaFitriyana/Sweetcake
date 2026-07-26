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
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      bottomNavigationBar: const CustomBottomNavbar(currentIndex: 3),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          /// ==========================
          /// FOTO PROFIL
          /// ==========================
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.person, color: Colors.white, size: 55),
                ),

                const SizedBox(height: 15),

                Obx(
                  () => Text(
                    controller.name.value,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 5),

                Obx(
                  () => Text(
                    controller.email.value,
                    style: const TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                ),
                const SizedBox(height: 18),

                SizedBox(
                  width: 150,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Get.snackbar(
                        "Info",
                        "Fitur Edit Profil akan segera tersedia.",
                        snackPosition: SnackPosition.TOP,
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text("Edit Profil"),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          /// ==========================
          /// AKUN SAYA
          /// ==========================
          const Text(
            "Akun Saya",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  ),
                  title: const Text("Pesanan Saya"),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Get.toNamed(Routes.ORDER);
                  },
                ),

                const Divider(height: 1),

                ListTile(
                  leading: const Icon(Icons.favorite_border, color: Colors.red),
                  title: const Text("Wishlist"),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Get.toNamed(Routes.WISHLIST);
                  },
                ),

                const Divider(height: 1),

                ListTile(
                  leading: const Icon(
                    Icons.location_on_outlined,
                    color: Colors.blue,
                  ),
                  title: const Text("Alamat Saya"),
                  trailing: const Icon(Icons.chevron_right),
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
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  leading: const Icon(Icons.info_outline, color: Colors.teal),
                  title: const Text("Tentang Kami"),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Get.toNamed(Routes.ABOUT);
                  },
                ),

                const Divider(height: 1),

                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text("Keluar"),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Get.dialog(
                      AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        title: const Text("Keluar"),
                        content: const Text(
                          "Apakah Anda yakin ingin keluar dari akun ini?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: const Text("Batal"),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              controller.logout();
                            },
                            child: const Text("Keluar"),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
