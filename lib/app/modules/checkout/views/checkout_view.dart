import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/app_colors.dart';
import '../controllers/checkout_controller.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Checkout"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: controller.showPaymentDialog,
              child: const Text(
                "Lanjut Pembayaran",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ),
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          /// ==========================
          /// DATA DIRI
          /// ==========================
          const Text(
            "Data Diri",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: controller.nameController,
            decoration: InputDecoration(
              labelText: "Nama Lengkap",
              prefixIcon: const Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: controller.phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: "Nomor HP",
              prefixIcon: const Icon(Icons.phone),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),

          const SizedBox(height: 30),

          /// ==========================
          /// ALAMAT
          /// ==========================
          const Text(
            "Alamat Pengiriman",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 15),

          Obx(
            () => Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    controller.address.value.isEmpty
                        ? "Belum mengambil lokasi"
                        : controller.address.value,
                  ),

                  const SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: controller.getLocation,
                      icon: const Icon(Icons.location_on),
                      label: const Text("Ambil Lokasi GPS"),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          /// ==========================
          /// DETAIL PESANAN
          /// ==========================
          const Text(
            "Detail Pesanan",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 15),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Obx(() {
                return Column(
                  children: controller.cartController.cartItems.map((item) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(item["name"]),
                      subtitle: Text("x${item["qty"]}"),
                      trailing: Text(
                        controller.cartController
                            .formatPrice(item["price"] * item["qty"]),
                      ),
                    );
                  }).toList(),
                );
              }),
            ),
          ),

          const SizedBox(height: 25),

          /// ==========================
          /// METODE PEMBAYARAN
          /// ==========================
          const Text(
            "Metode Pembayaran",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 15),

          Obx(
            () => Column(
              children: [

                RadioListTile(
                  value: "Transfer Bank",
                  groupValue: controller.paymentMethod.value,
                  onChanged: controller.changePayment,
                  title: const Text("Transfer Bank"),
                ),

                RadioListTile(
                  value: "QRIS",
                  groupValue: controller.paymentMethod.value,
                  onChanged: controller.changePayment,
                  title: const Text("QRIS"),
                ),

                RadioListTile(
                  value: "COD",
                  groupValue: controller.paymentMethod.value,
                  onChanged: controller.changePayment,
                  title: const Text("Cash On Delivery"),
                ),
              ],
            ),
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }
}