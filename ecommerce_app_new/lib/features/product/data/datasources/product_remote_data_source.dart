import '../models/product_model.dart';

// This is the contract for our remote data source.
// It defines the methods that any remote data source implementation must have.
abstract class ProductRemoteDataSource {
  /// Calls the [API_ENDPOINT]/products endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<ProductModel>> getAllProducts();

  /// Calls the [API_ENDPOINT]/products/{id} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<ProductModel> getProduct(String id);

  /// Calls the [API_ENDPOINT]/products endpoint with a new product.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<void> createProduct(ProductModel product);

  /// Calls the [API_ENDPOINT]/products/{id} endpoint to update a product.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<void> updateProduct(ProductModel product);

  /// Calls the [API_ENDPOINT]/products/{id} endpoint to delete a product.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<void> deleteProduct(String id);
}
