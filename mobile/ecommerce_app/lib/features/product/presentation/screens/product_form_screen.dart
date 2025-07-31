import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/create_product.dart';
import '../../domain/usecases/update_product.dart';

// (The code for the ProductFormScreen widget is exactly the same, only imports change)
// ... paste your original ProductFormScreen widget code here ...
class ProductFormScreen extends StatefulWidget {
  final CreateProductUseCase createProductUseCase;
  final UpdateProductUseCase updateProductUseCase;
  final Product? existingProduct;

  const ProductFormScreen({
    super.key,
    required this.createProductUseCase,
    required this.updateProductUseCase,
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
  bool get _isEditing => widget.existingProduct != null;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.existingProduct?.name ?? '');
    _categoryController =
        TextEditingController(text: "Men's shoe"); // Default value
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

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        id: widget.existingProduct?.id ?? DateTime.now().toIso8601String(),
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.tryParse(_priceController.text.trim()) ?? 0.0,
        imageUrl: widget.existingProduct?.imageUrl ??
            'https://i.imgur.com/sIagB4m.png', // Placeholder
      );

      if (_isEditing) {
        await widget.updateProductUseCase.call(params: product);
      } else {
        await widget.createProductUseCase.call(params: product);
      }

      if (mounted) Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildImageUploader(),
                const SizedBox(height: 24),
                _buildTextFormField('name', _nameController),
                _buildTextFormField('category', _categoryController),
                _buildTextFormField('price', _priceController, isPrice: true),
                _buildTextFormField('description', _descriptionController,
                    maxLines: 4),
                const SizedBox(height: 32),
                _buildFormButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop()),
        const SizedBox(width: 16),
        Text(_isEditing ? 'Update Product' : 'Add Product',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildImageUploader() {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_outlined, size: 50, color: Colors.grey),
          SizedBox(height: 8),
          Text('Upload Image', style: TextStyle(color: Colors.grey))
        ],
      ),
    );
  }

  Widget _buildTextFormField(String label, TextEditingController controller,
      {bool isPrice = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
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
              fillColor: Colors.white,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none),
              suffixIcon: isPrice ? const Icon(Icons.attach_money) : null,
            ),
            validator: (value) =>
                (value == null || value.trim().isEmpty) ? 'Enter $label' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildFormButtons() {
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
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(_isEditing ? 'UPDATE' : 'ADD',
                style: const TextStyle(color: Colors.white)),
          ),
        ),
        if (_isEditing) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {/* Delete logic is on the detail screen */},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('DELETE', style: TextStyle(color: Colors.red)),
            ),
          ),
        ],
      ],
    );
  }
}
