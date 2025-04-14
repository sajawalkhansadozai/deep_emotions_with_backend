import 'package:deep_emotions_with_backend/Screens/colors_and_other_constants/colors.dart';
import 'package:flutter/material.dart';

Widget HeaderText(String text3) {
  return Center(
    child: Text(
      text3,
      style: TextStyle(
        color: AppColors.GoldCream, // ✅ Replace with your desired color
        fontSize: 20, // ✅ Adjust font size if needed
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
