import 'package:flutter/material.dart';

class AddUpdatePage extends StatelessWidget {
  const AddUpdatePage({super.key});

  // Helper function to build a labeled text field, reducing code duplication
  Widget _buildTextFieldWithLabel(String label,
      {int maxLines = 1, String? suffixText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            suffixIcon: suffixText != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Text(
                      suffixText,
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  )
                : null,
            suffixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none, // No border
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Define the primary and secondary colors from the UI
    const Color primaryBlue = Color(0xFF4A43EC);
    const Color deleteRed = Colors.red;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with back arrow and title
                Row(
                  children: const [
                    Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
                    SizedBox(width: 16),
                    Text(
                      'Add Product',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Image Upload Area
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image_outlined,
                          color: Colors.grey[600], size: 40),
                      const SizedBox(height: 8),
                      Text(
                        'upload image',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Form Fields
                _buildTextFieldWithLabel('name'),
                const SizedBox(height: 20),
                _buildTextFieldWithLabel('category'),
                const SizedBox(height: 20),
                _buildTextFieldWithLabel('price', suffixText: '\$'),
                const SizedBox(height: 20),
                _buildTextFieldWithLabel('description', maxLines: 5),
                const SizedBox(height: 40),

                // Action Buttons (ADD and DELETE)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'ADD',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: deleteRed,
                      side: const BorderSide(color: deleteRed, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Text(
                      'DELETE',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
