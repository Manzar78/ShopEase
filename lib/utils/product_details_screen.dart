import 'package:eccomerse_app/Screens/CartScreen.dart';
import 'package:flutter/material.dart';
import 'package:eccomerse_app/models/ProductModel.dart';
import 'package:eccomerse_app/models/CartModel.dart';
import 'package:provider/provider.dart'; // Import Provider

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  ProductDetailScreen({required this.product}); // Keep the constructor as is

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context); // Accessing the Cart instance

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: Image.network(product.image, fit: BoxFit.fill),
              ),
              SizedBox(height: 10),
              Text(
                product.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              Text(
                product.description,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Add the product to the cart
                        cart.addProduct(product); // Add the product to the cart
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.title} added to cart!'),
                          ),
                        );
                      },
                      child: Text('Add to Cart'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10), // Spacing between buttons
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to CartScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CartScreen(), // No need to pass the cart
                          ),
                        );
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
            ],
          ),
        ),
      ),
    );
  }
}
