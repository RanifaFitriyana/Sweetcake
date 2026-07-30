class OrderModel {
  final String? id;
  final String? userId;

  final String customerName;
  final String phone;
  final String address;

  final double latitude;
  final double longitude;

  final String paymentMethod;
  final String paymentProof;

  final List<OrderItem> items;

  final int total;

  final String status;

  final DateTime? createdAt;

  OrderModel({
    this.id,
    this.userId,
    required this.customerName,
    required this.phone,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.paymentMethod,
    required this.paymentProof,
    required this.items,
    required this.total,
    this.status = "Menunggu Verifikasi",
    this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json["_id"],
      userId: json["userId"]?.toString(),
      customerName: json["customerName"] ?? "",
      phone: json["phone"] ?? "",
      address: json["address"] ?? "",
      latitude: (json["latitude"] ?? 0).toDouble(),
      longitude: (json["longitude"] ?? 0).toDouble(),
      paymentMethod: json["paymentMethod"] ?? "",
      paymentProof: json["paymentProof"] ?? "",
      items: (json["items"] as List<dynamic>)
          .map((e) => OrderItem.fromJson(e))
          .toList(),
      total: json["total"] ?? 0,
      status: json["status"] ?? "Menunggu Verifikasi",
      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "customerName": customerName,
      "phone": phone,
      "address": address,
      "latitude": latitude,
      "longitude": longitude,
      "paymentMethod": paymentMethod,
      "paymentProof": paymentProof,
      "items": items.map((e) => e.toJson()).toList(),
      "total": total,
      "status": status,
    };
  }
}

class OrderItem {
  final String productId;
  final String name;
  final String image;
  final int price;
  final int qty;

  OrderItem({
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
    required this.qty,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json["productId"]?.toString() ?? "",
      name: json["name"] ?? "",
      image: json["image"] ?? "",
      price: json["price"] ?? 0,
      qty: json["qty"] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "productId": productId,
      "name": name,
      "image": image,
      "price": price,
      "qty": qty,
    };
  }
}
