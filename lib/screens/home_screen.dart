// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/product.dart';
import 'product_detail_screen.dart';
import 'product_form_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<Product> products;
  // Functions are now required properties of the HomeScreen widget
  final void Function(Product) onSave;
  final void Function(String) onDelete;

  const HomeScreen({
    super.key,
    required this.products,
    required this.onSave,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // We no longer need to get functions from ModalRoute here
    // as they are passed directly via the constructor.

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _CustomAppBar(),
              const SizedBox(height: 24),
              const Text(
                'Available Products',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: products.isEmpty
                    ? const Center(child: Text('No products yet!'))
                    : ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (ctx, i) {
                          final product = products[i];
                          // Pass the onDelete function down to the product card
                          return _ProductCard(
                              product: product, onDelete: onDelete);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Now we pass the onSave function from the widget's properties
          Navigator.pushNamed(
            context,
            ProductFormScreen.routeName,
            arguments: {
              'onSave': onSave,
            },
          );
        },
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  const _CustomAppBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('MMMM d, yyyy').format(DateTime.now()),
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              const Text(
                'Hello, Yohannes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchScreen.routeName);
            },
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: const Icon(Icons.notifications_none_outlined,
                  color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  // The card now accepts the onDelete function directly
  final void Function(String) onDelete;

  const _ProductCard({required this.product, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    // No longer need to get onDelete from ModalRoute here.

    return GestureDetector(
      onTap: () {
        // Pass the function from this widget's properties.
        Navigator.pushNamed(
          context,
          ProductDetailScreen.routeName,
          arguments: {
            'product': product,
            'onDelete': onDelete,
          },
        );
      },
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.imageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                product.name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.category,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  Text(
                    '\$${product.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '(${product.rating.toString()})',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
