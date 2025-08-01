import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/create_product.dart';
import '../../domain/usecases/delete_product.dart';
import '../../domain/usecases/update_product.dart';
import '../../domain/usecases/view_all_products.dart';
import '../../domain/usecases/view_product.dart';
import '../widgets/product_card.dart'; // <-- IMPORT THE REUSABLE WIDGET
import 'product_detail_screen.dart';
import 'product_form_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  final ViewAllProductsUseCase viewAllProductsUseCase;
  final ViewProductUseCase viewProductUseCase;
  final CreateProductUseCase createProductUseCase;
  final UpdateProductUseCase updateProductUseCase;
  final DeleteProductUseCase deleteProductUseCase;

  const HomeScreen({
    super.key,
    required this.viewAllProductsUseCase,
    required this.viewProductUseCase,
    required this.createProductUseCase,
    required this.updateProductUseCase,
    required this.deleteProductUseCase,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  void _fetchProducts() {
    setState(() {
      _productsFuture = widget.viewAllProductsUseCase.call();
    });
  }

  void _navigateAndRefresh(BuildContext context, Widget screen) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );

    if (result == true) {
      _fetchProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CustomAppBar(
                  onSearchTap: () => _navigateAndRefresh(
                      context,
                      SearchScreen(
                          viewAllProductsUseCase:
                              widget.viewAllProductsUseCase))),
              const SizedBox(height: 24),
              const Text('Available Products',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Expanded(
                child: FutureBuilder<List<Product>>(
                  future: _productsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      // IMPROVED ERROR HANDLING
                      String message = 'An unknown error occurred.';
                      if (snapshot.error is CacheException) {
                        message =
                            'No internet. Please connect to fetch products.';
                      } else if (snapshot.error is ServerException) {
                        message = 'Could not connect to the server.';
                      }
                      return Center(
                          child: Text(message, textAlign: TextAlign.center));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No products yet!'));
                    }

                    final products = snapshot.data!;
                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (ctx, i) {
                        final product = products[i];
                        // USE THE REUSABLE WIDGET
                        return ProductCard(
                          product: product,
                          onTap: () => _navigateAndRefresh(
                            context,
                            ProductDetailScreen(
                              product: product,
                              updateProductUseCase: widget.updateProductUseCase,
                              deleteProductUseCase: widget.deleteProductUseCase,
                              createProductUseCase: widget.createProductUseCase,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateAndRefresh(
          context,
          ProductFormScreen(
            createProductUseCase: widget.createProductUseCase,
            updateProductUseCase: widget.updateProductUseCase,
          ),
        ),
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// _CustomAppBar can remain here as it's only used in this screen.
class _CustomAppBar extends StatelessWidget {
  final VoidCallback onSearchTap;
  const _CustomAppBar({required this.onSearchTap});

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
                borderRadius: BorderRadius.circular(12)),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(DateFormat('MMMM d, yyyy').format(DateTime.now()),
                  style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              const Text('Hello, Yohannes',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: onSearchTap,
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[300]!)),
              child: const Icon(Icons.search, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
