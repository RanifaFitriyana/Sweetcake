import 'dart:convert';

import '../models/order_model.dart';
import 'api_service.dart';

class OrderService {
  /// ==========================
  /// CREATE ORDER
  /// ==========================
  static Future<bool> createOrder({
    required String token,

    required OrderModel order,
  }) async {
    final response = await ApiService.createOrder(
      token: token,

      data: order.toJson(),
    );

    print("CREATE ORDER");
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 201) {
      return true;
    }

    throw Exception(response.body);
  }

  /// ==========================
  /// GET MY ORDERS
  /// ==========================
  static Future<List<OrderModel>> getMyOrders({required String token}) async {
    final response = await ApiService.getMyOrders(token: token);

    print("GET MY ORDERS");
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      List data = json["data"];

      return data.map((e) => OrderModel.fromJson(e)).toList();
    }

    throw Exception(response.body);
  }

  /// ==========================
  /// UPDATE STATUS ORDER
  /// ==========================
  static Future<bool> updateOrderStatus({
    required String token,

    required String orderId,

    required String status,
  }) async {
    final response = await ApiService.updateOrderStatus(
      token: token,

      orderId: orderId,

      status: status,
    );

    print("UPDATE STATUS");
    print(response.statusCode);
    print(response.body);

    return response.statusCode == 200;
  }
}
