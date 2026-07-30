import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/app_colors.dart';
import '../controllers/address_controller.dart';

class AddressView extends GetView<AddressController> {
  const AddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        title: const Text("Alamat Saya", style: TextStyle(fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: SizedBox(
            height: 55,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {
                controller.clearForm();
                _showAddressForm(context);
              },
              icon: const Icon(Icons.add, size: 20),
              label: const Text(
                "Tambah Alamat",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.addresses.isEmpty) {
          return const Center(
            child: Text("Belum ada alamat.", style: TextStyle(fontSize: 15)),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).padding.bottom + 90,
          ),
          itemCount: controller.addresses.length,
          itemBuilder: (context, index) {
            final address = controller.addresses[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ======================
                  /// HEADER
                  /// ======================
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          address.label,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      if (address.isDefault)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "Utama",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Text(
                    address.receiverName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(address.phone, style: const TextStyle(fontSize: 14)),

                  const SizedBox(height: 10),

                  Text(
                    address.address,
                    style: const TextStyle(fontSize: 14, height: 1.4),
                  ),

                  if (address.note.isNotEmpty) ...[
                    const SizedBox(height: 8),

                    Text(
                      "Catatan : ${address.note}",
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],

                  const SizedBox(height: 18),

                  /// ======================
                  /// TOMBOL AKSI
                  /// ======================
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue,
                          side: const BorderSide(color: Colors.blue),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          controller.editAddress(address);
                          _showAddressForm(context);
                        },
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text(
                          "Edit",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),

                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          controller.deleteAddress(address.id!);
                        },
                        icon: const Icon(Icons.delete, size: 18),
                        label: const Text(
                          "Hapus",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),

                  if (!address.isDefault) ...[
                    const SizedBox(height: 10),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          controller.setDefault(address.id!);
                        },
                        child: const Text(
                          "Jadikan Utama",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      }),
    );
  }

  void _showAddressForm(BuildContext context) {
    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Handle
                    Center(
                      child: Container(
                        width: 60,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      controller.selectedAddress.value == null
                          ? "Tambah Alamat"
                          : "Edit Alamat",
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 25),
                    TextField(
                      controller: controller.labelController,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        labelText: "Label Alamat",
                        labelStyle: const TextStyle(fontSize: 14),
                        hintText: "Rumah / Kantor / Kost",
                        hintStyle: const TextStyle(fontSize: 13),
                        prefixIcon: const Icon(Icons.home, size: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: controller.receiverController,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        labelText: "Nama Penerima",
                        labelStyle: const TextStyle(fontSize: 14),
                        prefixIcon: const Icon(Icons.person, size: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: controller.phoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        labelText: "Nomor HP",
                        labelStyle: const TextStyle(fontSize: 14),
                        prefixIcon: const Icon(Icons.phone, size: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: controller.addressController,
                      maxLines: 3,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        labelText: "Alamat Lengkap",
                        labelStyle: const TextStyle(fontSize: 14),
                        alignLabelWithHint: true,
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(bottom: 50),
                          child: Icon(Icons.location_on, size: 20),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: controller.getLocation,
                        icon: const Icon(Icons.my_location, size: 18),
                        label: const Text(
                          "Ambil Lokasi GPS",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: controller.noteController,
                      maxLines: 2,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        labelText: "Catatan (Opsional)",
                        labelStyle: const TextStyle(fontSize: 14),
                        hintText: "Contoh: Rumah warna putih",
                        hintStyle: const TextStyle(fontSize: 13),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(bottom: 28),
                          child: Icon(Icons.notes, size: 20),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    CheckboxListTile(
                      value: controller.isDefault.value,
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      visualDensity: VisualDensity.compact,
                      onChanged: (value) {
                        controller.isDefault.value = value ?? false;
                      },
                      title: const Text(
                        "Jadikan alamat utama",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: controller.saveAddress,
                        child: const Text(
                          "Simpan Alamat",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
