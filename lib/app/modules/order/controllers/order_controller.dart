import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/models/order_model.dart';
import '../../../data/services/order_service.dart';

class OrderController extends GetxController {
  /// ==========================
  /// STORAGE
  /// ==========================
  final box = GetStorage();

  /// ==========================
  /// LIST ORDER
  /// ==========================
  final RxList<OrderModel> orders = <OrderModel>[].obs;

  /// ==========================
  /// LOADING
  /// ==========================
  RxBool isLoading = false.obs;

  /// ==========================
  /// AMBIL PESANAN USER
  /// ==========================
  Future<void> getMyOrders() async {
    try {
      isLoading.value = true;

      final token = box.read("token");

      if (token == null) {
        Get.snackbar("Login", "Silakan login kembali.");
        return;
      }

      final result = await OrderService.getMyOrders(token: token);

      orders.assignAll(result);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// ==========================
  /// USER KONFIRMASI PESANAN SELESAI
  /// ==========================
  Future<void> completeOrder(String orderId) async {
    try {
      isLoading.value = true;

      final token = box.read("token");

      if (token == null) {
        Get.snackbar("Login", "Silakan login kembali.");
        return;
      }

      final success = await OrderService.updateOrderStatus(
        token: token,

        orderId: orderId,

        status: "Selesai",
      );

      if (success) {
        Get.snackbar("Berhasil", "Pesanan telah selesai diterima.");

        await getMyOrders();
      } else {
        Get.snackbar("Gagal", "Gagal mengubah status pesanan.");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// ==========================
  /// PESANAN AKTIF
  /// ==========================
  List<OrderModel> get activeOrders {
    return orders.where((order) => order.status != "Selesai").toList();
  }

  /// ==========================
  /// RIWAYAT PESANAN
  /// ==========================
  List<OrderModel> get historyOrders {
    return orders.where((order) => order.status == "Selesai").toList();
  }

  /// ==========================
  /// REFRESH
  /// ==========================
  Future<void> refreshOrders() async {
    await getMyOrders();
  }

  @override
  void onInit() {
    super.onInit();

    getMyOrders();
  }
}
