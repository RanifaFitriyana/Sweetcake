import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/admin_user_controller.dart';

class AdminUserView extends GetView<AdminUserController> {
  const AdminUserView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AdminUserView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AdminUserView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
