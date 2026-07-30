import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/models/address_model.dart';
import '../../../data/models/order_model.dart';
import '../../../data/services/order_service.dart';
import '../../../routes/app_pages.dart';

import '../../address/controllers/address_controller.dart';
import '../../cart/controllers/cart_controller.dart';

class CheckoutController extends GetxController {
  /// ==========================
  /// DEPENDENCY
  /// ==========================

  final CartController cartController = Get.find<CartController>();

  final AddressController addressController = Get.find<AddressController>();

  final box = GetStorage();

  /// ==========================
  /// LOADING
  /// ==========================

  RxBool isLoading = false.obs;

  /// ==========================
  /// CUSTOMER DATA
  /// ==========================

  final nameController = TextEditingController();

  final phoneController = TextEditingController();

  /// ==========================
  /// ADDRESS
  /// ==========================

  Rx<AddressModel?> selectedAddress = Rx<AddressModel?>(null);

  RxBool useGps = false.obs;

  RxString address = "".obs;

  RxDouble latitude = 0.0.obs;

  RxDouble longitude = 0.0.obs;

  /// ==========================
  /// PAYMENT
  /// ==========================

  RxString paymentMethod = "Transfer Bank".obs;

  /// ==========================
  /// INIT
  /// ==========================

  @override
  void onInit() {
    super.onInit();

    nameController.text = box.read("name") ?? "";

    phoneController.text = box.read("phone") ?? "";

    loadDefaultAddress();
  }

  /// ==========================
  /// LOAD DEFAULT ADDRESS
  /// ==========================

  Future<void> loadDefaultAddress() async {
    if (addressController.addresses.isEmpty) {
      await addressController.getAddresses();
    }

    if (addressController.addresses.isNotEmpty) {
      final defaultAddress = addressController.addresses.firstWhere(
        (item) => item.isDefault,

        orElse: () => addressController.addresses.first,
      );

      selectAddress(defaultAddress);
    }
  }

  /// ==========================
  /// PAYMENT CHANGE
  /// ==========================

  void changePayment(dynamic value) {
    paymentMethod.value = value.toString();
  }

  /// ==========================
  /// SELECT ADDRESS
  /// ==========================

  void selectAddress(AddressModel value) {
    selectedAddress.value = value;

    address.value = value.address;

    latitude.value = value.latitude;

    longitude.value = value.longitude;

    useGps.value = false;
  }

  /// ==========================
  /// GET GPS LOCATION
  /// ==========================

  Future<void> getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      Get.snackbar("GPS", "GPS belum diaktifkan.");

      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar("Lokasi", "Izin lokasi ditolak.");

      return;
    }

    Position gpsPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    /// gunakan GPS

    useGps.value = true;

    /// hapus pilihan alamat

    selectedAddress.value = null;

    latitude.value = gpsPosition.latitude;

    longitude.value = gpsPosition.longitude;

    List<Placemark> places = await placemarkFromCoordinates(
      gpsPosition.latitude,

      gpsPosition.longitude,
    );

    final place = places.first;

    address.value =
        "${place.street}, "
        "${place.subLocality}, "
        "${place.locality}, "
        "${place.administrativeArea}";
  }

  /// ==========================
  /// VALIDATION
  /// ==========================

  bool validateCheckout() {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar("Peringatan", "Nama lengkap harus diisi.");

      return false;
    }

    if (phoneController.text.trim().isEmpty) {
      Get.snackbar("Peringatan", "Nomor HP harus diisi.");

      return false;
    }

    if (cartController.cartItems.isEmpty) {
      Get.snackbar("Peringatan", "Keranjang masih kosong.");

      return false;
    }

    if (address.value.isEmpty) {
      Get.snackbar("Peringatan", "Silakan pilih alamat atau gunakan GPS.");

      return false;
    }

    return true;
  }

  /// ==========================
  /// CREATE ORDER DATA
  /// ==========================

  OrderModel createOrderData() {
    final items = cartController.cartItems.map((item) {
      return OrderItem(
        productId: item["id"].toString(),

        name: item["name"],

        image: item["image"],

        price: item["price"],

        qty: item["qty"],
      );
    }).toList();

    return OrderModel(
      customerName: nameController.text.trim(),

      phone: phoneController.text.trim(),

      address: address.value,

      latitude: latitude.value,

      longitude: longitude.value,

      paymentMethod: paymentMethod.value,

      paymentProof: "",

      items: items,

      total: cartController.total,
    );
  }

  /// ==========================
  /// CREATE ORDER COD
  /// ==========================

  Future<void> createOrderCOD() async {
    if (!validateCheckout()) {
      return;
    }

    try {
      isLoading.value = true;

      final token = box.read("token");

      if (token == null) {
        Get.snackbar("Login", "Silakan login kembali.");

        Get.offAllNamed(Routes.LOGIN);

        return;
      }

      final order = createOrderData();

      final success = await OrderService.createOrder(
        token: token,

        order: order,
      );

      if (success) {
        cartController.clearCart();

        Get.snackbar("Berhasil", "Pesanan berhasil dibuat.");

        Get.offAllNamed(Routes.SUCCESS);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// ==========================
  /// PAYMENT DIALOG
  /// ==========================

  void showPaymentDialog() {
    if (!validateCheckout()) {
      return;
    }

    Get.defaultDialog(
      title: "Pembayaran",

      radius: 15,

      content: Column(
        children: [
          Text(
            paymentMethod.value == "COD"
                ? "Pesanan akan dibayar saat diterima."
                : "Silakan lakukan pembayaran.",

            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,

            child: ElevatedButton(
              onPressed: () async {
                Get.back();

                if (paymentMethod.value == "COD") {
                  await createOrderCOD();
                } else {
                  final order = createOrderData();

                  Get.toNamed(Routes.UPLOAD_PAYMENT, arguments: order);
                }
              },

              child: Text(
                paymentMethod.value == "COD"
                    ? "Konfirmasi Pesanan"
                    : "Upload Bukti Pembayaran",
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ==========================
  /// CLOSE
  /// ==========================

  @override
  void onClose() {
    nameController.dispose();

    phoneController.dispose();

    super.onClose();
  }
}
