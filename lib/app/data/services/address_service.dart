import 'dart:convert';

import 'package:get_storage/get_storage.dart';

import '../models/address_model.dart';
import 'api_service.dart';

class AddressService {
  static final box = GetStorage();

  /// ==========================
  /// GET ADDRESS USER
  /// ==========================
  static Future<List<AddressModel>> getAddresses() async {
    final token = box.read("token");

    final response = await ApiService.getAddresses(token: token);

    print("GET ADDRESS STATUS");
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      List data = json["data"];

      return data.map((e) => AddressModel.fromJson(e)).toList();
    }

    throw Exception(response.body);
  }

  /// ==========================
  /// CREATE ADDRESS
  /// ==========================
  static Future<bool> createAddress(AddressModel address) async {
    final token = box.read("token");

    final response = await ApiService.createAddress(
      token: token,
      data: address.toJson(),
    );

    print("CREATE ADDRESS STATUS");
    print(response.statusCode);
    print(response.body);

    return response.statusCode == 201;
  }

  /// ==========================
  /// UPDATE ADDRESS
  /// ==========================
  static Future<bool> updateAddress(String id, AddressModel address) async {
    final token = box.read("token");

    final response = await ApiService.updateAddress(
      token: token,
      id: id,
      data: address.toJson(),
    );

    return response.statusCode == 200;
  }

  /// ==========================
  /// DELETE ADDRESS
  /// ==========================
  static Future<bool> deleteAddress(String id) async {
    final token = box.read("token");

    final response = await ApiService.deleteAddress(token: token, id: id);

    return response.statusCode == 200;
  }

  /// ==========================
  /// SET DEFAULT
  /// ==========================
  static Future<bool> setDefaultAddress(String id) async {
    final token = box.read("token");

    final response = await ApiService.setDefaultAddress(token: token, id: id);

    return response.statusCode == 200;
  }
}
