import 'dart:convert';

import '../models/user_model.dart';
import 'api_service.dart';

class AdminUserService {
  /// ===================================
  /// GET ALL USERS
  /// ===================================
  static Future<List<UserModel>> getUsers({required String token}) async {
    final response = await ApiService.getAdminUsers(token: token);

    print("GET ADMIN USERS");
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      final List data = json["data"];

      return data.map((e) => UserModel.fromJson(e)).toList();
    }

    throw Exception(response.body);
  }

  /// ===================================
  /// DELETE USER
  /// ===================================
  static Future<bool> deleteUser({
    required String token,
    required String id,
  }) async {
    final response = await ApiService.deleteAdminUser(token: token, id: id);

    print("DELETE USER");
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      return true;
    }

    throw Exception(response.body);
  }
}
