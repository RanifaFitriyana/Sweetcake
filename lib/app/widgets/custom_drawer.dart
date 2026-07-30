import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../routes/app_pages.dart';
import '../theme/app_colors.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({super.key});

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            /// ==========================
            /// HEADER USER
            /// ==========================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              color: AppColors.primary,
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.grey, size: 35),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          box.read("name") ?? "Guest",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          box.read("email") ?? "-",
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// ==========================
            /// MENU
            /// ==========================
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _drawerItem(
                    Icons.home_outlined,
                    "Beranda",
                    () => Get.offAllNamed(Routes.HOME),
                  ),

                  _drawerItem(
                    Icons.grid_view_outlined,
                    "Kategori",
                    () => Get.offAllNamed(Routes.CATEGORY),
                  ),

                  _drawerItem(
                    Icons.shopping_cart_outlined,
                    "Keranjang",
                    () => Get.offAllNamed(Routes.CART),
                  ),

                  _drawerItem(
                    Icons.receipt_long_outlined,
                    "Pesanan Saya",
                    () => Get.toNamed(Routes.ORDER),
                  ),

                  _drawerItem(
                    Icons.favorite_border,
                    "Wishlist",
                    () => Get.toNamed(Routes.WISHLIST),
                  ),

                  _drawerItem(
                    Icons.location_on_outlined,
                    "Alamat Saya",
                    () => Get.toNamed(Routes.ADDRESS),
                  ),
                  
                  _drawerItem(
                    Icons.info_outline,
                    "Tentang Kami",
                    () => Get.toNamed(Routes.ABOUT),
                  ),

                  const Divider(),

                  _drawerItem(Icons.logout, "Keluar", () {
                    Get.defaultDialog(
                      title: "Konfirmasi Logout",
                      middleText:
                          "Apakah Anda yakin ingin keluar dari akun ini?",
                      radius: 15,
                      textCancel: "Batal",
                      textConfirm: "Keluar",
                      confirmTextColor: Colors.white,
                      buttonColor: AppColors.primary,
                      onConfirm: () {
                        box.erase();

                        Get.offAllNamed(Routes.LOGIN);
                      },
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
    );
  }
}
