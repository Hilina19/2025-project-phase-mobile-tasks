import 'package:flutter/material.dart';

// Import for SharedPreferences and InternetConnectionChecker
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// Core imports
import 'core/api/api_client.dart'; // <-- Import the new client
import 'core/network/network_info.dart';
import 'core/network/network_info_impl.dart';

// Feature-specific imports
import 'features/product/data/datasources/product_local_data_source.dart';
import 'features/product/data/datasources/product_local_data_source_impl.dart';
import 'features/product/data/datasources/product_remote_data_source.dart';
import 'features/product/data/datasources/product_remote_data_source_impl.dart';
import 'features/product/data/repositories/product_repository_impl.dart';
import 'features/product/domain/repositories/product_repository.dart';
import 'features/product/domain/usecases/create_product.dart';
import 'features/product/domain/usecases/delete_product.dart';
import 'features/product/domain/usecases/update_product.dart';
import 'features/product/domain/usecases/view_all_products.dart';
import 'features/product/domain/usecases/view_product.dart';
import 'features/product/presentation/screens/home_screen.dart';

void main() async {
  // This line IS needed. It ensures that plugin services are
  // initialized before the app is run.
  WidgetsFlutterBinding.ensureInitialized();

  // ===== DEPENDENCY INJECTION =====

  // Core Dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  final networkInfo = NetworkInfoImpl(InternetConnectionChecker());

  // Create the ApiClient first, as it's a dependency for the data source
  final apiClient =
      ApiClient(client: http.Client()); // <-- Create the ApiClient

  // Data Layer Dependencies
  // Now, provide the ApiClient to the remote data source
  final ProductRemoteDataSource productRemoteDataSource =
      ProductRemoteDataSourceImpl(apiClient: apiClient); // <-- UPDATE THIS LINE

  final ProductLocalDataSource productLocalDataSource =
      ProductLocalDataSourceImpl(sharedPreferences: sharedPreferences);

  final ProductRepository productRepository = ProductRepositoryImpl(
    remoteDataSource: productRemoteDataSource,
    localDataSource: productLocalDataSource,
    networkInfo: networkInfo,
  );

  // Domain Layer (Use Cases) - These remain unchanged
  final ViewAllProductsUseCase viewAllProductsUseCase =
      ViewAllProductsUseCase(productRepository);
  final ViewProductUseCase viewProductUseCase =
      ViewProductUseCase(productRepository);
  final CreateProductUseCase createProductUseCase =
      CreateProductUseCase(productRepository);
  final UpdateProductUseCase updateProductUseCase =
      UpdateProductUseCase(productRepository);
  final DeleteProductUseCase deleteProductUseCase =
      DeleteProductUseCase(productRepository);

  runApp(
    MyApp(
      viewAllProductsUseCase: viewAllProductsUseCase,
      viewProductUseCase: viewProductUseCase,
      createProductUseCase: createProductUseCase,
      updateProductUseCase: updateProductUseCase,
      deleteProductUseCase: deleteProductUseCase,
    ),
  );
}

class MyApp extends StatelessWidget {
  final ViewAllProductsUseCase viewAllProductsUseCase;
  final ViewProductUseCase viewProductUseCase;
  final CreateProductUseCase createProductUseCase;
  final UpdateProductUseCase updateProductUseCase;
  final DeleteProductUseCase deleteProductUseCase;

  const MyApp({
    super.key,
    required this.viewAllProductsUseCase,
    required this.viewProductUseCase,
    required this.createProductUseCase,
    required this.updateProductUseCase,
    required this.deleteProductUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eCommerce App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[50],
        fontFamily: 'Poppins',
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(
        viewAllProductsUseCase: viewAllProductsUseCase,
        viewProductUseCase: viewProductUseCase,
        createProductUseCase: createProductUseCase,
        updateProductUseCase: updateProductUseCase,
        deleteProductUseCase: deleteProductUseCase,
      ),
    );
  }
}
