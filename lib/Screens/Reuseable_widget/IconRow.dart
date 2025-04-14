import 'package:deep_emotions_with_backend/Screens/colors_and_other_constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class IconRow extends StatelessWidget {
  const IconRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(color: AppColors.CreamBlack),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // ✅ Corrected Home Button
          GestureDetector(
            onTap: () {
              GoRouter.of(context).go('/home');
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.home, color: AppColors.GoldCream),
                SizedBox(height: 2),
                Text(
                  'Home',
                  style: TextStyle(color: AppColors.GoldCream, fontSize: 12),
                ),
              ],
            ),
          ),

          // ✅ Corrected Notice Button
          GestureDetector(
            onTap: () {
              GoRouter.of(context).go('/notification');
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications, color: Colors.white),
                SizedBox(height: 2),
                Text(
                  'Notice',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),

          // ✅ Corrected Mine Button
          GestureDetector(
            onTap: () {
              GoRouter.of(context).go('/profile');
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.person, color: Colors.white),
                SizedBox(height: 2),
                Text(
                  'Mine',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
