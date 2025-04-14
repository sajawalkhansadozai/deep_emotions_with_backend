import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:deep_emotions_with_backend/Screens/Reuseable_widget/Reuseablelogo.dart';
import 'package:deep_emotions_with_backend/Screens/Reuseable_widget/bottom_line.dart';
import 'package:deep_emotions_with_backend/Screens/Reuseable_widget/headertext.dart';
import 'package:deep_emotions_with_backend/Screens/Reuseable_widget/orwidget.dart';
import 'package:deep_emotions_with_backend/Screens/Reuseable_widget/textfield.dart';
import 'package:deep_emotions_with_backend/Screens/colors_and_other_constants/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  // Validate Email
  bool isValidEmail(String email) {
    return RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.(com|org|pk|gov|net|edu|info|biz|co|us|uk|ca|au|in|eu|asia|me|io|tv|ly|app|dev|ai|cloud|tech|store|online|xyz|site|blog|club|shop|fun|mobi|live|work|email|news|space|world|global|today|life|one|name|pro|host|design|art|media|agency|group|solutions|services|expert|consulting|company|network|center|community|academy|institute|foundation)$",
    ).hasMatch(email);
  }

  // Validate Password
  bool isValidPassword(String password) {
    return RegExp(
      r"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*(),.?{}|<>]).{8,}$",
    ).hasMatch(password);
  }

  // Email and Password Sign-Up
  Future<void> _signUpWithEmailAndPassword() async {
    setState(() {
      _isLoading = true;
    });

    if (_fullNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('All fields are required')));
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (!isValidEmail(_emailController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a valid email address with a valid domain (e.g., .com, .org)',
          ),
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (!isValidPassword(_passwordController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Password must contain at least one capital letter, one special character, and be at least 8 characters long',
          ),
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      // Check if email is already registered
      List<String> signInMethods = await _auth.fetchSignInMethodsForEmail(
        _emailController.text.trim(),
      );

      if (signInMethods.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('The email is already registered.')),
        );
        setState(() {
          _isLoading = false;
        });
        Future.delayed(const Duration(seconds: 2), () {
          GoRouter.of(context).go('/signIn');
        });
        return;
      }

      // Create user
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      if (userCredential.user != null) {
        // Store user profile in Firestore
        final String userId = userCredential.user!.uid;
        await _firestore.collection('Users').doc(userId).set({
          'name': _fullNameController.text.trim(),
          'email': _emailController.text.trim(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully')),
        );

        GoRouter.of(context).go('/signIn'); // Navigate to Sign In screen
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred. Please try again later.';
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
        Future.delayed(const Duration(seconds: 2), () {
          GoRouter.of(context).go('/signIn');
        });
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.CharcoalBlack,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: screenWidth * 0.08,
            right: screenWidth * 0.08,
            top: screenHeight * 0.06,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderText('Create Account'),
              SizedBox(height: screenHeight * 0.06),
              CustomTextField(
                hintText: "Your Full Name",
                controller: _fullNameController,
              ),
              SizedBox(height: screenHeight * 0.02),
              CustomTextField(
                hintText: "Your Email Address",
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: screenHeight * 0.02),
              CustomTextField(
                hintText: "Password",
                controller: _passwordController,
                isPassword: true,
              ),
              SizedBox(height: screenHeight * 0.02),
              CustomTextField(
                hintText: "Confirm Password",
                controller: _confirmPasswordController,
                isPassword: true,
              ),
              SizedBox(height: screenHeight * 0.08),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                    children: [
                      Center(
                        child: SizedBox(
                          width: screenWidth * 0.8,
                          height: screenHeight * 0.07,
                          child: ElevatedButton(
                            onPressed: _signUpWithEmailAndPassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.GoldCream,
                              foregroundColor: AppColors.CharcoalBlack,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  screenWidth * 0.03,
                                ),
                              ),
                            ),
                            child: Text(
                              "Sign Up",
                              style: TextStyle(fontSize: screenWidth * 0.045),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      OrDivider(),
                      SizedBox(height: screenHeight * 0.02),
                      ReuseableLogo(), // Reusable logo for third-party sign-ins
                    ],
                  ),
              SizedBox(height: screenHeight * 0.2),
              BottomLine(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }
}
