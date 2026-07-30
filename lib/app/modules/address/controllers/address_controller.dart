import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../../data/models/address_model.dart';
import '../../../data/services/address_service.dart';

class AddressController extends GetxController {
  /// ==========================
  /// LIST ALAMAT
  /// ==========================
  final RxList<AddressModel> addresses = <AddressModel>[].obs;

  RxBool isLoading = false.obs;

  /// ==========================
  /// FORM
  /// ==========================
  final labelController = TextEditingController();
  final receiverController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final noteController = TextEditingController();

  /// ==========================
  /// KOORDINAT GPS
  /// ==========================
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;

  /// ==========================
  /// DEFAULT ADDRESS
  /// ==========================
  RxBool isDefault = false.obs;

  /// ==========================
  /// EDIT ADDRESS
  /// ==========================
  Rx<AddressModel?> selectedAddress = Rx<AddressModel?>(null);

  @override
  void onInit() {
    super.onInit();

    getAddresses();
  }

  /// ==========================
  /// GET SEMUA ALAMAT USER
  /// ==========================
  Future<void> getAddresses() async {
    try {
      isLoading.value = true;

      addresses.value = await AddressService.getAddresses();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// ==========================
  /// AMBIL GPS
  /// ==========================
  Future<void> getLocation() async {
    bool enabled = await Geolocator.isLocationServiceEnabled();

    if (!enabled) {
      Get.snackbar("GPS", "GPS belum aktif");

      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar("Lokasi", "Izin lokasi ditolak");

      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    latitude.value = position.latitude;

    longitude.value = position.longitude;

    List<Placemark> places = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (places.isNotEmpty) {
      final place = places.first;

      addressController.text =
          "${place.street ?? ""}, "
          "${place.subLocality ?? ""}, "
          "${place.locality ?? ""}, "
          "${place.administrativeArea ?? ""}";
    }
  }

  /// ==========================
  /// SIMPAN ALAMAT
  /// ==========================
  Future<void> saveAddress() async {
    if (labelController.text.trim().isEmpty ||
        receiverController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty) {
      Get.snackbar("Peringatan", "Semua data wajib diisi.");

      return;
    }

    if (latitude.value == 0 && longitude.value == 0) {
      Get.snackbar("Peringatan", "Silakan ambil lokasi GPS terlebih dahulu.");

      return;
    }

    final address = AddressModel(
      id: selectedAddress.value?.id,

      label: labelController.text,

      receiverName: receiverController.text,

      phone: phoneController.text,

      address: addressController.text,

      note: noteController.text,

      latitude: latitude.value,

      longitude: longitude.value,

      isDefault: isDefault.value,
    );

    bool success;

    if (selectedAddress.value == null) {
      success = await AddressService.createAddress(address);
    } else {
      success = await AddressService.updateAddress(
        selectedAddress.value!.id!,
        address,
      );
    }

    if (success) {
      await getAddresses();

      clearForm();

      Get.back();

      Get.snackbar("Berhasil", "Alamat berhasil disimpan.");
    } else {
      Get.snackbar("Gagal", "Alamat gagal disimpan.");
    }
  }

  /// ==========================
  /// EDIT
  /// ==========================
  void editAddress(AddressModel address) {
    selectedAddress.value = address;

    labelController.text = address.label;

    receiverController.text = address.receiverName;

    phoneController.text = address.phone;

    addressController.text = address.address;

    noteController.text = address.note;

    latitude.value = address.latitude;

    longitude.value = address.longitude;

    isDefault.value = address.isDefault;
  }

  /// ==========================
  /// DELETE
  /// ==========================
  Future<void> deleteAddress(String id) async {
    bool success = await AddressService.deleteAddress(id);

    if (success) {
      await getAddresses();

      Get.snackbar("Berhasil", "Alamat dihapus.");
    }
  }

  /// ==========================
  /// DEFAULT ADDRESS
  /// ==========================
  Future<void> setDefault(String id) async {
    bool success = await AddressService.setDefaultAddress(id);

    if (success) {
      await getAddresses();
    }
  }

  /// ==========================
  /// CLEAR FORM
  /// ==========================
  void clearForm() {
    selectedAddress.value = null;

    labelController.clear();

    receiverController.clear();

    phoneController.clear();

    addressController.clear();

    noteController.clear();

    latitude.value = 0;

    longitude.value = 0;

    isDefault.value = false;
  }

  @override
  void onClose() {
    labelController.dispose();

    receiverController.dispose();

    phoneController.dispose();

    addressController.dispose();

    noteController.dispose();

    super.onClose();
  }
}
