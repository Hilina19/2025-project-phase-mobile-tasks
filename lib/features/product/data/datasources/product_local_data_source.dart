import '../models/product_model.dart';

// This is the contract for our local data source (caching).
abstract class ProductLocalDataSource {
  /// Gets the cached [List<ProductModel>] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<List<ProductModel>> getLastProducts();

  /// Caches a [List<ProductModel>] to the local storage.
  Future<void> cacheProducts(List<ProductModel> productsToCache);
}
