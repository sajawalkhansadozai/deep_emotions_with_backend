import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({Key? key}) : super(key: key);

  Widget buildDivider(double width) {
    return Container(
      width: width, // ✅ Fixed width but responsive
      height: 2,
      color: Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double lineWidth = screenWidth * 0.3; // ✅ Adjust width percentage

    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildDivider(lineWidth), // Left line
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.02,
            ), // Gap control
            child: Text(
              "Or",
              style: TextStyle(
                color: Colors.grey,
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          buildDivider(lineWidth), // Right line
        ],
      ),
    );
  }
}
