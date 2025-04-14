import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool isPassword;
  final bool isConfirmPassword;
  final double elevation;
  final double height; // ✅ Custom height parameter
  final double width; // ✅ Custom width parameter added
  const CustomTextField({
    super.key,
    this.hintText = "Enter text",
    this.controller,
    this.keyboardType,
    this.isPassword = false,
    this.isConfirmPassword = false,
    this.elevation = 0,
    this.height = 40, // ✅ Default height
    this.width = double.infinity, // ✅ Default full width
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(screenWidth * 0.01),
        child: Material(
          color: Colors.transparent,
          elevation: widget.elevation,
          shadowColor: Colors.black54,
          child: SizedBox(
            width: widget.width,
            height: widget.height, // ✅ Custom height applied here
            child: TextField(
              controller: widget.controller,
              keyboardType: widget.keyboardType ?? TextInputType.text,
              obscureText:
                  widget.isPassword || widget.isConfirmPassword
                      ? _obscureText
                      : false,
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.045,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: screenWidth * 0.04,
                ),
                filled: true,
                fillColor: const Color.fromRGBO(54, 51, 51, 1),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.06,
                  vertical: widget.height * 0.2, // ✅ Height-based padding
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.01),
                  borderSide: BorderSide.none,
                ),
                suffixIcon:
                    widget.isPassword || widget.isConfirmPassword
                        ? IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                            size: screenWidth * 0.06,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        )
                        : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
