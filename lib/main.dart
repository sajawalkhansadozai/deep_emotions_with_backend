import 'package:deep_emotions_with_backend/Screens/HomeScreen/ThemeProvider.dart';
import 'package:deep_emotions_with_backend/Screens/HomeScreen/comment_provider.dart';
import 'package:deep_emotions_with_backend/Screens/NavigationService/routes.dart';
import 'package:deep_emotions_with_backend/Screens/colors_and_other_constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CommentProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(
      context,
    ); // Access ThemeProvider

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router, // Ensure the router is correctly configured
      themeMode:
          themeProvider.isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light, // Handle dark mode
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: AppColors.GoldCream,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black)),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.CharcoalBlack,
        primaryColor: AppColors.GoldCream,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.CharcoalBlack,
          foregroundColor: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      ),
    );
  }
}
