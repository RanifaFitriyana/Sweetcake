import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../theme/app_colors.dart';
import '../../../widgets/admin_bottom_navbar.dart';
import '../controllers/admin_user_controller.dart';

class AdminUserView extends GetView<AdminUserController> {
  const AdminUserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Kelola User",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),

      bottomNavigationBar: const AdminBottomNavbar(currentIndex: 3),

      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && controller.users.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: controller.refreshUsers,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ==========================
                  /// SEARCH
                  /// ==========================
                  TextField(
                    controller: controller.searchController,
                    decoration: InputDecoration(
                      hintText: "Cari user...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// ==========================
                  /// TOTAL USER
                  /// ==========================
                  Text(
                    "Total User : ${controller.filteredUsers.length}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// ==========================
                  /// EMPTY
                  /// ==========================
                  if (controller.filteredUsers.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 80),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 70,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 12),
                            Text("Belum ada user."),
                          ],
                        ),
                      ),
                    )
                  /// ==========================
                  /// LIST USER
                  /// ==========================
                  else
                    ListView.builder(
                      itemCount: controller.filteredUsers.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final user = controller.filteredUsers[index];

                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 26,
                                  backgroundColor: AppColors.primary
                                      .withOpacity(.15),
                                  child: const Icon(
                                    Icons.person,
                                    color: AppColors.primary,
                                  ),
                                ),

                                const SizedBox(width: 14),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(height: 6),

                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.email,
                                            size: 15,
                                            color: Colors.grey,
                                          ),

                                          const SizedBox(width: 5),

                                          Expanded(
                                            child: Text(
                                              user.email,
                                              style: TextStyle(
                                                color: Colors.grey.shade700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 6),

                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.phone,
                                            size: 15,
                                            color: Colors.grey,
                                          ),

                                          const SizedBox(width: 5),

                                          Text(user.phone),
                                        ],
                                      ),

                                      const SizedBox(height: 6),

                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_today,
                                            size: 15,
                                            color: Colors.grey,
                                          ),

                                          const SizedBox(width: 5),

                                          Text(
                                            DateFormat(
                                              "dd MMM yyyy",
                                              "id_ID",
                                            ).format(user.createdAt),
                                            style: TextStyle(
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                IconButton(
                                  tooltip: "Hapus User",
                                  onPressed: () {
                                    controller.deleteUser(user);
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
