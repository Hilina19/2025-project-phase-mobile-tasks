import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/create_product.dart';
import '../../domain/usecases/delete_product.dart';
import '../../domain/usecases/update_product.dart';
import '../../domain/usecases/view_all_products.dart';
import '../../domain/usecases/view_product.dart';
import 'product_detail_screen.dart';
import 'product_form_screen.dart';
import 'search_screen.dart';

// (The code for the HomeScreen widget is exactly the same, only imports change)
// ... paste your original HomeScreen widget code here ...
// All the `_CustomAppBar` and `_ProductCard` widgets remain the same as before
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
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No products yet!'));
                    }

                    final products = snapshot.data!;
                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (ctx, i) {
                        final product = products[i];
                        return _ProductCard(
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

class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const _ProductCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(product.imageUrl,
                    height: 150, width: double.infinity, fit: BoxFit.cover),
              ),
              const SizedBox(height: 12),
              Text(product.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Men's shoe",
                      style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                  Text('\$${product.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              Row(children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text('(4.0)',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600])),
              ])
            ],
          ),
        ),
      ),
    );
  }
}
