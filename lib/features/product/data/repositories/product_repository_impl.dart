// Import the new dependencies and exceptions
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/product_local_data_source.dart';
// Other existing imports
import '../models/product_model.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource; // <-- ADD
  final NetworkInfo networkInfo; // <-- ADD

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource, // <-- ADD
    required this.networkInfo, // <-- ADD
  });

  @override
  Future<List<Product>> getAllProducts() async {
    // Check if the user is connected to the internet.
    if (await networkInfo.isConnected) {
      try {
        // If online, get data from the remote API.
        final remoteProducts = await remoteDataSource.getAllProducts();
        // After getting the data, cache it locally for offline use.
        await localDataSource.cacheProducts(remoteProducts);
        // Return the fresh data from the API.
        return remoteProducts;
      } on ServerException {
        // If the server fails, rethrow the exception.
        rethrow;
      }
    } else {
      // If offline, try to get data from the local cache.
      try {
        final localProducts = await localDataSource.getLastProducts();
        return localProducts;
      } on CacheException {
        // If there's no cached data, rethrow the exception.
        rethrow;
      }
    }
  }

  // The other methods (create, update, delete) typically require an online connection.
  // For now, we will assume they only work when online and pass the call directly.
  // A more advanced implementation could queue these actions for when the user is back online.

  @override
  Future<Product> getProduct(String id) async {
    // This could also be enhanced with caching, but for now we keep it simple.
    return await remoteDataSource.getProduct(id);
  }

  @override
  Future<void> createProduct(Product product) async {
    final productModel = ProductModel.fromEntity(product);
    return await remoteDataSource.createProduct(productModel);
  }

  @override
  Future<void> updateProduct(Product product) async {
    final productModel = ProductModel.fromEntity(product);
    return await remoteDataSource.updateProduct(productModel);
  }

  @override
  Future<void> deleteProduct(String id) async {
    return await remoteDataSource.deleteProduct(id);
  }
}
