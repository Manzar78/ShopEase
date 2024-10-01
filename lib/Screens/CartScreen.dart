import 'package:eccomerse_app/models/CartModel.dart'; // Ensure you import the Cart model
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context); // Accessing the Cart instance

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: cart.items.isEmpty
          ? Center(
              child: Text(
                'Your cart is empty',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final product = cart.items[index];
                return ListTile(
                  leading: Image.network(product.image, width: 50, height: 50),
                  title: Text(product.title),
                  subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_circle),
                    onPressed: () {
                      // Implementing remove product functionality
                    },
                  ),
                );
              },
            ),
    );
  }
}
