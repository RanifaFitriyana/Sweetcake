import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  /// Base URL
  static const String baseUrl = "http://192.168.1.18:3000/api";

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
  /// GET ALL PRODUCTS
  /// ==========================
  static Future<http.Response> getProducts() async {
    return await http.get(
      Uri.parse("$baseUrl/products"),
      headers: {"Content-Type": "application/json"},
    );
  }

  /// ==========================
  /// GET ALL BEST PRODUCTS 
  /// ==========================
  static Future<http.Response> getBestProducts() async {
  return await http.get(
    Uri.parse("$baseUrl/products/best"),
    headers: {
      "Content-Type": "application/json",
    },
  );
}
}
