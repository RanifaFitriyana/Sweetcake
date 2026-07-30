import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  /// Base URL
  static const String baseUrl = "http://172.19.0.127:3000/api";

  /// ==========================
  /// REGISTER
  /// ==========================
  static Future<http.Response> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    return await http.post(
      Uri.parse("$baseUrl/auth/register"),

      headers: {"Content-Type": "application/json"},

      body: jsonEncode({
        "name": name,
        "email": email,
        "phone": phone,
        "password": password,
      }),
    );
  }

  /// ==========================
  /// LOGIN
  /// ==========================
  static Future<http.Response> login({
    required String email,
    required String password,
  }) async {
    return await http.post(
      Uri.parse("$baseUrl/auth/login"),

      headers: {"Content-Type": "application/json"},

      body: jsonEncode({"email": email, "password": password}),
    );
  }

  /// ==========================
  /// GET PRODUCTS
  /// ==========================
  static Future<http.Response> getProducts() async {
    return await http.get(
      Uri.parse("$baseUrl/products"),

      headers: {"Content-Type": "application/json"},
    );
  }

  /// ==========================
  /// GET BEST PRODUCTS
  /// ==========================
  static Future<http.Response> getBestProducts() async {
    return await http.get(
      Uri.parse("$baseUrl/products/best"),

      headers: {"Content-Type": "application/json"},
    );
  }

  /// ==========================
  /// CREATE ORDER
  /// ==========================
  static Future<http.Response> createOrder({
    required String token,
    required Map<String, dynamic> data,
  }) async {
    return await http.post(
      Uri.parse("$baseUrl/orders"),

      headers: {
        "Content-Type": "application/json",

        "Authorization": "Bearer $token",
      },

      body: jsonEncode(data),
    );
  }

  /// ==========================
  /// GET MY ORDERS
  /// ==========================
  static Future<http.Response> getMyOrders({required String token}) async {
    return await http.get(
      Uri.parse("$baseUrl/orders/my"),

      headers: {
        "Content-Type": "application/json",

        "Authorization": "Bearer $token",
      },
    );
  }

  /// ==========================
  /// UPDATE STATUS ORDER
  /// ==========================
  static Future<http.Response> updateOrderStatus({
    required String token,

    required String orderId,

    required String status,
  }) async {
    return await http.patch(
      Uri.parse("$baseUrl/orders/$orderId/status"),

      headers: {
        "Content-Type": "application/json",

        "Authorization": "Bearer $token",
      },

      body: jsonEncode({"status": status}),
    );
  }

  /// ==========================
  /// UPLOAD IMAGE
  /// ==========================
  static Future<http.StreamedResponse> uploadPaymentProof({
    required File image,

    required String token,
  }) async {
    var request = http.MultipartRequest("POST", Uri.parse("$baseUrl/upload"));

    request.headers["Authorization"] = "Bearer $token";

    request.files.add(await http.MultipartFile.fromPath("image", image.path));

    return await request.send();
  }

  /// ==========================
  /// ADDRESS
  /// ==========================

  static Future<http.Response> getAddresses({required String token}) async {
    return await http.get(
      Uri.parse("$baseUrl/address"),

      headers: {
        "Content-Type": "application/json",

        "Authorization": "Bearer $token",
      },
    );
  }

  static Future<http.Response> createAddress({
    required String token,

    required Map<String, dynamic> data,
  }) async {
    return await http.post(
      Uri.parse("$baseUrl/address"),

      headers: {
        "Content-Type": "application/json",

        "Authorization": "Bearer $token",
      },

      body: jsonEncode(data),
    );
  }

  static Future<http.Response> updateAddress({
    required String token,

    required String id,

    required Map<String, dynamic> data,
  }) async {
    return await http.put(
      Uri.parse("$baseUrl/address/$id"),

      headers: {
        "Content-Type": "application/json",

        "Authorization": "Bearer $token",
      },

      body: jsonEncode(data),
    );
  }

  static Future<http.Response> deleteAddress({
    required String token,

    required String id,
  }) async {
    return await http.delete(
      Uri.parse("$baseUrl/address/$id"),

      headers: {
        "Content-Type": "application/json",

        "Authorization": "Bearer $token",
      },
    );
  }

  static Future<http.Response> setDefaultAddress({
    required String token,

    required String id,
  }) async {
    return await http.patch(
      Uri.parse("$baseUrl/address/$id/default"),

      headers: {
        "Content-Type": "application/json",

        "Authorization": "Bearer $token",
      },
    );
  }

  /// ==========================
  /// UPDATE PROFILE
  /// ==========================
  static Future<http.Response> updateProfile({
    required String token,
    required String email,
    required String password,
  }) async {
    return await http.patch(
      Uri.parse("$baseUrl/account/profile"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"email": email, "password": password}),
    );
  }
}
