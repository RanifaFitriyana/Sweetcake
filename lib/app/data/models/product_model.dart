class ProductModel {
  final String id;
  final String name;
  final String image;
  final String description;
  final String category;
  final int price;
  final double rating;

  ProductModel({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.category,
    required this.price,
    required this.rating,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["_id"],
      name: json["name"],
      image: json["image"],
      description: json["description"],
      category: json["category"],
      price: json["price"],
      rating: (json["rating"] as num).toDouble(),
    );
  }
}
