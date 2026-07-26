import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Android Emulator
  static const String baseUrl = "http://172.19.0.127:3000/api";

  static Future<http.Response> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    return await http.post(
      Uri.parse("$baseUrl/auth/register"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "name": name,
        "email": email,
        "phone": phone,
        "password": password,
      }),
    );
  }
}