import 'package:deep_emotions_with_backend/Screens/colors_and_other_constants/colors.dart';
import 'package:flutter/material.dart';

class FirstContainerImage extends StatelessWidget {
  final String imagePath; // Parameterized image path
  final double screenWidth;
  final double screenHeight;
  const FirstContainerImage({
    super.key,
    required this.imagePath,
    required this.screenWidth,
    required this.screenHeight,
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: screenHeight * 0.25, // 25% of screen height
        width: screenWidth * 0.6, // 60% of screen width
        decoration: BoxDecoration(
          color: AppColors.CreamBlack,
          borderRadius: BorderRadius.circular(
            screenWidth * 0.03,
          ), // 3% of screen width
          image: DecorationImage(
            image: AssetImage(imagePath), // Use the parameterized image path
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
