// lib/screens/product_form_screen.dart

import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductFormScreen extends StatefulWidget {
  static const routeName = '/add-edit-product';

  final void Function(Product product) onSave;
  final void Function(String id)? onDelete;
  final Product? existingProduct;

  const ProductFormScreen({
    super.key,
    required this.onSave,
    this.onDelete,
    this.existingProduct,
  });

  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.existingProduct?.name ?? '');
    _categoryController =
        TextEditingController(text: widget.existingProduct?.category ?? '');
    _priceController = TextEditingController(
        text: widget.existingProduct?.price.toStringAsFixed(0) ?? '');
    _descriptionController =
        TextEditingController(text: widget.existingProduct?.description ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (!_formKey.currentState!.validate()) return;

    final id = widget.existingProduct?.id ?? DateTime.now().toIso8601String();

    final newProduct = Product(
      id: id,
      name: _nameController.text.trim(),
      category: _categoryController.text.trim(),
      price: double.tryParse(_priceController.text.trim()) ?? 0.0,
      description: _descriptionController.text.trim(),
      // Using existing or placeholder values for non-form fields
      imageUrl:
          widget.existingProduct?.imageUrl ?? 'https://i.imgur.com/sIagB4m.png',
      rating: widget.existingProduct?.rating ?? 0.0,
      sizes: widget.existingProduct?.sizes ?? [39, 40, 41, 42, 43, 44],
    );

    widget.onSave(newProduct);
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _deleteProduct() {
    if (widget.existingProduct != null && widget.onDelete != null) {
      widget.onDelete!(widget.existingProduct!.id);
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingProduct != null;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, isEditing),
                const SizedBox(height: 24),
                _buildImageUploader(),
                const SizedBox(height: 24),
                _buildTextFormField('Name', _nameController),
                const SizedBox(height: 16),
                _buildTextFormField('Category', _categoryController),
                const SizedBox(height: 16),
                _buildTextFormField('Price', _priceController, isPrice: true),
                const SizedBox(height: 16),
                _buildTextFormField('Description', _descriptionController,
                    maxLines: 4),
                const SizedBox(height: 32),
                _buildFormButtons(isEditing),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isEditing) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        const SizedBox(width: 16),
        Text(
          isEditing ? 'Update Product' : 'Add Product',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildImageUploader() {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_outlined, size: 50, color: Colors.grey),
          SizedBox(height: 8),
          Text('Upload Image', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildTextFormField(String label, TextEditingController controller,
      {bool isPrice = false, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: isPrice
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            suffixIcon: isPrice ? const Icon(Icons.attach_money) : null,
          ),
          validator: (value) =>
              (value == null || value.trim().isEmpty) ? 'Enter $label' : null,
        ),
      ],
    );
  }

  Widget _buildFormButtons(bool isEditing) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _saveForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(isEditing ? 'UPDATE' : 'ADD',
                style: const TextStyle(color: Colors.white)),
          ),
        ),
        if (isEditing) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _deleteProduct,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('DELETE', style: TextStyle(color: Colors.red)),
            ),
          ),
        ],
      ],
    );
  }
}
