import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/admin_order_model.dart';
import '../../../data/services/admin_service.dart';

class AdminOrderController extends GetxController {
  /// ===============================
  /// DATA
  /// ===============================
  RxList<AdminOrderModel> orders = <AdminOrderModel>[].obs;
  RxList<AdminOrderModel> filteredOrders = <AdminOrderModel>[].obs;

  RxBool isLoading = false.obs;

  final searchController = TextEditingController();

  RxString selectedStatus = "Semua".obs;

  final List<String> statusList = [
    "Semua",
    "Menunggu Verifikasi",
    "Diproses",
    "Dikirim",
    "Selesai",
    "Dibatalkan",
  ];

  @override
  void onInit() {
    super.onInit();

    loadOrders();

    searchController.addListener(() {
      filterOrders();
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  /// ===============================
  /// GET ALL ORDERS
  /// ===============================
  Future<void> loadOrders() async {
    try {
      isLoading.value = true;

      final result = await AdminService.getOrders();

      orders.assignAll(result);

      filterOrders();
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.TOP);
    } finally {
      isLoading.value = false;
    }
  }

  /// ===============================
  /// REFRESH
  /// ===============================
  Future<void> refreshOrders() async {
    await loadOrders();
  }

  /// ===============================
  /// SEARCH + FILTER
  /// ===============================
  void filterOrders() {
    List<AdminOrderModel> result = List.from(orders);

    final keyword = searchController.text.toLowerCase();

    if (keyword.isNotEmpty) {
      result = result.where((order) {
        return order.customerName.toLowerCase().contains(keyword);
      }).toList();
    }

    if (selectedStatus.value != "Semua") {
      result = result.where((order) {
        return order.status == selectedStatus.value;
      }).toList();
    }

    filteredOrders.assignAll(result);
  }

  /// ===============================
  /// CHANGE FILTER
  /// ===============================
  void changeStatusFilter(String status) {
    selectedStatus.value = status;

    filterOrders();
  }

  /// ===============================
  /// GET DETAIL ORDER
  /// ===============================
  Future<AdminOrderModel?> getOrderDetail(String id) async {
    try {
      return await AdminService.getOrderDetail(id);
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.TOP);

      return null;
    }
  }

  /// ===============================
  /// UPDATE STATUS
  /// ===============================
  Future<void> updateStatus({
    required String orderId,
    required String status,
  }) async {
    try {
      isLoading.value = true;

      final success = await AdminService.updateOrderStatus(
        id: orderId,
        status: status,
      );

      if (success) {
        Get.back();

        Get.snackbar(
          "Berhasil",
          "Status pesanan berhasil diperbarui.",
          snackPosition: SnackPosition.TOP,
        );

        await loadOrders();
      } else {
        Get.snackbar(
          "Gagal",
          "Status pesanan gagal diperbarui.",
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.TOP);
    } finally {
      isLoading.value = false;
    }
  }

  /// ===============================
  /// DIALOG UPDATE STATUS
  /// ===============================
  void showStatusDialog(AdminOrderModel order) {
    String selected = order.status;

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),

        title: const Text(
          "Ubah Status",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),

        contentPadding: const EdgeInsets.fromLTRB(22, 10, 22, 16),

        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.green.shade50,
                  child: const Icon(
                    Icons.local_shipping_rounded,
                    color: Colors.green,
                    size: 28,
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  "Pilih status pesanan baru",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),

                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),

                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: DropdownButton<String>(
                    isExpanded: true,
                    underline: const SizedBox(),

                    value: selected,

                    items: statusList
                        .where((e) => e != "Semua")
                        .map(
                          (status) => DropdownMenuItem(
                            value: status,
                            child: Text(
                              status,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        )
                        .toList(),

                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selected = value;
                        });
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),

        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 90,
                height: 38,
                child: OutlinedButton(
                  onPressed: () {
                    Get.back();
                  },

                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.green),

                    foregroundColor: Colors.green,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),

                    padding: EdgeInsets.zero,
                  ),

                  child: const Text(
                    "Batal",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              SizedBox(
                width: 90,
                height: 38,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();

                    updateStatus(orderId: order.id, status: selected);
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),

                    padding: EdgeInsets.zero,
                  ),

                  child: const Text(
                    "Simpan",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
