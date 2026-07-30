import 'package:get/get.dart';

import '../../../data/models/admin_order_model.dart';
import '../../../data/services/admin_service.dart';

class AdminOrderDetailController extends GetxController {
  /// =====================================
  /// DATA
  /// =====================================
  final order = Rxn<AdminOrderModel>();

  final isLoading = false.obs;
  final isSaving = false.obs;

  late final String orderId;

  final selectedStatus = "".obs;

  final List<String> statusList = const [
    "Menunggu Verifikasi",
    "Diproses",
    "Dikirim",
    "Selesai",
    "Dibatalkan",
  ];

  @override
  void onInit() {
    super.onInit();

    orderId = Get.arguments as String;

    loadOrder();
  }

  /// =====================================
  /// LOAD DETAIL ORDER
  /// =====================================
  Future<void> loadOrder() async {
    try {
      isLoading.value = true;

      final result = await AdminService.getOrderDetail(orderId);

      order.value = result;
      selectedStatus.value = result.status;
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.TOP);
    } finally {
      isLoading.value = false;
    }
  }

  /// =====================================
  /// REFRESH
  /// =====================================
  Future<void> refreshOrder() async {
    await loadOrder();
  }

  /// =====================================
  /// CHANGE STATUS
  /// =====================================
  void changeStatus(String? value) {
    if (value == null) return;

    selectedStatus.value = value;
  }

  /// =====================================
  /// SIMPAN STATUS
  /// =====================================
  Future<void> saveStatus() async {
    try {
      isSaving.value = true;

      final success = await AdminService.updateOrderStatus(
        id: orderId,
        status: selectedStatus.value,
      );

      if (success) {
        Get.snackbar(
          "Berhasil",
          "Status pesanan berhasil diperbarui.",
          snackPosition: SnackPosition.TOP,
        );

        await loadOrder();
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
      isSaving.value = false;
    }
  }
}
