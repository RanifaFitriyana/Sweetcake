import 'dart:convert';

import 'package:get_storage/get_storage.dart';

import '../models/product_model.dart';
import 'api_service.dart';

class AdminService {
  static final box = GetStorage();

  /// ===================================
  /// GET DASHBOARD
  /// ===================================
  static Future<Map<String, dynamic>> getDashboard() async {
    final token = box.read("token");

    final response = await ApiService.getAdminDashboard(token: token);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      return json["data"];
    }

    throw Exception(jsonDecode(response.body)["message"]);
  }

  /// ===================================
  /// GET ALL PRODUCTS
  /// ===================================
  static Future<List<ProductModel>> getProducts() async {
    final token = box.read("token");

    final response = await ApiService.getAdminProducts(token: token);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      List data = json["data"];

      return data.map((e) => ProductModel.fromJson(e)).toList();
    }

    throw Exception(jsonDecode(response.body)["message"]);
  }

  /// ===================================
  /// CREATE PRODUCT
  /// ===================================
  static Future<bool> createProduct({
    required Map<String, dynamic> data,
  }) async {
    final token = box.read("token");

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
    final token = box.read("token");

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
    final token = box.read("token");

    final response = await ApiService.deleteAdminProduct(token: token, id: id);

    return response.statusCode == 200;
  }
}
