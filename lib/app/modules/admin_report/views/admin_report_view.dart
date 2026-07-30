import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/admin_report_controller.dart';

class AdminReportView extends GetView<AdminReportController> {
  const AdminReportView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AdminReportView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AdminReportView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
