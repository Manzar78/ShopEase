import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    // Fetch user data from Firestore
    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection('users').doc(user?.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text('No user data found.'));
        }

        // Get user data
        var userData = snapshot.data!.data() as Map<String, dynamic>;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            backgroundColor: Colors.lightGreen[700],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Display profile image
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          NetworkImage(userData['profileImageUrl'] ?? ''),
                      child: userData['profileImageUrl'] == null
                          ? const Icon(Icons.camera_alt, size: 50)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Display user name without border
                  const Text(
                    'Name',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildDataField(
                      userData['name'] ?? 'Name not available', context),
                  const SizedBox(height: 16),

                  // Display user email without border
                  const Text(
                    'Email',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildDataField(
                      userData['email'] ?? 'Email not available', context),
                  const SizedBox(height: 16),

                  // Display user phone number without border
                  const Text(
                    'Phone Number',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildDataField(
                      userData['phone'] ?? 'Phone number not available',
                      context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDataField(String value, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.lightGreen, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(8.0),
      width: MediaQuery.of(context)
          .size
          .width, // Use MediaQuery for responsive width
      child: Text(
        value,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
