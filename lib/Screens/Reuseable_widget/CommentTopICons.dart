import 'package:deep_emotions_with_backend/Screens/colors_and_other_constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Import go_router

class CommentTopIcons extends StatelessWidget {
  const CommentTopIcons({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Define responsive values
    final topPadding = screenHeight * 0.04; // 4% of screen height
    final leftPadding = screenWidth * 0.05; // 5% of screen width
    final rightPadding = screenWidth * 0.03; // 3% of screen width
    final iconSize = screenWidth * 0.06; // 6% of screen width

    return Padding(
      padding: EdgeInsets.only(top: topPadding, left: leftPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // First Icon with Gesture Detector
          GestureDetector(
            onTap: () {
              // Navigate to the desired route using go_router
              context.go('/home'); // Replace with your route
            },
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(
                3.1416,
              ), // Flip the icon horizontally
              child: Icon(
                Icons.arrow_forward,
                size: iconSize,
                color: AppColors.GoldCream,
              ),
            ),
          ),

          // Second Icon with Gesture Detector
          Padding(
            padding: EdgeInsets.only(right: rightPadding),
            child: GestureDetector(
              onTap: () {
                // Navigate to the desired route using go_router
                context.go('/notification'); // Replace with your route
              },
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(
                  3.1416,
                ), // Flip the icon horizontally
                child: Icon(
                  CupertinoIcons.reply,
                  size: iconSize,
                  color: AppColors.GoldCream,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
