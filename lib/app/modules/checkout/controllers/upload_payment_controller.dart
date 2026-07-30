import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/models/order_model.dart';
import '../../../data/services/order_service.dart';
import '../../../routes/app_pages.dart';
import '../../cart/controllers/cart_controller.dart';

class UploadPaymentController extends GetxController {
  /// ==========================
  /// STORAGE
  /// ==========================
  final GetStorage box = GetStorage();

  /// ==========================
  /// IMAGE PICKER
  /// ==========================
  final ImagePicker picker = ImagePicker();

  Rx<File?> paymentProof = Rx<File?>(null);

  RxBool isLoading = false.obs;

  /// ==========================
  /// DATA ORDER
  /// ==========================
  late OrderModel order;

  final CartController cartController = Get.find<CartController>();

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null) {
      order = Get.arguments as OrderModel;
    }
  }

  /// ==========================
  /// PICK GALLERY
  /// ==========================
  Future<void> pickFromGallery() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      paymentProof.value = File(image.path);
    }
  }

  /// ==========================
  /// PICK CAMERA
  /// ==========================
  Future<void> pickFromCamera() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (image != null) {
      paymentProof.value = File(image.path);
    }
  }

  /// ==========================
  /// UPLOAD PAYMENT
  /// ==========================
  Future<void> uploadPaymentProof() async {
    if (paymentProof.value == null) {
      Get.snackbar("Peringatan", "Silakan upload bukti pembayaran.");
      return;
    }

    try {
      isLoading.value = true;

      final String? token = box.read("token");

      if (token == null || token.isEmpty) {
        Get.snackbar("Error", "Silakan login kembali.");
        return;
      }

      /// Upload gambar ke backend
      final String imageUrl = await OrderService.uploadPaymentProof(
        token: token,
        image: paymentProof.value!,
      );

      /// Buat object order baru dengan URL gambar
      final OrderModel updatedOrder = OrderModel(
        customerName: order.customerName,
        phone: order.phone,
        address: order.address,
        latitude: order.latitude,
        longitude: order.longitude,
        paymentMethod: order.paymentMethod,
        paymentProof: imageUrl,
        items: order.items,
        total: order.total,
        status: "Menunggu Verifikasi",
      );

      /// Simpan order
      final bool success = await OrderService.createOrder(
        token: token,
        order: updatedOrder,
      );

      if (!success) {
        Get.snackbar("Gagal", "Pesanan gagal dibuat.");
        return;
      }

      cartController.clearCart();

      Get.offAllNamed(Routes.SUCCESS);

      Get.snackbar("Berhasil", "Pesanan berhasil dibuat.");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
