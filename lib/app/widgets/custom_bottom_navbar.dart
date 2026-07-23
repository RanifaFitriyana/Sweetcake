import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_pages.dart';
import '../theme/app_colors.dart';

class CustomBottomNavbar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavbar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      elevation: 10,

      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey,

      selectedFontSize: 12,
      unselectedFontSize: 12,

      onTap: (index) {
        // Jangan melakukan navigasi jika masih di halaman yang sama
        if (index == currentIndex) return;

        switch (index) {
          case 0:
            Get.offAllNamed(Routes.HOME);
            break;

          case 1:
            Get.offAllNamed(Routes.CATEGORY);
            break;

          case 2:
            Get.offAllNamed(Routes.CART);
            break;

          case 3:
            Get.offAllNamed(Routes.PROFILE);
            break;
        }
      },

      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view_outlined),
          activeIcon: Icon(Icons.grid_view_rounded),
          label: "Kategori",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          activeIcon: Icon(Icons.shopping_cart),
          label: "Keranjang",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: "Profil",
        ),
      ],
    );
  }
}
