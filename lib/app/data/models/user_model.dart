class UserModel {
  final String id;

  final String name;

  final String email;

  final String phone;

  final String role;

  final DateTime createdAt;

  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["_id"] ?? "",

      name: json["name"] ?? "",

      email: json["email"] ?? "",

      phone: json["phone"] ?? "",

      role: json["role"] ?? "",

      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
          : DateTime.now(),

      updatedAt: json["updatedAt"] != null
          ? DateTime.parse(json["updatedAt"])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,

      "name": name,

      "email": email,

      "phone": phone,

      "role": role,

      "createdAt": createdAt.toIso8601String(),

      "updatedAt": updatedAt.toIso8601String(),
    };
  }
}
