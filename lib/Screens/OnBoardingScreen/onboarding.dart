import 'package:deep_emotions_with_backend/Screens/Reuseable_widget/Button.dart';
import 'package:deep_emotions_with_backend/Screens/Reuseable_widget/ReuseableRichText.dart';
import 'package:deep_emotions_with_backend/Screens/Reuseable_widget/bottom_line.dart';
import 'package:deep_emotions_with_backend/Screens/Reuseable_widget/firstcontainer.dart';
import 'package:deep_emotions_with_backend/Screens/colors_and_other_constants/colors.dart';
import 'package:flutter/material.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});
  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.CharcoalBlack,
      body: SingleChildScrollView(
        // Wrap the Column in a SingleChildScrollView to avoid overflow
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.25), // 18% of screen height
            FirstContainerImage(
              imagePath: 'assets/first.png', // Pass the image path
              screenWidth: screenWidth,
              screenHeight: screenHeight,
            ),
            Second_Text(screenWidth, screenHeight),
            SizedBox(height: screenHeight * 0.035), // 3.5% of screen height
            ReusableButton(
              buttonText: 'Get Started',
              route: '/signIn',
              screenWidth: screenWidth,
              screenHeight: screenHeight,
            ),
            SizedBox(height: screenHeight * 0.12), // 12% of screen height
            RichTextWidget(
              context: context,
              route2: '/signIn',
              text1: 'Already have an Account ? ',
              text2: 'Sign In',
              screenWidth: screenWidth,
              screenHeight: screenHeight,
            ),
            SizedBox(height: screenHeight * 0.06), // Add some spacing
            BottomLine(),
          ],
        ),
      ),
    );
  }
}

Widget Second_Text(double screenWidth, double screenHeight) {
  return Padding(
    padding: EdgeInsets.only(top: screenHeight * 0.07), // 7% of screen height
    child: Center(
      child: Text(
        "   Transforming sadness into\nstrength, spreading hope, and\n            inspiring lives.",
        style: TextStyle(
          color: Colors.white,
          fontSize: screenWidth * 0.04, // 4.5% of screen width
        ),
      ),
    ),
  );
}
