import 'package:flutter/material.dart';

import 'features/product/data/repositories/product_repository_impl.dart';
import 'features/product/domain/repositories/product_repository.dart';
import 'features/product/domain/usecases/create_product.dart';
import 'features/product/domain/usecases/delete_product.dart';
import 'features/product/domain/usecases/update_product.dart';
import 'features/product/domain/usecases/view_all_products.dart';
import 'features/product/domain/usecases/view_product.dart';
import 'features/product/presentation/screens/home_screen.dart';

void main() {
  // ===== DEPENDENCY INJECTION =====
  // In a real app, this would be handled by a service locator like GetIt or a DI package.

  // Data Layer
  final ProductRepository productRepository = ProductRepositoryImpl();

  // Domain Layer (Use Cases)
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
