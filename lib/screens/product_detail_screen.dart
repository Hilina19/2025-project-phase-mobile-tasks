// lib/screens/product_detail_screen.dart

import 'package:flutter/material.dart';
import '../domain/entities/product.dart';
import '../domain/usecases/create_product.dart';
import '../domain/usecases/delete_product.dart';
import '../domain/usecases/update_product.dart';
import 'product_form_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final UpdateProductUseCase updateProductUseCase;
  final DeleteProductUseCase deleteProductUseCase;
  final CreateProductUseCase createProductUseCase;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.updateProductUseCase,
    required this.deleteProductUseCase,
    required this.createProductUseCase,
  });

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedSize = 41; // Default selected size

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageHeader(context),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Men's shoe",
                      style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.product.name,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      Text('\$${widget.product.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Row(children: [
                    Icon(Icons.star, color: Colors.amber, size: 20),
                    SizedBox(width: 4),
                    Text('(4.0)',
                        style: TextStyle(fontSize: 14, color: Colors.grey)),
                  ]),
                  const SizedBox(height: 24),
                  const Text('Size:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),
                  _buildSizeSelector(),
                  const SizedBox(height: 24),
                  Text(widget.product.description,
                      style: TextStyle(
                          color: Colors.grey[700], fontSize: 14, height: 1.5)),
                  const SizedBox(height: 32),
                  _buildActionButtons(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageHeader(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30)),
          child: Image.network(widget.product.imageUrl,
              height: 300, width: double.infinity, fit: BoxFit.cover),
        ),
        Positioned(
          top: 40,
          left: 16,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSizeSelector() {
    final sizes = [39, 40, 41, 42, 43, 44];
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: sizes.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final size = sizes[index];
          final isSelected = _selectedSize == size;
          return GestureDetector(
            onTap: () => setState(() => _selectedSize = size),
            child: Container(
              width: 50,
              decoration: BoxDecoration(
                color: isSelected ? Colors.indigo : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              alignment: Alignment.center,
              child: Text(size.toString(),
                  style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirm Deletion'),
                  content: Text(
                      'Are you sure you want to delete "${widget.product.name}"?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel')),
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Delete')),
                  ],
                ),
              );

              if (confirm == true && mounted) {
                await widget.deleteProductUseCase
                    .call(params: widget.product.id);
                Navigator.of(context).pop(true);
              }
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('DELETE', style: TextStyle(color: Colors.red)),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductFormScreen(
                    createProductUseCase: widget.createProductUseCase,
                    updateProductUseCase: widget.updateProductUseCase,
                    existingProduct: widget.product,
                  ),
                ),
              );
              if (result == true && mounted) {
                Navigator.of(context).pop(true);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('UPDATE', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}
