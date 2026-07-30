import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../../../data/services/admin_service.dart';
import '../../../routes/app_pages.dart';

class AdminDashboardController extends GetxController {
  final box = GetStorage();

  /// ===============================
  /// Dashboard Data
  /// ===============================
  RxInt totalProduct = 0.obs;
  RxInt totalOrder = 0.obs;
  RxInt totalUser = 0.obs;
  RxString totalIncome = "Rp 0".obs;

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboard();
  }

  /// ===============================
  /// LOAD DASHBOARD
  /// ===============================
  Future<void> loadDashboard() async {
    try {
      isLoading.value = true;

      final data = await AdminService.getDashboard();

      totalProduct.value = data["totalProduct"] ?? 0;
      totalOrder.value = data["totalOrder"] ?? 0;
      totalUser.value = data["totalUser"] ?? 0;

      final income = data["totalIncome"] ?? 0;

      totalIncome.value = NumberFormat.currency(
        locale: "id_ID",
        symbol: "Rp ",
        decimalDigits: 0,
      ).format(income);
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.TOP);
    } finally {
      isLoading.value = false;
    }
  }

  /// ===============================
  /// REFRESH DASHBOARD
  /// ===============================
  Future<void> refreshDashboard() async {
    await loadDashboard();
  }

  /// ===============================
  /// LOGOUT
  /// ===============================
  void logout() {
    box.erase();
    Get.offAllNamed(Routes.LOGIN);
  }
}
