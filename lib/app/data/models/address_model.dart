class AddressModel {
  final String? id;
  final String? userId;

  final String label;
  final String receiverName;
  final String phone;
  final String address;
  final String note;

  final double latitude;
  final double longitude;

  final bool isDefault;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  AddressModel({
    this.id,
    this.userId,
    required this.label,
    required this.receiverName,
    required this.phone,
    required this.address,
    this.note = "",
    required this.latitude,
    required this.longitude,
    this.isDefault = false,
    this.createdAt,
    this.updatedAt,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json["_id"],
      userId: json["userId"]?.toString(),

      label: json["label"] ?? "",
      receiverName: json["receiverName"] ?? "",
      phone: json["phone"] ?? "",
      address: json["address"] ?? "",
      note: json["note"] ?? "",

      latitude: (json["latitude"] ?? 0).toDouble(),
      longitude: (json["longitude"] ?? 0).toDouble(),

      isDefault: json["isDefault"] ?? false,

      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
          : null,

      updatedAt: json["updatedAt"] != null
          ? DateTime.parse(json["updatedAt"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "label": label,
      "receiverName": receiverName,
      "phone": phone,
      "address": address,
      "note": note,
      "latitude": latitude,
      "longitude": longitude,
      "isDefault": isDefault,
    };
  }

  AddressModel copyWith({
    String? id,
    String? userId,
    String? label,
    String? receiverName,
    String? phone,
    String? address,
    String? note,
    double? latitude,
    double? longitude,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AddressModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      label: label ?? this.label,
      receiverName: receiverName ?? this.receiverName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      note: note ?? this.note,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
