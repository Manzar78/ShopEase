import 'dart:async';

import 'package:flutter/material.dart';

class BannerSlider extends StatefulWidget {
  @override
  _BannerSliderState createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Start the timer for automatic page changes every 2 seconds
    _timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 600), // Animation duration
        curve: Curves.easeInOut, // Smooth curve
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(20), // Adjust the radius as needed
          child: Container(
            height: 200, // Adjust height to suit your banner needs
            width: double.infinity, // Full width to make it like a banner
            child: PageView(
              controller: _pageController,
              children: [
                _buildImage("assets/images/pic1.png"),
                _buildImage("assets/images/pic2.jpg"),
                _buildImage("assets/images/pic3.jpg"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget to build each image
  Widget _buildImage(String assetPath) {
    return Container(
      width: double.infinity, // Full width
      height: double.infinity, // Full height of the container
      child: Image.asset(
        assetPath,
        fit: BoxFit.cover, // Ensures the image fits the container
      ),
    );
  }
}
