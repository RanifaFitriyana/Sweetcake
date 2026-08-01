import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/address_model.dart';
import '../../../theme/app_colors.dart';
import '../controllers/checkout_controller.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text(
          "Checkout",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
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
                "Konfirmasi Pesanan",

                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [
          /// DATA DIRI
          const Text(
            "Data Diri",

            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: controller.nameController,

            decoration: InputDecoration(
              labelText: "Nama Lengkap",

              labelStyle: const TextStyle(fontSize: 14),

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

              labelStyle: const TextStyle(fontSize: 14),

              prefixIcon: const Icon(Icons.phone),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),

          const SizedBox(height: 25),

          /// ALAMAT
          const Text(
            "Alamat Pengiriman",

            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 15),

          Obx(() {
            return Container(
              padding: const EdgeInsets.all(15),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(15),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    "Pilih Alamat",

                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  DropdownButtonFormField<AddressModel>(
                    isExpanded: true,

                    value: controller.selectedAddress.value,

                    hint: const Text(
                      "Pilih alamat",
                      style: TextStyle(fontSize: 14),
                    ),

                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    items: controller.addressController.addresses.map((item) {
                      return DropdownMenuItem<AddressModel>(
                        value: item,

                        child: Text(
                          item.label,

                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),

                    onChanged: (value) {
                      if (value != null) {
                        controller.selectAddress(value);
                      }
                    },
                  ),

                  const SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,

                        foregroundColor: Colors.white,
                      ),

                      onPressed: controller.getLocation,

                      icon: const Icon(Icons.location_on, size: 18),

                      label: const Text(
                        "Gunakan Lokasi GPS",

                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  Container(
                    width: double.infinity,

                    padding: const EdgeInsets.all(15),

                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,

                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: Text(
                      controller.address.value.isEmpty
                          ? "Belum memilih alamat"
                          : controller.address.value,

                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 25),

          /// DETAIL PESANAN
          const Text(
            "Detail Pesanan",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 15),

          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Obx(
                () => Column(
                  children: controller.cartController.cartItems.map((item) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Gambar Produk
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              item["image"],
                              width: 65,
                              height: 65,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) {
                                return Container(
                                  width: 65,
                                  height: 65,
                                  color: Colors.grey.shade300,
                                  child: const Icon(Icons.image),
                                );
                              },
                            ),
                          ),

                          const SizedBox(width: 12),

                          /// Informasi Produk
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item["name"],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                Text(
                                  "${item["qty"]} x ${controller.cartController.formatPrice(item["price"])}",
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 10),

                          /// Total Harga
                          Text(
                            controller.cartController.formatPrice(
                              item["price"] * item["qty"],
                            ),
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          const SizedBox(height: 25),

          /// ==========================
          /// METODE PEMBAYARAN
          /// ==========================
          const Text(
            "Metode Pembayaran",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Obx(() {
            return Column(
              children: [
                RadioListTile<String>(
                  dense: true,
                  value: "Transfer Bank",
                  groupValue: controller.paymentMethod.value,
                  onChanged: controller.changePayment,
                  title: const Text(
                    "Transfer Bank",
                    style: TextStyle(fontSize: 14),
                  ),
                ),

                RadioListTile<String>(
                  dense: true,
                  value: "QRIS",
                  groupValue: controller.paymentMethod.value,
                  onChanged: controller.changePayment,
                  title: const Text("QRIS", style: TextStyle(fontSize: 14)),
                ),

                RadioListTile<String>(
                  dense: true,
                  value: "COD",
                  groupValue: controller.paymentMethod.value,
                  onChanged: controller.changePayment,
                  title: const Text(
                    "Cash On Delivery",
                    style: TextStyle(fontSize: 14),
                  ),
                ),

                const SizedBox(height: 20),

                /// ==========================
                /// INFO PEMBAYARAN
                /// ==========================
                if (controller.paymentMethod.value == "Transfer Bank")
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Transfer Bank",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 12),

                        Text("Bank BCA"),
                        SizedBox(height: 5),

                        Text(
                          "1234567890",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),

                        SizedBox(height: 5),

                        Text("a.n SweetCake"),
                      ],
                    ),
                  ),

                if (controller.paymentMethod.value == "QRIS")
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Scan QRIS Berikut",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(height: 15),

                        Image.asset(
                          "assets/images/qris.png",
                          width: 220,
                          height: 220,
                          fit: BoxFit.contain,
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          "Silakan scan menggunakan Mobile Banking atau E-Wallet.",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                if (controller.paymentMethod.value == "COD")
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline, color: Colors.orange),

                        SizedBox(width: 10),

                        Expanded(
                          child: Text(
                            "Pembayaran dilakukan ketika pesanan diterima oleh pelanggan.",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          }),

          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
