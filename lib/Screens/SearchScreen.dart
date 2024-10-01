import 'package:eccomerse_app/models/ProductModel.dart';
import 'package:eccomerse_app/provider/SearchProvider.dart';
import 'package:eccomerse_app/utils/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:eccomerse_app/models/CartModel.dart'; // Import CartModel

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
    // Get the products when the screen is initialized
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response =
        await http.get(Uri.parse('https://fakestoreapi.com/products'));
    if (response.statusCode == 200) {
      List<Product> products = (json.decode(response.body) as List)
          .map((data) => Product.fromJson(data))
          .toList();
      Provider.of<SearchProvider>(context, listen: false)
          .setAllProducts(products);
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Products'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (query) {
                searchProvider.updateSearchResults(query);
              },
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Enter product name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: searchProvider.filteredProducts.isNotEmpty
                ? ListView.builder(
                    itemCount: searchProvider.filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = searchProvider.filteredProducts[index];
                      return ListTile(
                        leading: Image.network(
                          product.image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.error,
                          ),
                        ),
                        title: Text(product.title),
                        subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                        onTap: () {
                          final cart =
                              Provider.of<Cart>(context, listen: false);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                      product:
                                          product))); // Navigate to product details screen
                        },
                      );
                    },
                  )
                : Center(
                    child: Text(
                      'No products found for "${searchProvider.query}"',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
