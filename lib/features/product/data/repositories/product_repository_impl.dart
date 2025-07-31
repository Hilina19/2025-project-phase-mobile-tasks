import '../models/product_model.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<List<Product>> getAllProducts() async {
    try {
      final remoteProducts = await remoteDataSource.getAllProducts();
      return remoteProducts;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Product> getProduct(String id) async {
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
