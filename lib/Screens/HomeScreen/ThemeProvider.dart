import 'package:flutter/material.dart';
import '../colors_and_other_constants/colors.dart';

class ThemeProvider extends ChangeNotifier {
  // Default theme: Dark Mode
  ThemeData _currentTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor:
        AppColors.CharcoalBlack, // Assuming you have this color defined
    primaryColor: Colors.white,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      headlineSmall: TextStyle(color: Colors.white),
    ),
  );

  ThemeData get currentTheme => _currentTheme;

  bool get isDarkMode => _currentTheme.brightness == Brightness.dark;

  // Toggle between light and dark themes
  void toggleTheme() {
    _currentTheme =
        _currentTheme.brightness == Brightness.dark
            ? ThemeData(
              brightness: Brightness.light,
              scaffoldBackgroundColor: Colors.white,
              primaryColor: Colors.black,
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: Colors.black),
                headlineSmall: TextStyle(color: Colors.black),
              ),
            )
            : ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: AppColors.CharcoalBlack,
              primaryColor: Colors.white,
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: Colors.white),
                headlineSmall: TextStyle(color: Colors.white),
              ),
            );
    notifyListeners(); // Notify listeners to rebuild the UI
  }
}
