import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/product_form_screen.dart';
import 'models/product.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Product> _products = [];

  void _addOrUpdateProduct(Product product) {
    final index = _products.indexWhere((p) => p.id == product.id);
    setState(() {
      if (index >= 0) {
        _products[index] = product;
      } else {
        _products.add(product);
      }
    });
  }

  void _deleteProduct(String id) {
    setState(() {
      _products.removeWhere((p) => p.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Ecommerce',
      theme: ThemeData(primarySwatch: Colors.blue),
      routes: {
        '/': (ctx) => HomeScreen(
              products: _products,
              onDelete: _deleteProduct,
            ),
        ProductFormScreen.routeName: (ctx) =>
            ProductFormScreen(onSave: _addOrUpdateProduct),
        ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == ProductFormScreen.routeName) {
          final product = settings.arguments as Product?;
          return MaterialPageRoute(
            builder: (ctx) => ProductFormScreen(
              onSave: _addOrUpdateProduct,
              existingProduct: product,
            ),
            settings: settings,
          );
        }
        if (settings.name == ProductDetailScreen.routeName) {
          final product = settings.arguments as Product;
          return MaterialPageRoute(
            builder: (ctx) => ProductDetailScreen(product: product),
            settings: settings,
          );
        }
        return null;
      },
    );
  }
}
