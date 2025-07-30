// lib/main.dart

import 'package:flutter/material.dart';
import 'models/product.dart';
import 'screens/home_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/product_form_screen.dart';
import 'screens/search_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Product> _products = [
    Product(
      id: 'p1',
      name: 'Derby Leather Shoes',
      description:
          'A derby leather shoe is a classic and versatile footwear option characterized by its open lacing system, where the shoelace eyelets are sewn on top of the vamp (the upper part of the shoe). This design feature provides a more relaxed and casual look compared to the closed lacing system of oxford shoes. Derby shoes are typically made of high-quality leather, known for its durability and elegance, making them suitable for both formal and casual occasions. With their timeless style and comfortable fit, derby leather shoes are a staple in any well-rounded wardrobe.',
      price: 120.0,
      category: "Men's shoe",
      rating: 4.0,
      imageUrl:
          'https://images.pexels.com/photos/267301/pexels-photo-267301.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2', // Placeholder image
      sizes: [39, 40, 41, 42, 43, 44],
    ),
    Product(
      id: 'p4',
      name: 'Elegant Handbag',
      description:
          'A stylish and versatile leather handbag, perfect for any occasion. Features multiple compartments for easy organization.',
      price: 180.0,
      category: "Women's Bag",
      rating: 4.5,
      imageUrl:
          'https://images.pexels.com/photos/1152077/pexels-photo-1152077.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      sizes: [], // Bags don't have sizes, so we can leave this empty
    ),
    Product(
      id: 'p5',
      name: 'Classic white Heels',
      description:
          'Timeless black high heels that add a touch of sophistication to any outfit. Designed for both style and comfort.',
      price: 150.0,
      category: "Women's shoe",
      rating: 4.8,
      imageUrl:
          'https://images.pexels.com/photos/1445696/pexels-photo-1445696.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      sizes: [37, 38, 39, 40, 41],
    ),
  ];

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
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Poppins',
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        // *** THIS IS THE MAIN FIX ***
        // We now pass the functions directly to the HomeScreen constructor.
        '/': (ctx) => HomeScreen(
              products: _products,
              onSave: _addOrUpdateProduct,
              onDelete: _deleteProduct,
            ),
        SearchScreen.routeName: (ctx) => SearchScreen(products: _products),
      },
      onGenerateRoute: (settings) {
        if (settings.name == ProductDetailScreen.routeName) {
          final args = settings.arguments as Map<String, dynamic>;
          final product = args['product'] as Product;
          // The onDelete function is now passed from the HomeScreen
          final onDelete = args['onDelete'] as void Function(String);

          return MaterialPageRoute(
            builder: (ctx) {
              return ProductDetailScreen(product: product, onDelete: onDelete);
            },
          );
        }
        if (settings.name == ProductFormScreen.routeName) {
          final args = settings.arguments as Map<String, dynamic>;
          // The onSave function is now passed from the HomeScreen
          final onSave = args['onSave'] as void Function(Product);
          final product = args['product'] as Product?;
          final onDelete = args['onDelete'] as void Function(String)?;

          return MaterialPageRoute(
            builder: (ctx) {
              return ProductFormScreen(
                onSave: onSave,
                onDelete: onDelete,
                existingProduct: product,
              );
            },
          );
        }
        return null;
      },
    );
  }
}
