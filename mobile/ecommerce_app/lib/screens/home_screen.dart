import 'package:flutter/material.dart';

import '../models/product.dart';
import 'product_detail_screen.dart';
import 'product_form_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<Product> products;
  final void Function(String id) onDelete;

  HomeScreen({required this.products, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: products.isEmpty
          ? Center(child: Text('No products yet!'))
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (ctx, i) {
                final product = products[i];
                return ListTile(
                  title: Text(product.title),
                  subtitle: Text(
                    product.description.length > 50
                        ? product.description.substring(0, 50) + '...'
                        : product.description,
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      ProductDetailScreen.routeName,
                      arguments: product,
                    );
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => onDelete(product.id),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, ProductFormScreen.routeName);
        },
      ),
    );
  }
}
