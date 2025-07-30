// lib/data/repositories/product_repository_impl.dart

import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

// This is the concrete implementation of the repository.
// It manages the actual data, in this case, an in-memory list.
class ProductRepositoryImpl implements ProductRepository {
  // Our in-memory database.
  final List<Product> _products = [
    Product(
      id: 'p1',
      name: 'Derby Leather Shoes',
      description: 'A classic and versatile footwear option.',
      price: 120.0,
      imageUrl:
          'https://images.pexels.com/photos/267301/pexels-photo-267301.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    ),
    Product(
      id: 'p2',
      name: 'Classic Black Heels',
      description: 'Timeless black high heels for a sophisticated look.',
      price: 150.0,
      imageUrl:
          'https://images.pexels.com/photos/1445696/pexels-photo-1445696.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    ),
  ];

  @override
  Future<void> createProduct(Product product) async {
    _products.add(product);
  }

  @override
  Future<void> deleteProduct(String id) async {
    _products.removeWhere((p) => p.id == id);
  }

  @override
  Future<List<Product>> getAllProducts() async {
    // In a real app, this would make an API call.
    return _products;
  }

  @override
  Future<Product> getProduct(String id) async {
    return _products.firstWhere((p) => p.id == id);
  }

  @override
  Future<void> updateProduct(Product product) async {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
    }
  }
}
