import 'dart:convert';

import 'package:get_storage/get_storage.dart';

import '../models/admin_order_model.dart';
import '../models/product_model.dart';
import 'api_service.dart';

class AdminService {
  static final box = GetStorage();

  /// ===================================
  /// TOKEN
  /// ===================================
  static String get token => box.read("token") ?? "";

  /// ===================================
  /// DASHBOARD
  /// ===================================
  static Future<Map<String, dynamic>> getDashboard() async {
    final response = await ApiService.getAdminDashboard(token: token);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      return json["data"];
    }

    throw Exception(jsonDecode(response.body)["message"]);
  }

  /// ===================================
  /// GET PRODUCTS
  /// ===================================
  static Future<List<ProductModel>> getProducts() async {
    final response = await ApiService.getAdminProducts(token: token);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      return (json["data"] as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
    }

    throw Exception(jsonDecode(response.body)["message"]);
  }

  /// ===================================
  /// CREATE PRODUCT
  /// ===================================
  static Future<bool> createProduct({
    required Map<String, dynamic> data,
  }) async {
    final response = await ApiService.createAdminProduct(
      token: token,
      data: data,
    );

    return response.statusCode == 201;
  }

  /// ===================================
  /// UPDATE PRODUCT
  /// ===================================
  static Future<bool> updateProduct({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    final response = await ApiService.updateAdminProduct(
      token: token,
      id: id,
      data: data,
    );

    return response.statusCode == 200;
  }

  /// ===================================
  /// DELETE PRODUCT
  /// ===================================
  static Future<bool> deleteProduct(String id) async {
    final response = await ApiService.deleteAdminProduct(token: token, id: id);

    return response.statusCode == 200;
  }

  /// ===================================
  /// GET ALL ORDERS
  /// ===================================
  static Future<List<AdminOrderModel>> getOrders() async {
    final response = await ApiService.getAdminOrders(token: token);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      return (json["data"] as List)
          .map((e) => AdminOrderModel.fromJson(e))
          .toList();
    }

    throw Exception(jsonDecode(response.body)["message"]);
  }

  /// ===================================
  /// GET ORDER DETAIL
  /// ===================================
  static Future<AdminOrderModel> getOrderDetail(String id) async {
    final response = await ApiService.getAdminOrderDetail(token: token, id: id);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      return AdminOrderModel.fromJson(json["data"]);
    }

    throw Exception(jsonDecode(response.body)["message"]);
  }

  /// ===================================
  /// UPDATE STATUS ORDER
  /// ===================================
  static Future<bool> updateOrderStatus({
    required String id,
    required String status,
  }) async {
    final response = await ApiService.updateAdminOrderStatus(
      token: token,
      id: id,
      status: status,
    );

    return response.statusCode == 200;
  }
}
