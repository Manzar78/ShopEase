import 'dart:async';
import 'package:flutter/material.dart';

class SlidingAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  SlidingAppBar({required this.title});

  @override
  _SlidingAppBarState createState() => _SlidingAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight); // AppBar ka size
}

class _SlidingAppBarState extends State<SlidingAppBar> {
  double _appBarHeight = kToolbarHeight; // Initial AppBar height
  bool _isVisible = true; // Track AppBar visibility

  @override
  void initState() {
    super.initState();
    // Delay of 2 seconds before hiding AppBar
    Timer(Duration(seconds: 2), () {
      setState(() {
        _isVisible = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // Wrap with SafeArea
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500), // Duration of slide-up animation
        height: _isVisible ? _appBarHeight : 0, // Animate height to 0
        child: AppBar(
          title: Text(widget.title),
          backgroundColor: Colors.lightGreen, // Set your greenish color here
        ),
      ),
    );
  }
}
