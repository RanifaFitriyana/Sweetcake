import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/app_colors.dart';
import '../controllers/order_controller.dart';

class OrderView extends GetView<OrderController> {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Pesanan Saya"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.receipt_long_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),

                  const SizedBox(height: 15),

                  Text(
                    "Belum ada pesanan",
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: controller.getMyOrders,

            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                MediaQuery.of(context).padding.bottom + 20,
              ),

              itemCount: controller.orders.length,

              itemBuilder: (context, index) {
                final order = controller.orders[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(color: Colors.grey.shade200, blurRadius: 8),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      /// STATUS
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(
                            child: Text(
                              "Status Pesanan",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),

                          const SizedBox(width: 10),

                          Flexible(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: statusBadge(order.status),
                            ),
                          ),
                        ],
                      ),

                      const Divider(),

                      /// PRODUK
                      const Text(
                        "Produk",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 10),

                      Column(
                        children: order.items.map((item) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),

                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),

                                  child: Image.network(
                                    item.image,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,

                                    errorBuilder: (_, __, ___) {
                                      return Container(
                                        width: 60,
                                        height: 60,
                                        color: Colors.grey.shade200,
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
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),

                                      const SizedBox(height: 5),

                                      Text(
                                        "${item.qty} x ${formatPrice(item.price)}",
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const Divider(),

                      /// ALAMAT
                      const Text(
                        "Alamat Pengiriman",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        order.address,
                        softWrap: true,
                        style: const TextStyle(height: 1.4),
                      ),

                      const SizedBox(height: 16),

                      /// TOTAL
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              "Total",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),

                          Flexible(
                            child: Text(
                              formatPrice(order.total),
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      /// BUTTON SELESAI
                      if (order.status == "Dalam Pengiriman")
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              controller.completeOrder(order.id!);
                            },
                            child: const Text(
                              "Pesanan Selesai",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }

  /// ==========================
  /// STATUS BADGE
  /// ==========================
  Widget statusBadge(String status) {
    Color color;

    switch (status) {
      case "Menunggu Verifikasi":
        color = Colors.orange;
        break;

      case "Diproses":
        color = Colors.blue;
        break;

      case "Dalam Pengiriman":
        color = Colors.purple;
        break;

      case "Selesai":
        color = Colors.green;
        break;

      case "Batal":
        color = Colors.red;
        break;

      default:
        color = Colors.grey;
    }

    return Container(
      constraints: const BoxConstraints(maxWidth: 140),

      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Text(
        status,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,

        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  /// ==========================
  /// FORMAT HARGA
  /// ==========================
  String formatPrice(int value) {
    final text = value.toString();

    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);

      final pos = text.length - i - 1;

      if (pos > 0 && pos % 3 == 0) {
        buffer.write(".");
      }
    }

    return "Rp $buffer";
  }
}
