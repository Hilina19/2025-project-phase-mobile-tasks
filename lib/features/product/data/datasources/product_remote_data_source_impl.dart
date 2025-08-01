import '../../../../core/api/api_client.dart'; // <-- Import the new client
import '../models/product_model.dart';
import 'product_remote_data_source.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiClient apiClient; // <-- Depend on ApiClient, not http.Client

  ProductRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ProductModel>> getAllProducts() async {
    final data = await apiClient.get('/products');
    final List<dynamic> productsJson = data['products'];
    return productsJson.map((json) => ProductModel.fromJson(json)).toList();
  }

  @override
  Future<ProductModel> getProduct(String id) async {
    final data = await apiClient.get('/products/$id');
    return ProductModel.fromJson(data);
  }

  @override
  Future<void> createProduct(ProductModel product) async {
    await apiClient.post('/products/add', body: product.toJson());
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    // The DummyJSON API doesn't truly support update, but this shows the pattern
    // In a real API, you would likely use a PUT or PATCH request.
    // For now, we simulate it with a POST.
    await apiClient.post('/products/${product.id}', body: product.toJson());
  }

  @override
  Future<void> deleteProduct(String id) async {
    // The DummyJSON API doesn't truly support delete, but this shows the pattern
    await apiClient.get('/products/$id'); // Simulating a delete check
  }
}
