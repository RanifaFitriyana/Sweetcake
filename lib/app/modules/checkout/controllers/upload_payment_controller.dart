import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/models/order_model.dart';
import '../../../data/services/order_service.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../../routes/app_pages.dart';

class UploadPaymentController extends GetxController {
  /// ==========================
  /// STORAGE
  /// ==========================
  final box = GetStorage();

  /// ==========================
  /// IMAGE PICKER
  /// ==========================
  final ImagePicker picker = ImagePicker();

  Rx<File?> paymentProof = Rx<File?>(null);

  RxBool isLoading = false.obs;

  /// ==========================
  /// DATA ORDER DARI CHECKOUT
  /// ==========================
  late OrderModel order;

  final CartController cartController = Get.find<CartController>();

  @override
  void onInit() {
    super.onInit();

    /// ambil data dari checkout
    if (Get.arguments != null) {
      order = Get.arguments as OrderModel;
    }
  }

  /// ==========================
  /// PILIH GALERI
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
  /// AMBIL KAMERA
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
  /// UPLOAD & CREATE ORDER
  /// ==========================
  Future<void> uploadPaymentProof() async {
    if (paymentProof.value == null) {
      Get.snackbar(
        "Peringatan",

        "Silakan upload bukti pembayaran.",

        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    try {
      isLoading.value = true;

      final token = box.read("token");

      if (token == null) {
        Get.snackbar("Error", "Silakan login kembali.");

        return;
      }

      /// sementara simpan path gambar
      /// nanti bisa diganti upload multer/cloudinary

      final updatedOrder = OrderModel(
        customerName: order.customerName,

        phone: order.phone,

        address: order.address,

        latitude: order.latitude,

        longitude: order.longitude,

        paymentMethod: order.paymentMethod,

        paymentProof: paymentProof.value!.path,

        items: order.items,

        total: order.total,

        status: "Menunggu Verifikasi",
      );

      final success = await OrderService.createOrder(
        token: token,

        order: updatedOrder,
      );

      if (!success) {
        Get.snackbar("Gagal", "Pesanan gagal dibuat.");

        return;
      }

      /// hapus isi keranjang

      cartController.clearCart();

      Get.snackbar("Berhasil", "Pesanan berhasil dibuat.");

      Get.offAllNamed(Routes.SUCCESS);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
