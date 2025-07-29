import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  final Product? product;

  ProductDetailScreen({this.product});

  @override
  Widget build(BuildContext context) {
    final productArg =
        product ?? ModalRoute.of(context)!.settings.arguments as Product?;

    if (productArg == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Product Detail')),
        body: Center(child: Text('No product data')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(productArg.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(productArg.description),
      ),
    );
  }
}
