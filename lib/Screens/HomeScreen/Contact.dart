import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../colors_and_other_constants/colors.dart';
import 'ThemeProvider.dart';

class ContactUsScreen extends StatelessWidget {
  ContactUsScreen({super.key});

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final textColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? AppColors.CharcoalBlack : Colors.white;
    final borderColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        leading: IconButton(
          onPressed: () => context.go('/home'),
          icon: Icon(Icons.arrow_back, color: textColor),
        ),
        title: Text('Contact Us', style: TextStyle(color: textColor)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'We would love to hear from you!',
                style: TextStyle(
                  color: textColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Please fill out the form below to send us your message.',
                style: TextStyle(color: textColor, fontSize: 16),
              ),
              const SizedBox(height: 30),

              // Name Field
              TextField(
                controller: _nameController,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  labelStyle: TextStyle(color: textColor),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Email Field
              TextField(
                controller: _emailController,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  labelStyle: TextStyle(color: textColor),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Message Field
              TextField(
                controller: _messageController,
                style: TextStyle(color: textColor),
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Message',
                  labelStyle: TextStyle(color: textColor),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Send Button
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    String name = _nameController.text.trim();
                    String email = _emailController.text.trim();
                    String message = _messageController.text.trim();

                    if (name.isEmpty || email.isEmpty || message.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('All fields are required!')),
                      );
                      return;
                    }

                    try {
                      await _firestore.collection('contact_us').add({
                        'name': name,
                        'email': email,
                        'message': message,
                        'timestamp': FieldValue.serverTimestamp(),
                      });

                      _nameController.clear();
                      _emailController.clear();
                      _messageController.clear();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Message sent successfully!')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to send message.')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.GoldCream,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text('Send Message', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
