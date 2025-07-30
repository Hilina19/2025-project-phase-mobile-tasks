// lib/domain/repositories/product_repository.dart

import '../entities/product.dart';

// This is an abstract class (an interface) that defines the contract
// for data operations related to products. The domain layer depends on this,
// not on a concrete implementation.
abstract class ProductRepository {
  Future<List<Product>> getAllProducts();
  Future<Product> getProduct(String id);
  Future<void> createProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(String id);
}
