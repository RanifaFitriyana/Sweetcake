import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_service.dart';

class AccountService {
  static Future<bool> updateProfile({
    required String token,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.patch(
        Uri.parse("${ApiService.baseUrl}/account/profile"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"email": email, "password": password}),
      );

      print("===== UPDATE PROFILE =====");
      print("Status : ${response.statusCode}");
      print("Body   : ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      print("ERROR : $e");
      rethrow;
    }
  }
}
