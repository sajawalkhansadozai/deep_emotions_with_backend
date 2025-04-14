import 'package:deep_emotions_with_backend/Screens/DonationScreen/donationscreen.dart';
import 'package:deep_emotions_with_backend/Screens/HomeScreen/Contact.dart';
import 'package:deep_emotions_with_backend/Screens/HomeScreen/TermandCondition.dart';
import 'package:deep_emotions_with_backend/Screens/HomeScreen/homescreen.dart';
import 'package:deep_emotions_with_backend/Screens/HomeScreen/notificationscreen.dart';
import 'package:deep_emotions_with_backend/Screens/HomeScreen/profile.dart';
import 'package:deep_emotions_with_backend/Screens/OnBoardingScreen/onboarding.dart';
import 'package:deep_emotions_with_backend/Screens/SignInScreen/signinscreen.dart';
import 'package:deep_emotions_with_backend/Screens/SignUpScreen/signupscreen.dart';
import 'package:deep_emotions_with_backend/Screens/SplashScreen/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ✅ Add a Global Navigator Key
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey, // ✅ Prevents conflicts
  initialLocation: '/', // Default opening screen
  routes: [
    GoRoute(path: '/', builder: (context, state) => SplashScreen()),
    GoRoute(path: '/home', builder: (context, state) => HomeScreen()),
    GoRoute(path: '/signIn', builder: (context, state) => SignInScreen()),
    GoRoute(path: '/signUp', builder: (context, state) => SignUpScreen()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => OnBoardingScreen(),
    ),
    GoRoute(
      path: '/donation',
      builder: (context, state) {
        // Extract the videoId correctly (since it's passed as a string)
        final String? videoId = state.extra as String?;

        if (videoId == null || videoId.isEmpty) {
          throw Exception('videoId is required for DonationScreen');
        }

        return DonationScreen(videoId: videoId);
      },
    ),
    GoRoute(path: '/profile', builder: (context, state) => Profile()),
    GoRoute(path: '/terms', builder: (context, state) => TermsScreen()),
    GoRoute(path: '/contact', builder: (context, state) => ContactUsScreen()),

    // Route for Video Detail Page
    GoRoute(
      path: '/notification',
      builder: (context, state) => NotificationsPage(),
    ),
  ],
);
