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

    Get.defaultDialog(
      backgroundColor: Colors.white,
      radius: 16,
      title: "Ubah Status",
      titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      content: StatefulBuilder(
        builder: (context, setState) {
          return DropdownButton<String>(
            isExpanded: true,
            value: selected,
            items: statusList
                .where((e) => e != "Semua")
                .map(
                  (status) =>
                      DropdownMenuItem(value: status, child: Text(status)),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selected = value;
                });
              }
            },
          );
        },
      ),
      textCancel: "Batal",
      textConfirm: "Simpan",
      confirmTextColor: Colors.white,
      buttonColor: Colors.green,
      onConfirm: () {
        updateStatus(orderId: order.id, status: selected);
      },
    );
  }
}
