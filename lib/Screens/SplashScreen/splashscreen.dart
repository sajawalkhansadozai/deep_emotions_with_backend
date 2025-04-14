import 'dart:ui'; // Required for ImageFilter.blur
import 'package:deep_emotions_with_backend/Screens/Reuseable_widget/bottom_line.dart';
import 'package:deep_emotions_with_backend/Screens/colors_and_other_constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Delay for 3 seconds and then check authentication state
    Future.delayed(const Duration(seconds: 3), () {
      _checkAuthState();
    });
  }

  // Check if the user is signed in
  Future<void> _checkAuthState() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is signed in, navigate to the home screen
      GoRouter.of(context).go('/home');
    } else {
      // User is not signed in, navigate to the onboarding screen
      GoRouter.of(context).go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.CharcoalBlack,
      body: Stack(
        children: [
          // Gradient Top Left
          Positioned(
            top: 0,
            left: 0,
            child: gradientContainer(
              screenWidth * 0.7,
              screenHeight * 0.4,
              Alignment.topLeft,
              Alignment.bottomRight,
            ),
          ),

          // Gradient Bottom Right
          Positioned(
            bottom: 0,
            right: 0,
            child: gradientContainer(
              screenWidth * 0.7,
              screenHeight * 0.4,
              Alignment.bottomRight,
              Alignment.topLeft,
            ),
          ),

          // Blur Overlay
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(color: Colors.black.withOpacity(0.05)),
            ),
          ),

          Center_text(screenWidth),

          // Use the reusable BottomLine
          Positioned(
            bottom: screenHeight * 0.05,
            left: 0,
            right: 0,
            child: BottomLine(),
          ),
        ],
      ),
    );
  }
}

// ✅ Centered Text & Logo
Widget Center_text(double screenWidth) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: screenWidth * 0.12,
          width: screenWidth * 0.12,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage("assets/camera.png"),
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(height: screenWidth * 0.05),
        Text(
          "DeepＥｍｏｔｉｏｎｓシ",
          style: TextStyle(
            fontSize: screenWidth * 0.06,
            fontStyle: FontStyle.italic,
            color: AppColors.GoldCream,
          ),
        ),
      ],
    ),
  );
}

// ✅ Gradient Container
Widget gradientContainer(
  double width,
  double height,
  Alignment begin,
  Alignment end,
) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(width * 0.2)),
      gradient: LinearGradient(
        begin: begin,
        end: end,
        colors: [
          AppColors.GoldCream.withOpacity(0.22),
          AppColors.GoldCream.withOpacity(0.0000001),
          AppColors.CharcoalBlack,
        ],
        stops: [0.0, 0.4, 0.2],
      ),
    ),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(color: Colors.transparent),
    ),
  );
}
