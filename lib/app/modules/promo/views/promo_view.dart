import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/promo_controller.dart';

class PromoView extends GetView<PromoController> {
  const PromoView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PromoView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PromoView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
