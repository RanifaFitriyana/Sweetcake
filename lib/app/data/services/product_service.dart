import 'dart:convert';

import '../models/product_model.dart';
import 'api_service.dart';

class ProductService {
  static Future<List<ProductModel>> getProducts() async {
    final response = await ApiService.getProducts();

    print("Status Code : ${response.statusCode}");
    print("Response : ${response.body}");

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      List data = json["data"];

      return data.map((e) => ProductModel.fromJson(e)).toList();
    }

    throw Exception(response.body);
  }

  static Future<List<ProductModel>> getBestProducts() async {
    final response = await ApiService.getBestProducts();

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      List data = json["data"];

      return data.map((e) => ProductModel.fromJson(e)).toList();
    }

    throw Exception("Gagal mengambil produk terlaris");
  }
}
