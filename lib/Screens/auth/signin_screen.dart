import 'package:eccomerse_app/MainScreen.dart';
import 'package:eccomerse_app/Screens/auth/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _errorMessage;

  // Method to handle user sign-in
  Future<void> _signIn() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      setState(() {
        _errorMessage = null;
      });
      // Navigate to home screen after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const MainScreen()), // Home screen
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
        title: const Text('Sign In'),
        backgroundColor: Colors.lightGreen[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
              onPressed: _signIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen[700], // Matching theme
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Sign In'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpScreen()),
                );
              },
              child: Text(
                'Don\'t have an account? Sign Up',
                style: TextStyle(color: Colors.green[800]), // Matching theme
              ),
            ),
          ],
        ),
      ),
    );
  }
}
