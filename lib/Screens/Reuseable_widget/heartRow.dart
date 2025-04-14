import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HeartLine extends StatelessWidget {
  final String videoId; // 🔹 Accept videoId as a parameter

  const HeartLine({super.key, required this.videoId});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          imageContainer(
            imagePath: 'assets/image3.png',
            onTap: () {
              // Navigate to DonationScreen with videoId
              GoRouter.of(context).push('/donation', extra: videoId);
            },
          ),
        ],
      ),
    );
  }

  Widget imageContainer({
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipOval(
        child: Container(height: 50, width: 50, child: Image.asset(imagePath)),
      ),
    );
  }
}
