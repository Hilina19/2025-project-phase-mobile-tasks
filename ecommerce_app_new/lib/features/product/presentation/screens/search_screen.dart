import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/view_all_products.dart';

// (The code for the SearchScreen widget is exactly the same, only imports change)
// ... paste your original SearchScreen widget code here ...
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
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No products found.'));
                    }
                    final products = snapshot.data!;
                    return ListView.builder(
                      itemCount: products.length > 2 ? 2 : products.length,
                      itemBuilder: (ctx, i) =>
                          _ProductCard(product: products[i]),
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

  // All the private _build... and _ProductCard widgets remain the same
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

class _ProductCard extends StatelessWidget {
  final Product product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
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
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
            const Row(children: [
              Icon(Icons.star, color: Colors.amber, size: 20),
              SizedBox(width: 4),
              Text('(4.0)', style: TextStyle(fontSize: 14, color: Colors.grey)),
            ])
          ],
        ),
      ),
    );
  }
}
