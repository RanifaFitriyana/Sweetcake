class AdminOrderModel {
  final String id;
  final String userId;

  final String customerName;
  final String phone;
  final String address;

  final double latitude;
  final double longitude;

  final String paymentMethod;
  final String paymentProof;

  final List<OrderItemModel> items;

  final int total;

  final String status;

  final DateTime createdAt;
  final DateTime updatedAt;

  AdminOrderModel({
    required this.id,
    required this.userId,
    required this.customerName,
    required this.phone,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.paymentMethod,
    required this.paymentProof,
    required this.items,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdminOrderModel.fromJson(Map<String, dynamic> json) {
    return AdminOrderModel(
      id: json["_id"] ?? "",
      userId: json["userId"] is Map
          ? json["userId"]["_id"] ?? ""
          : json["userId"] ?? "",

      customerName: json["customerName"] ?? "",
      phone: json["phone"] ?? "",
      address: json["address"] ?? "",

      latitude: (json["latitude"] ?? 0).toDouble(),
      longitude: (json["longitude"] ?? 0).toDouble(),

      paymentMethod: json["paymentMethod"] ?? "",
      paymentProof: json["paymentProof"] ?? "",

      total: json["total"] ?? 0,

      status: json["status"] ?? "",

      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),

      items: json["items"] == null
          ? []
          : List<OrderItemModel>.from(
              json["items"].map((x) => OrderItemModel.fromJson(x)),
            ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
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
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }
}

class OrderItemModel {
  final String productId;
  final String name;
  final String image;
  final int price;
  final int qty;

  OrderItemModel({
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
    required this.qty,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json["productId"] ?? "",
      name: json["name"] ?? "",
      image: json["image"] ?? "",
      price: json["price"] ?? 0,
      qty: json["qty"] ?? 0,
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
