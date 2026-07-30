import 'package:get/get.dart';

class AboutController extends GetxController {
  final appName = "SweetCake".obs;
  final version = "1.0.0".obs;

  final description =
      "SweetCake merupakan aplikasi penjualan kue yang menyediakan berbagai "
              "pilihan kue berkualitas seperti Birthday Cake, Cake Box, Cupcake, "
              "Cookies, dan berbagai dessert lainnya. Melalui aplikasi ini pelanggan "
              "dapat memesan kue secara online dengan mudah, memilih alamat pengiriman, "
              "menentukan metode pembayaran, serta memantau status pesanan secara real-time."
          .obs;
}
