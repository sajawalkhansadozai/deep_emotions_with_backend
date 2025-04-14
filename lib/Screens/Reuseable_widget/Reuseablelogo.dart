import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart'; // If using GoRouter

class ReuseableLogo extends StatelessWidget {
  const ReuseableLogo({super.key});

  // Function to Sign In with Google
  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // User canceled sign-in

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      if (userCredential.user != null) {
        await _createOrUpdateUserProfile(
          userCredential.user!.uid,
          userCredential.user!.displayName ?? 'Unknown User',
          userCredential.user!.email ?? '',
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Welcome, ${userCredential.user!.displayName}! 🎉"),
          ),
        );

        // Navigate to Home Screen
        GoRouter.of(context).go('/home'); // If using GoRouter
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google Sign-In Failed: ${e.toString()}")),
      );
    }
  }

  // Create or Update User Profile in Firestore
  Future<void> _createOrUpdateUserProfile(
    String userId,
    String name,
    String email,
  ) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentSnapshot userDoc =
        await firestore.collection('Users').doc(userId).get();

    if (!userDoc.exists) {
      await firestore.collection('Users').doc(userId).set({
        'name': name,
        'email': email,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final logoSize = screenWidth * 0.12;
    final spacing = screenWidth * 0.05;

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => _signInWithGoogle(context),
            child: imageContainer('assets/Google.png', logoSize),
          ),
        ],
      ),
    );
  }

  Widget imageContainer(String imageOfLogo, double size) {
    return SizedBox(
      height: size,
      width: size,
      child: Image.asset(imageOfLogo, fit: BoxFit.contain),
    );
  }
}
