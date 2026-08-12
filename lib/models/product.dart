class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageURL;
  final String catergory;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageURL,
    required this.catergory,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: (json['id'] as int).toString(),
      name: json['name'] as String,
      description: json['description'] as String,
      price: json['price'] as double,
      imageURL: json['imageUrl'] as String,
      catergory: json['category'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "price": price,
      "imageURL": imageURL,
      "category": catergory,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      "User(id: $id, name: $name, description: $description, price: $price)";
}
