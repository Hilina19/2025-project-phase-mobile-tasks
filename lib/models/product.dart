// lib/models/product.dart

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final double rating;
  final String imageUrl;
  final List<int> sizes;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.rating,
    required this.imageUrl,
    required this.sizes,
  });
}
