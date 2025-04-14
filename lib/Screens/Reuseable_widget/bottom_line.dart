import 'dart:math';
import 'package:flutter/material.dart';

class BottomLine extends StatelessWidget {
  final double widthFactor; // Use factor instead of absolute width
  final double heightFactor; // Use factor instead of absolute height
  final String imageAsset;
  final Color? color;
  final BoxFit? fit;
  final Alignment alignment;

  const BottomLine({
    super.key,
    this.widthFactor = 0.18,
    this.heightFactor = 0.01,
    this.imageAsset = "assets/bottom_line.png",
    this.color,
    this.fit,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
        width: screenWidth * widthFactor,
        height: max(1, screenWidth * heightFactor),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imageAsset),
            colorFilter:
                color != null
                    ? ColorFilter.mode(color!, BlendMode.srcIn)
                    : null,
            fit: fit,
            alignment: alignment,
          ),
        ),
      ),
    );
  }
}
