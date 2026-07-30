import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/admin_bottom_navbar.dart';
import '../controllers/admin_dashboard_controller.dart';

class AdminDashboardView extends GetView<AdminDashboardController> {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          "Dashboard Admin",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),

      bottomNavigationBar: const AdminBottomNavbar(currentIndex: 0),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SafeArea(
          child: RefreshIndicator(
            onRefresh: controller.refreshDashboard,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Halo, Admin 👋",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Selamat datang di Dashboard SweetCake.",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),

                  const SizedBox(height: 25),

                  /// ==========================
                  /// STATISTIK
                  /// ==========================
                  Row(
                    children: [
                      Expanded(
                        child: _statCard(
                          icon: Icons.cake,
                          title: "Produk",
                          value: controller.totalProduct.value.toString(),
                          color: Colors.orange,
                        ),
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: _statCard(
                          icon: Icons.shopping_bag,
                          title: "Pesanan",
                          value: controller.totalOrder.value.toString(),
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Expanded(
                        child: _statCard(
                          icon: Icons.people,
                          title: "User",
                          value: controller.totalUser.value.toString(),
                          color: Colors.green,
                        ),
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: _statCard(
                          icon: Icons.attach_money,
                          title: "Pendapatan",
                          value: controller.totalIncome.value,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "Menu Admin",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),

                  _menuCard(
                    icon: Icons.inventory_2_outlined,
                    title: "Kelola Produk",
                    color: Colors.orange,
                    onTap: () {
                      Get.toNamed(Routes.ADMIN_PRODUCT);
                    },
                  ),

                  _menuCard(
                    icon: Icons.shopping_cart_outlined,
                    title: "Kelola Pesanan",
                    color: Colors.blue,
                    onTap: () {
                      Get.toNamed(Routes.ADMIN_ORDER);
                    },
                  ),

                  _menuCard(
                    icon: Icons.people_outline,
                    title: "Kelola User",
                    color: Colors.green,
                    onTap: () {
                      Get.toNamed(Routes.ADMIN_USER);
                    },
                  ),

                  _menuCard(
                    icon: Icons.bar_chart,
                    title: "Laporan Penjualan",
                    color: Colors.purple,
                    onTap: () {
                      Get.toNamed(Routes.ADMIN_REPORT);
                    },
                  ),

                  _menuCard(
                    icon: Icons.logout,
                    title: "Logout",
                    color: Colors.red,
                    onTap: () {
                      Get.defaultDialog(
                        backgroundColor: Colors.white,
                        radius: 15,
                        title: "Konfirmasi Logout",
                        titleStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        middleText:
                            "Apakah Anda yakin ingin keluar dari akun admin?",
                        middleTextStyle: const TextStyle(fontSize: 13),
                        textCancel: "Batal",
                        textConfirm: "Keluar",
                        cancelTextColor: Colors.red,
                        confirmTextColor: Colors.white,
                        buttonColor: Colors.green,
                        onConfirm: controller.logout,
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _statCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.12),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: color.withOpacity(.15),
            child: Icon(icon, color: color, size: 26),
          ),

          const SizedBox(height: 12),

          Text(title, style: const TextStyle(fontSize: 13, color: Colors.grey)),

          const SizedBox(height: 6),

          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _menuCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: color.withOpacity(.15),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.chevron_right, size: 22, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
