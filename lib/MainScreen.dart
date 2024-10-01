import 'package:eccomerse_app/Screens/CartScreen.dart';
import 'package:eccomerse_app/Screens/HomeScreen.dart';
import 'package:eccomerse_app/Screens/ProfileScreen.dart';
import 'package:eccomerse_app/Screens/SearchScreen.dart';
import 'package:eccomerse_app/utils/custonsliderappbar.dart';
import 'package:flutter/material.dart';
import 'package:eccomerse_app/models/ProductModel.dart'; // Ensure this model matches your API structure
import 'package:http/http.dart' as http;
import 'dart:convert';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  List<Product> allProducts = []; // Initialize as an empty list
  bool isLoading = true; // To handle loading state

  // Fetch products from the Fake Store API
  Future<void> fetchProducts() async {
    final response =
        await http.get(Uri.parse('https://fakestoreapi.com/products'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      // Assuming ProductModel is already set up correctly
      setState(() {
        allProducts = data.map((json) => Product.fromJson(json)).toList();
        isLoading = false; // Data loaded, stop loading indicator
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts(); // Fetch products when the screen initializes
  }

  // Method to handle tapping on a bottom navigation item
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // The screen will display a loading spinner until the products are fetched
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('ShopEase'),
          backgroundColor: Colors.lightGreen[700],
        ),
        body:
            const Center(child: CircularProgressIndicator()), // Loading spinner
      );
    }

    // List of widget pages with SearchScreen receiving the fetched products
    final List<Widget> _widgetOptions = <Widget>[
      HomeScreen(),
      SearchScreen(),
      CartScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      appBar: SlidingAppBar(title: 'Main Screen'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 631,
              width: MediaQuery.sizeOf(context).width,
              child: _widgetOptions.elementAt(_selectedIndex),
            )
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

// Separate widget for BottomNavigationBar
class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.lightGreen[100], // Set background color
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.green[800], // Color for selected item
      unselectedItemColor: Colors.green[400], // Color for unselected items
      onTap: onItemTapped,
    );
  }
}
