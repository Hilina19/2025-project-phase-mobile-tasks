import '../../domain/entities/product.dart';
import '../models/product_model.dart';
import 'product_remote_data_source.dart';

// This is the concrete implementation of the remote data source contract.
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  // A mock list of products, simulating a remote API response.
  final List<ProductModel> _products = [
    ProductModel(
        id: '1',
        name: 'Nike Air Max',
        description: 'Comfortable and stylish running shoes.',
        price: 120.00,
        imageUrl: 'https://i.imgur.com/sIagB4m.png'),
    ProductModel(
        id: '2',
        name: 'Adidas Ultraboost',
        description: 'Responsive cushioning for everyday wear.',
        price: 180.00,
        imageUrl: 'https://i.imgur.com/gallery/x40q6.png'),
    ProductModel(
        id: '3',
        name: 'Puma Running Shoes',
        description: 'Lightweight and built for speed.',
        price: 100.00,
        imageUrl: 'https://i.imgur.com/sIagB4m.png'),
  ];

  @override
  Future<List<ProductModel>> getAllProducts() async {
    // In a real app, this would make an HTTP request to an API.
    // For now, we return our mock list after a short delay to simulate a network call.
    await Future.delayed(const Duration(seconds: 1));
    return _products;
  }

  @override
  Future<ProductModel> getProduct(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    return _products.firstWhere((product) => product.id == id);
  }

  @override
  Future<void> createProduct(ProductModel product) async {
    await Future.delayed(const Duration(seconds: 1));
    _products.add(product);
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    await Future.delayed(const Duration(seconds: 1));
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    _products.removeWhere((p) => p.id == id);
  }
}
