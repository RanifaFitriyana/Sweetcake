import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/models/user_model.dart';
import '../../../data/services/admin_user_service.dart';

class AdminUserController extends GetxController {
  /// ===================================
  /// STORAGE
  /// ===================================
  final box = GetStorage();

  /// ===================================
  /// LOADING
  /// ===================================
  RxBool isLoading = false.obs;

  /// ===================================
  /// SEARCH
  /// ===================================
  final searchController = TextEditingController();

  /// ===================================
  /// USER LIST
  /// ===================================
  RxList<UserModel> users = <UserModel>[].obs;

  RxList<UserModel> filteredUsers = <UserModel>[].obs;

  /// ===================================
  /// INIT
  /// ===================================
  @override
  void onInit() {
    super.onInit();

    getUsers();

    searchController.addListener(searchUser);
  }

  /// ===================================
  /// GET USERS
  /// ===================================
  Future<void> getUsers() async {
    try {
      isLoading.value = true;

      final token = box.read("token");

      if (token == null) {
        Get.snackbar("Error", "Token tidak ditemukan.");
        return;
      }

      final result = await AdminUserService.getUsers(token: token);

      users.assignAll(result);

      filteredUsers.assignAll(result);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// ===================================
  /// SEARCH USER
  /// ===================================
  void searchUser() {
    final keyword = searchController.text.toLowerCase().trim();

    if (keyword.isEmpty) {
      filteredUsers.assignAll(users);
      return;
    }

    filteredUsers.assignAll(
      users.where(
        (user) =>
            user.name.toLowerCase().contains(keyword) ||
            user.email.toLowerCase().contains(keyword) ||
            user.phone.toLowerCase().contains(keyword),
      ),
    );
  }

  /// ===================================
  /// REFRESH
  /// ===================================
  Future<void> refreshUsers() async {
    await getUsers();
  }

  /// ===================================
  /// DELETE USER
  /// ===================================
  Future<void> deleteUser(UserModel user) async {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),

        contentPadding: const EdgeInsets.fromLTRB(22, 20, 22, 16),

        content: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.red.shade50,

              child: const Icon(
                Icons.person_remove_rounded,
                color: Colors.red,
                size: 28,
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              "Konfirmasi Hapus",
              textAlign: TextAlign.center,

              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              "Apakah Anda yakin ingin menghapus akun\n'${user.name}'?",

              textAlign: TextAlign.center,

              style: const TextStyle(
                fontSize: 13,
                color: Colors.black54,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 22),

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

                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                SizedBox(
                  width: 90,
                  height: 38,

                  child: ElevatedButton(
                    onPressed: () async {
                      Get.back();

                      try {
                        isLoading.value = true;

                        final token = box.read("token");

                        if (token == null) return;

                        final success = await AdminUserService.deleteUser(
                          token: token,
                          id: user.id,
                        );

                        if (success) {
                          users.removeWhere((element) => element.id == user.id);

                          filteredUsers.removeWhere(
                            (element) => element.id == user.id,
                          );

                          Get.snackbar(
                            "Berhasil",
                            "User berhasil dihapus.",
                            snackPosition: SnackPosition.TOP,
                          );
                        }
                      } catch (e) {
                        Get.snackbar(
                          "Error",
                          e.toString(),
                          snackPosition: SnackPosition.TOP,
                        );
                      } finally {
                        isLoading.value = false;
                      }
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),

                      padding: EdgeInsets.zero,
                    ),

                    child: const Text(
                      "Hapus",

                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  /// ===================================
  /// CLOSE
  /// ===================================
  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
