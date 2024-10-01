import 'package:eccomerse_app/models/ProductModel.dart';
import 'package:flutter/material.dart';

class Cart extends ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items => _items;

  // Method to add a product to the cart
  void addProduct(Product product) {
    // Check if the product already exists in the cart
    final existingProductIndex =
        _items.indexWhere((item) => item.id == product.id);

    if (existingProductIndex >= 0) {
      // Optionally, you can update the quantity or handle duplicates here
      // For example: _items[existingProductIndex].quantity += 1;
    } else {
      _items.add(product); // Add the product to the cart
    }
    notifyListeners(); // Notify listeners about the change
  }

  // Method to remove a product from the cart
  void removeItem(String productId) {
    _items.removeWhere((item) => item.id == productId);
    notifyListeners(); // Notify listeners about the change
  }

  // Optional: Method to clear the cart
  void clearCart() {
    _items.clear();
    notifyListeners(); // Notify listeners about the change
  }
}
