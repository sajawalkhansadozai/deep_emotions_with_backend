import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../colors_and_other_constants/colors.dart';
import 'ThemeProvider.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    // Get the current user
    User? user = _auth.currentUser;

    if (user == null) {
      Future.delayed(Duration.zero, () {
        context.go('/signIn');
      });
      return Scaffold(
        backgroundColor: isDark ? AppColors.CharcoalBlack : Colors.white,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return FutureBuilder<DocumentSnapshot>(
      future: _firestore.collection('Users').doc(user.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: isDark ? AppColors.CharcoalBlack : Colors.white,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: isDark ? AppColors.CharcoalBlack : Colors.white,
            body: Center(
              child: Text(
                'Error loading profile data',
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
              ),
            ),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Scaffold(
            backgroundColor: isDark ? AppColors.CharcoalBlack : Colors.white,
            body: Center(
              child: Text(
                'No user data found',
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
              ),
            ),
          );
        }

        var userData = snapshot.data!.data() as Map<String, dynamic>;
        String fullName = userData['name'] ?? 'No name available';
        String email = userData['email'] ?? 'No email available';

        return Scaffold(
          backgroundColor: isDark ? AppColors.CharcoalBlack : Colors.white,
          appBar: AppBar(
            backgroundColor:
                isDark ? AppColors.CharcoalBlack : AppColors.GoldCream,
            leading: IconButton(
              onPressed: () => context.go('/home'),
              icon: Icon(
                Icons.arrow_back,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            title: Text(
              'Profile',
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Full Name: $fullName',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Email: $email',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black87,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
