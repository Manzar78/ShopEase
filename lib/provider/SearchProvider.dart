import 'package:flutter/material.dart';
import 'package:eccomerse_app/models/ProductModel.dart';

class SearchProvider with ChangeNotifier {
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  String query = '';

  List<Product> get filteredProducts => _filteredProducts;

  void setAllProducts(List<Product> products) {
    _allProducts = products;
    _filteredProducts = products; // Initially show all products
    notifyListeners();
  }

  void updateSearchResults(String searchQuery) {
    query = searchQuery;
    _filteredProducts = _allProducts
        .where((product) =>
            product.title.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
    notifyListeners();
  }
}
