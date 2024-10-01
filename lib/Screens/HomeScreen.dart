import 'dart:convert';

import 'package:eccomerse_app/models/ProductModel.dart';
import 'package:eccomerse_app/utils/bannerslider.dart';
import 'package:eccomerse_app/utils/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

Future<List<Product>> fetchProducts() async {
  final response =
      await http.get(Uri.parse('https://fakestoreapi.com/products'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((product) => Product.fromJson(product)).toList();
  } else {
    throw Exception('Failed to load products');
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              SizedBox(height: 7),
              Container(
                height: 180,
                width: MediaQuery.sizeOf(context).width,
                child: BannerSlider(),
              ),
              const SizedBox(
                height: 10,
              ),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Trending",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  )),
              Container(
                height: 250,
                child: ProductScrollWidget(),
              ),
              const Align(
                alignment: Alignment.bottomLeft,
                child: const Text(
                  "Best Seller",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                height: 250,
                child: BestSellersSection(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ProductScrollWidget class
class ProductScrollWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: fetchProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final products = snapshot.data!;

          return Container(
            height: 300,
            decoration: BoxDecoration(
              color: Colors.lightGreen[50], // Light green background
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white, // White background for product card
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.network(
                          product.image,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            product.title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetailScreen(product: product),
                              ),
                            );
                          },
                          child: Text('Buy Now'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.lightGreen, // Light green button color
                            foregroundColor:
                                Colors.white, // Text color for the button
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}

// Best Sellers Section
class BestSellersSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: fetchProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final products = snapshot.data!;
          // Filter products with odd IDs
          final bestSellers =
              products.where((product) => product.id.isOdd).toList();

          return Container(
            height: 300,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: bestSellers.length,
              itemBuilder: (context, index) {
                final product = bestSellers[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.network(
                          product.image,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            product.title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetailScreen(product: product),
                              ),
                            );
                            // Add Buy Now functionality here
                          },
                          child: Text('Buy Now'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightGreen,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
