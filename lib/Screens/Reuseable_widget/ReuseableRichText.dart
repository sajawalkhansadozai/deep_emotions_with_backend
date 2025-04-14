import 'package:deep_emotions_with_backend/Screens/colors_and_other_constants/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RichTextWidget extends StatelessWidget {
  final BuildContext context;
  final String route2;
  final String text1;
  final String text2;
  final double screenWidth;
  final double screenHeight;
  const RichTextWidget({
    Key? key,
    required this.context,
    required this.route2,
    required this.text1,
    required this.text2,
    required this.screenWidth,
    required this.screenHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text1,
        style: TextStyle(
          color: Colors.white,
          fontSize: screenWidth * 0.04, // 4% of screen width
        ),
        children: <TextSpan>[
          TextSpan(
            text: text2,
            style: TextStyle(
              color: AppColors.GoldCream,
              fontSize: screenWidth * 0.04, // 4% of screen width
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
            ),
            recognizer:
                TapGestureRecognizer()
                  ..onTap = () {
                    context.go(route2);
                  },
          ),
        ],
      ),
    );
  }
}
