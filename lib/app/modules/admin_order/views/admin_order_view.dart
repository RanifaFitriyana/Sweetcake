import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/app_colors.dart';
import '../../../widgets/admin_bottom_navbar.dart';
import '../controllers/admin_order_controller.dart';
import '../../../routes/app_pages.dart';

class AdminOrderView extends GetView<AdminOrderController> {
  const AdminOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "Kelola Pesanan",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),

      bottomNavigationBar: const AdminBottomNavbar(currentIndex: 2),

      body: RefreshIndicator(
        onRefresh: controller.refreshOrders,

        child: Column(
          children: [
            /// ==========================
            /// SEARCH
            /// ==========================
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
              child: TextField(
                controller: controller.searchController,
                decoration: InputDecoration(
                  hintText: "Cari nama pelanggan...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            /// ==========================
            /// FILTER STATUS
            /// ==========================
            Obx(() {
              final selectedStatus = controller.selectedStatus.value;

              return SizedBox(
                height: 45,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.statusList.length,
                  itemBuilder: (context, index) {
                    final status = controller.statusList[index];

                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ChoiceChip(
                        label: Text(status),
                        selected: selectedStatus == status,
                        selectedColor: AppColors.primary,
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                          color: selectedStatus == status
                              ? Colors.white
                              : Colors.black87,
                        ),
                        onSelected: (_) {
                          controller.changeStatusFilter(status);
                        },
                      ),
                    );
                  },
                ),
              );
            }),

            const SizedBox(height: 10),

            /// ==========================
            /// LIST ORDER
            /// ==========================
            Expanded(
              child: Obx(() {
                final loading = controller.isLoading.value;
                final orders = controller.filteredOrders;

                if (loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (orders.isEmpty) {
                  return const Center(child: Text("Belum ada pesanan"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = controller.filteredOrders[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 15),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// ==========================
                            /// HEADER
                            /// ==========================
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 22,
                                  backgroundColor: Color(0xffFFF3E0),
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.orange,
                                  ),
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        order.customerName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),

                                      const SizedBox(height: 3),

                                      Text(
                                        order.phone,
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                _statusBadge(order.status),
                              ],
                            ),

                            const SizedBox(height: 15),

                            Divider(color: Colors.grey.shade300, height: 1),

                            const SizedBox(height: 15),

                            /// ==========================
                            /// TOTAL
                            /// ==========================
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Total Pembayaran",
                                  style: TextStyle(fontSize: 13),
                                ),

                                Text(
                                  "Rp ${order.total}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            /// ==========================
                            /// JUMLAH ITEM
                            /// ==========================
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Jumlah Produk",
                                  style: TextStyle(fontSize: 13),
                                ),

                                Text(
                                  "${order.items.length} Produk",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            /// ==========================
                            /// TANGGAL
                            /// ==========================
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Tanggal",
                                  style: TextStyle(fontSize: 13),
                                ),

                                Text(
                                  order.createdAt.toString().substring(0, 16),
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 18),

                            /// ==========================
                            /// BUTTON
                            /// ==========================
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      controller.showStatusDialog(order);
                                    },
                                    icon: const Icon(Icons.edit, size: 18),
                                    label: const Text("Ubah Status"),
                                  ),
                                ),

                                const SizedBox(width: 10),

                                Expanded(
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                    ),
                                    onPressed: () {
                                      Get.toNamed(
                                        Routes.ADMIN_ORDER_DETAIL,
                                        arguments: order.id,
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.visibility,
                                      size: 18,
                                    ),
                                    label: const Text("Detail"),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  /// =====================================
  /// STATUS BADGE
  /// =====================================
  Widget _statusBadge(String status) {
    final color = _statusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),

      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4), width: 1),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          Container(
            padding: const EdgeInsets.all(3),

            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),

            child: Icon(_statusIcon(status), size: 12, color: color),
          ),

          const SizedBox(width: 6),

          Text(
            status,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  /// =====================================
  /// STATUS ICON
  /// =====================================
  IconData _statusIcon(String status) {
    switch (status) {
      case "Menunggu Verifikasi":
        return Icons.pending_actions_rounded;

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

  /// =====================================
  /// STATUS COLOR
  /// =====================================
  Color _statusColor(String status) {
    switch (status) {
      case "Menunggu Verifikasi":
        return Colors.orange;

      case "Diproses":
        return Colors.blue;

      case "Dikirim":
        return Colors.purple;

      case "Selesai":
        return Colors.green;

      case "Dibatalkan":
        return Colors.red;

      default:
        return Colors.grey;
    }
  }
}
