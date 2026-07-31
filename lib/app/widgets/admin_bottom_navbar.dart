import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_pages.dart';
import '../theme/app_colors.dart';

class AdminBottomNavbar extends StatelessWidget {
  final int currentIndex;

  const AdminBottomNavbar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey,
      selectedFontSize: 12,
      unselectedFontSize: 11,
      showUnselectedLabels: true,
      onTap: (index) {
        switch (index) {
          case 0:
            Get.offAllNamed(Routes.ADMIN_DASHBOARD);
            break;

          case 1:
            Get.offAllNamed(Routes.ADMIN_PRODUCT);
            break;

          case 2:
            Get.offAllNamed(Routes.ADMIN_ORDER);
            break;

          case 3:
            Get.offAllNamed(Routes.ADMIN_USER);
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          activeIcon: Icon(Icons.dashboard),
          label: "Dashboard",
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.cake_outlined),
          activeIcon: Icon(Icons.cake),
          label: "Produk",
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag_outlined),
          activeIcon: Icon(Icons.shopping_bag),
          label: "Pesanan",
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.people_outline),
          activeIcon: Icon(Icons.people),
          label: "User",
        ),
      ],
    );
  }
}
