import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:deep_emotions_with_backend/Screens/Reuseable_widget/Reuseablelogo.dart';
import 'package:deep_emotions_with_backend/Screens/Reuseable_widget/bottom_line.dart';
import 'package:deep_emotions_with_backend/Screens/Reuseable_widget/customcheckbox.dart';
import 'package:deep_emotions_with_backend/Screens/Reuseable_widget/headertext.dart';
import 'package:deep_emotions_with_backend/Screens/Reuseable_widget/orwidget.dart';
import 'package:deep_emotions_with_backend/Screens/Reuseable_widget/textfield.dart';
import 'package:deep_emotions_with_backend/Screens/colors_and_other_constants/colors.dart';
import 'package:go_router/go_router.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _rememberMe = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials(); // Load saved credentials on startup
  }

  Future<void> _loadSavedCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? savedEmail = prefs.getString('email');
    final String? savedPassword = prefs.getString('password');

    if (savedEmail != null && savedPassword != null) {
      _emailController.text = savedEmail;
      _passwordController.text = savedPassword;
      _rememberMe = true;
      setState(() {});
    }
  }

  Future<void> _saveCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString('email', _emailController.text.trim());
      await prefs.setString('password', _passwordController.text.trim());
    } else {
      await prefs.remove('email');
      await prefs.remove('password');
    }
  }

  Future<void> _signInWithEmailAndPassword() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await _saveCredentials(); // Save login details if "Remember Me" is checked

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Sign-in successful')));

      GoRouter.of(context).go('/home'); // Navigate using GoRouter
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred. Please try again.';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided.';
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
              HeaderText('Sign In'),
              SizedBox(height: screenHeight * 0.1),
              CustomTextField(
                hintText: "Your email address",
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: screenHeight * 0.03),
              CustomTextField(
                hintText: "Password",
                controller: _passwordController,
                isPassword: true,
              ),
              SizedBox(height: screenHeight * 0.04),
              CustomCheckbox(
                label: "Remember Me",
                value: _rememberMe,
                onChanged: (bool newValue) {
                  setState(() {
                    _rememberMe = newValue;
                  });
                },
              ),
              SizedBox(height: screenHeight * 0.06),

              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Center(
                    child: SizedBox(
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.07,
                      child: ElevatedButton(
                        onPressed: _signInWithEmailAndPassword,
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
                          "Sign In",
                          style: TextStyle(fontSize: screenWidth * 0.045),
                        ),
                      ),
                    ),
                  ),

              SizedBox(height: screenHeight * 0.02),
              OrDivider(),
              SizedBox(height: screenHeight * 0.02),
              ReuseableLogo(),
              SizedBox(height: screenHeight * 0.1),
              Center(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.white,
                    ),
                    children: [
                      const TextSpan(text: "Don't have an account? "),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () => GoRouter.of(context).go('/signUp'),
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: AppColors.GoldCream,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.15),
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
    super.dispose();
  }
}
