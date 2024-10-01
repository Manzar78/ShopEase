import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eccomerse_app/MainScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:eccomerse_app/Screens/HomeScreen.dart';
import 'package:eccomerse_app/Screens/auth/signin_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  File? _image; // For storing the selected image
  String? _imageUrl; // For storing the uploaded image URL
  String? _errorMessage;

  final ImagePicker _picker = ImagePicker();

  // Method to pick an image
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Method to upload image to Firebase Storage
  Future<String?> _uploadImage() async {
    if (_image != null) {
      try {
        // Upload image to Firebase Storage
        Reference ref =
            _storage.ref().child('user_images/${_auth.currentUser!.uid}.jpg');
        UploadTask uploadTask = ref.putFile(_image!);
        TaskSnapshot snapshot = await uploadTask;

        // Get the image URL
        String downloadUrl = await snapshot.ref.getDownloadURL();
        return downloadUrl;
      } catch (e) {
        setState(() {
          _errorMessage = 'Failed to upload image: $e';
        });
      }
    }
    return null;
  }

  // Method to handle user sign-up and save user data in Firestore
  Future<void> _signUp() async {
    try {
      // Create user in Firebase Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      User? user = result.user;

      // Upload the profile image if selected
      _imageUrl = await _uploadImage();

      // Add user data to Firestore
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': _nameController.text.trim(),
          'email': user.email,
          'phone': _phoneController.text.trim(),
          'userId': user.uid,
          'imageUrl': _imageUrl ??
              'https://example.com/default-profile.jpg', // Fallback URL if no image
        });
      }

      setState(() {
        _errorMessage = null;
      });

      // Navigate to home screen after successful signup
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  // Method to display error message
  Widget _showErrorMessage() {
    if (_errorMessage == null) {
      return const SizedBox.shrink();
    }
    return Text(
      _errorMessage!,
      style: const TextStyle(color: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: Colors.lightGreen[700], // Update to green theme
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: _pickImage, // Pick image when user taps on the image
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null
                      ? const Icon(
                          Icons.camera_alt,
                          size: 50,
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              _showErrorMessage(),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _signUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen[700], // Matching theme
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Sign Up'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignInScreen(),
                    ),
                  );
                },
                child: Text(
                  'Already have an account? Sign In',
                  style: TextStyle(color: Colors.green[800]), // Matching theme
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
