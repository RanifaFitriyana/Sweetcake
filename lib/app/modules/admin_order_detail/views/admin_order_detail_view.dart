import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../theme/app_colors.dart';
import '../controllers/admin_order_detail_controller.dart';

class AdminOrderDetailView extends GetView<AdminOrderDetailController> {
  const AdminOrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.primary),
        title: const Text(
          "Detail Pesanan",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.order.value == null) {
            return const Center(child: Text("Data pesanan tidak ditemukan"));
          }

          final order = controller.order.value!;

          return RefreshIndicator(
            onRefresh: controller.refreshOrder,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ===============================
                  /// STATUS
                  /// ===============================
                  _sectionTitle("Status Pesanan"),

                  const SizedBox(height: 12),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _statusColor(order.status).withOpacity(.12),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: _statusColor(
                            order.status,
                          ).withOpacity(.15),
                          child: Icon(
                            _statusIcon(order.status),
                            color: _statusColor(order.status),
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Status Pesanan",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                order.status,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: _statusColor(order.status),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  /// ===============================
                  /// INFORMASI PELANGGAN
                  /// ===============================
                  _sectionTitle("Informasi Pelanggan"),

                  const SizedBox(height: 12),

                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _infoTile(Icons.person, "Nama", order.customerName),

                          const Divider(height: 24),

                          _infoTile(Icons.phone, "Nomor HP", order.phone),

                          const Divider(height: 24),

                          _infoTile(Icons.location_on, "Alamat", order.address),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  /// ===============================
                  /// PEMBAYARAN
                  /// ===============================
                  _sectionTitle("Pembayaran"),

                  const SizedBox(height: 12),

                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _infoTile(
                            Icons.payment,
                            "Metode",
                            order.paymentMethod,
                          ),

                          const Divider(height: 24),

                          _infoTile(
                            Icons.calendar_today,
                            "Tanggal",
                            DateFormat(
                              "dd MMM yyyy • HH:mm",
                              "id_ID",
                            ).format(order.createdAt),
                          ),

                          const Divider(height: 24),

                          _infoTile(
                            Icons.payments,
                            "Total Pembayaran",
                            NumberFormat.currency(
                              locale: "id_ID",
                              symbol: "Rp ",
                              decimalDigits: 0,
                            ).format(order.total),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  /// ===============================
                  /// BUKTI PEMBAYARAN
                  /// ===============================
                  _sectionTitle("Bukti Pembayaran"),

                  const SizedBox(height: 12),

                  if (order.paymentProof.isNotEmpty)
                    Builder(
                      builder: (_) {
                        final imageUrl =
                            "http://172.19.0.127:3000${order.paymentProof}";

                        return ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.network(
                            imageUrl,
                            width: double.infinity,
                            height: 220,
                            fit: BoxFit.cover,

                            loadingBuilder: (context, child, progress) {
                              if (progress == null) {
                                return child;
                              }

                              return const SizedBox(
                                height: 220,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },

                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 220,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.broken_image,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 10),
                                      Text("Gagal memuat gambar"),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    )
                  else
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 10),
                          Text("Tidak ada bukti pembayaran"),
                        ],
                      ),
                    ),

                  const SizedBox(height: 28),

                  /// ===============================
                  /// DAFTAR PRODUK
                  /// ===============================
                  _sectionTitle("Daftar Produk"),

                  const SizedBox(height: 12),

                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        children: order.items.map((item) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    item.image,
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

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),

                                      const SizedBox(height: 6),

                                      Text(
                                        "${item.qty} x ${NumberFormat.currency(locale: "id_ID", symbol: "Rp ", decimalDigits: 0).format(item.price)}",
                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 10),

                                Text(
                                  NumberFormat.currency(
                                    locale: "id_ID",
                                    symbol: "Rp ",
                                    decimalDigits: 0,
                                  ).format(item.price * item.qty),
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  /// ===============================
                  /// RINGKASAN PEMBAYARAN
                  /// ===============================
                  _sectionTitle("Ringkasan Pembayaran"),

                  const SizedBox(height: 12),

                  Builder(
                    builder: (_) {
                      // Hitung subtotal dari semua produk
                      final subtotal = order.items.fold<int>(
                        0,
                        (sum, item) => sum + (item.price * item.qty),
                      );

                      // Ongkir = Total - Subtotal
                      final ongkir = order.total - subtotal;

                      return Card(
                        elevation: 2,
                        color: const Color(0xFFFFF3F5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Jumlah Produk"),
                                  Text("${order.items.length} Item"),
                                ],
                              ),

                              const SizedBox(height: 14),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Subtotal Produk"),
                                  Text(
                                    NumberFormat.currency(
                                      locale: "id_ID",
                                      symbol: "Rp ",
                                      decimalDigits: 0,
                                    ).format(subtotal),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 14),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Ongkos Kirim"),
                                  Text(
                                    NumberFormat.currency(
                                      locale: "id_ID",
                                      symbol: "Rp ",
                                      decimalDigits: 0,
                                    ).format(ongkir),
                                  ),
                                ],
                              ),

                              const Divider(height: 30),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "TOTAL",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),

                                  Text(
                                    NumberFormat.currency(
                                      locale: "id_ID",
                                      symbol: "Rp ",
                                      decimalDigits: 0,
                                    ).format(order.total),
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 28),

                  /// ===============================
                  /// UBAH STATUS
                  /// ===============================
                  _sectionTitle("Ubah Status"),

                  const SizedBox(height: 12),

                  Obx(
                    () => DropdownButtonFormField<String>(
                      value: controller.selectedStatus.value,

                      icon: const Icon(Icons.keyboard_arrow_down_rounded),

                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,

                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Colors.green,
                            width: 1.5,
                          ),
                        ),
                      ),

                      items: controller.statusList
                          .map(
                            (status) => DropdownMenuItem(
                              value: status,

                              child: Row(
                                children: [
                                  Icon(
                                    _statusIcon(status),
                                    size: 18,
                                    color: _statusColor(status),
                                  ),

                                  const SizedBox(width: 10),

                                  Text(
                                    status,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),

                      onChanged: controller.changeStatus,
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: controller.isSaving.value
                            ? null
                            : controller.saveStatus,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: controller.isSaving.value
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                "Simpan Perubahan",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 35),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  /// ===================================
  /// SECTION TITLE
  /// ===================================
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  /// ===================================
  /// INFO TILE
  /// ===================================
  Widget _infoTile(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(.10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),

              const SizedBox(height: 4),

              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// ===================================
  /// STATUS ICON
  /// ===================================
  IconData _statusIcon(String status) {
    switch (status) {
      case "Menunggu Verifikasi":
        return Icons.access_time_rounded;

      case "Diproses":
        return Icons.inventory_2_rounded;

      case "Dikirim":
        return Icons.local_shipping_rounded;

      case "Selesai":
        return Icons.check_circle_rounded;

      case "Dibatalkan":
        return Icons.cancel_rounded;

      default:
        return Icons.info_outline_rounded;
    }
  }

  /// ===================================
  /// STATUS COLOR
  /// ===================================
  Color _statusColor(String status) {
    switch (status) {
      case "Menunggu Verifikasi":
        return Colors.orange;

      case "Diproses":
        return Colors.blue;

      case "Dikirim":
        return Colors.indigo;

      case "Selesai":
        return Colors.green;

      case "Dibatalkan":
        return Colors.red;

      default:
        return Colors.grey;
    }
  }
}
