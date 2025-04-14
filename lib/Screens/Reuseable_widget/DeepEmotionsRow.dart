import 'package:deep_emotions_with_backend/Screens/colors_and_other_constants/colors.dart';
import 'package:flutter/material.dart';

class Deepemotionsrow extends StatelessWidget {
  const Deepemotionsrow({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal:
            screenWidth * 0.05, // 5% of screen width for left/right padding
        vertical: screenWidth * 0.03, // 3% of screen width for top padding
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/camera.png',
            height: screenWidth * 0.08, // 8% of screen width
            width: screenWidth * 0.08,
          ),
          SizedBox(width: screenWidth * 0.02), // Space between icon and text
          Text(
            "DeepＥｍｏｔｉｏｎｓシ",
            style: TextStyle(
              fontSize: screenWidth * 0.045, // 4.5% of screen width
              fontStyle: FontStyle.italic,
              color: AppColors.GoldCream,
            ),
          ),
          Spacer(), // Pushes the search icon to the right
          Icon(
            Icons.search_outlined,
            color: Colors.white,
            size: screenWidth * 0.07, // Adjust icon size based on screen width
          ),
        ],
      ),
    );
  }
}
