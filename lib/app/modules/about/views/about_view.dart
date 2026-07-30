import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/app_colors.dart';
import '../controllers/about_controller.dart';

class AboutView extends GetView<AboutController> {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Tentang Kami"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          child: Column(
            children: [
              /// ==========================
              /// LOGO
              /// ==========================
              CircleAvatar(
                radius: 55,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: const Icon(
                  Icons.cake,
                  size: 60,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 20),

              /// ==========================
              /// NAMA APLIKASI
              /// ==========================
              Obx(
                () => Text(
                  controller.appName.value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),

              const SizedBox(height: 5),

              Obx(
                () => Text(
                  "Versi ${controller.version.value}",
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ),

              const SizedBox(height: 30),

              /// ==========================
              /// TENTANG APLIKASI
              /// ==========================
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.info_outline, color: AppColors.primary),
                          SizedBox(width: 8),
                          Text(
                            "Tentang Aplikasi",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      Obx(
                        () => Text(
                          controller.description.value,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(fontSize: 14, height: 1.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// ==========================
              /// FITUR UTAMA
              /// ==========================
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Row(
                        children: [
                          Icon(Icons.star_outline, color: AppColors.primary),
                          SizedBox(width: 8),
                          Text(
                            "Fitur Utama",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 15),

                      ListTile(
                        dense: true,
                        leading: Icon(Icons.shopping_cart),
                        title: Text(
                          "Belanja kue secara online",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),

                      ListTile(
                        dense: true,
                        leading: Icon(Icons.location_on),
                        title: Text(
                          "Pilih alamat atau lokasi GPS",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),

                      ListTile(
                        dense: true,
                        leading: Icon(Icons.credit_card),
                        title: Text(
                          "Pembayaran Transfer, QRIS, dan COD",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),

                      ListTile(
                        dense: true,
                        leading: Icon(Icons.receipt_long),
                        title: Text(
                          "Upload bukti pembayaran",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),

                      ListTile(
                        dense: true,
                        leading: Icon(Icons.local_shipping),
                        title: Text(
                          "Lacak status pesanan",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// ==========================
              /// KONTAK
              /// ==========================
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Row(
                        children: [
                          Icon(Icons.contact_mail, color: AppColors.primary),
                          SizedBox(width: 8),
                          Text(
                            "Kontak",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 15),

                      ListTile(
                        dense: true,
                        leading: Icon(Icons.email),
                        title: Text(
                          "support@sweetcake.com",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),

                      ListTile(
                        dense: true,
                        leading: Icon(Icons.phone),
                        title: Text(
                          "+62 812-3456-7890",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),

                      ListTile(
                        dense: true,
                        leading: Icon(Icons.location_city),
                        title: Text(
                          "Jakarta, Indonesia",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// ==========================
              /// COPYRIGHT
              /// ==========================
              const Text(
                "© 2026 SweetCake\nAll Rights Reserved.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),

              /// Jarak bawah agar tidak terpotong
              SizedBox(height: MediaQuery.of(context).padding.bottom + 30),
            ],
          ),
        ),
      ),
    );
  }
}
