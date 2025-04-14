import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../colors_and_other_constants/colors.dart';
import 'ThemeProvider.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColors.CharcoalBlack : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.CharcoalBlack : AppColors.GoldCream,
        leading: IconButton(
          onPressed: () => context.go('/home'),
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        title: Text(
          'Terms and Conditions',
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Terms and Conditions',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'By using this app, you agree to the following terms and conditions. This includes compliance with all applicable laws and regulations, and the acknowledgment that you are responsible for your use of the services. We reserve the right to modify or update these terms at any time, and it is your responsibility to check for updates regularly. Continued use of the app implies acceptance of the updated terms. Please note that any violations of these terms could result in termination of your access to the app. For further information, please contact support.',
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black87,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
