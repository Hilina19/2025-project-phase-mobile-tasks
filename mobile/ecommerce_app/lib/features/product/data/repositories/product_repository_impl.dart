import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../models/product_model.dart';

// This is the implementation of the repository contract.
// It uses an in-memory list for demonstration purposes.
// A real app would use a remote data source (API) and/or a local data source (database).
class ProductRepositoryImpl implements ProductRepository {
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
  ];

  @override
  Future<void> createProduct(Product product) async {
    _products.add(ProductModel(
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
    ));
  }

  @override
  Future<void> deleteProduct(String id) async {
    _products.removeWhere((p) => p.id == id);
  }

  @override
  Future<List<Product>> getAllProducts() async {
    // The implementation returns the list of models, which are also Products.
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
      _products[index] = ProductModel(
        id: product.id,
        name: product.name,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
    }
  }
}
