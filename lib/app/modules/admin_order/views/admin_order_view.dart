import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/admin_order_controller.dart';

class AdminOrderView extends GetView<AdminOrderController> {
  const AdminOrderView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AdminOrderView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AdminOrderView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
