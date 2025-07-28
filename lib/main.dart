import 'package:flutter/material.dart';
import 'cart_page.dart';
import 'search_page.dart';
import 'update_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product UI',
      theme: ThemeData(fontFamily: 'Sans', useMaterial3: true),
      home: AddUpdatePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ProductHomePage extends StatelessWidget {
  final List<Map<String, dynamic>> products = [
    {
      "title": "Derby Leather Shoes",
      "category": "Men's shoe",
      "price": "\$120",
      "rating": "4.0",
      "image": "assets/images/boots.png"
    },
    {
      "title": "Derby Leather Shoes",
      "category": "Men's shoe",
      "price": "\$120",
      "rating": "4.0",
      "image": "assets/images/boots.png"
    },
    {
      "title": "Derby Leather Shoes",
      "category": "Men's shoe",
      "price": "\$120",
      "rating": "4.0",
      "image": "assets/images/boots.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(),
              SizedBox(height: 16),
              _buildSectionTitle(),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (_, index) => _buildProductCard(products[index]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(radius: 20, backgroundColor: Colors.grey.shade400),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("July 14, 2023", style: TextStyle(fontSize: 12)),
                Text("Hello, Yohannes",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        Icon(Icons.notifications_outlined),
      ],
    );
  }

  Widget _buildSectionTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          "Available Products",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Icon(Icons.search),
      ],
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(product['image']),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product['title'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(height: 4),
                      Text(product['category'],
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(product['price'],
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        SizedBox(width: 4),
                        Text(product['rating'],
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
