import '../entities/product.dart';

// This is the contract that the Data layer must follow.
abstract class ProductRepository {
  Future<List<Product>> getAllProducts();
  Future<Product> getProduct(String id);
  Future<void> createProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(String id);
}
