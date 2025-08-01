import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/view_all_products.dart';
import '../widgets/product_card.dart'; // <-- IMPORT THE REUSABLE WIDGET

class SearchScreen extends StatefulWidget {
  final ViewAllProductsUseCase viewAllProductsUseCase;
  const SearchScreen({super.key, required this.viewAllProductsUseCase});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  RangeValues _currentRangeValues = const RangeValues(100, 500);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              _buildSearchBar(),
              const SizedBox(height: 16),
              Expanded(
                child: FutureBuilder<List<Product>>(
                  future: widget.viewAllProductsUseCase
                      .call(), // Shows all products for now
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      // Simple error handling for search screen
                      return const Center(
                          child: Text('Could not load products.'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No products found.'));
                    }
                    final products = snapshot.data!;
                    return ListView.builder(
                      itemCount: products.length > 2 ? 2 : products.length,
                      // USE THE REUSABLE WIDGET
                      itemBuilder: (ctx, i) =>
                          ProductCard(product: products[i]),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              _buildFilters(),
              const SizedBox(height: 24),
              _buildApplyButton(),
            ],
          ),
        ),
      ),
    );
  }

  // All the private _build... widgets can remain here as they are unique to this screen.
  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop()),
        const SizedBox(width: 16),
        const Text('Search Product',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Leather',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!)),
              suffixIcon: const Icon(Icons.arrow_forward, color: Colors.indigo),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Container(
          decoration: BoxDecoration(
              color: Colors.indigo, borderRadius: BorderRadius.circular(12)),
          child: IconButton(
              icon: const Icon(Icons.filter_list, color: Colors.white),
              onPressed: () {}),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Category', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 16),
        const Text('Price', style: TextStyle(fontWeight: FontWeight.w600)),
        RangeSlider(
          values: _currentRangeValues,
          min: 0,
          max: 1000,
          divisions: 10,
          activeColor: Colors.indigo,
          labels: RangeLabels(_currentRangeValues.start.round().toString(),
              _currentRangeValues.end.round().toString()),
          onChanged: (RangeValues values) =>
              setState(() => _currentRangeValues = values),
        ),
      ],
    );
  }

  Widget _buildApplyButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text('APPLY', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

// THE OLD _ProductCard CLASS IS DELETED FROM THIS FILE
