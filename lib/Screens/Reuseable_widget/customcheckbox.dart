import 'package:deep_emotions_with_backend/Screens/colors_and_other_constants/colors.dart';
import 'package:flutter/material.dart';

class CustomCheckbox extends StatefulWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomCheckbox({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(
        left: screenWidth * 0.05,
      ), // ✅ 7.5% of screen width
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width:
                screenWidth *
                0.06, // ✅ Responsive Checkbox Size (6% of screen width)
            height: screenWidth * 0.06,
            child: Checkbox(
              fillColor: WidgetStateProperty.resolveWith<Color>((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.white; // ✅ Box color when checked
                }
                return AppColors.CharcoalBlack; // ✅ Box color when unchecked
              }),
              checkColor: Colors.black, // ✅ Tick color when checked
              value: widget.value,
              onChanged: (bool? newValue) {
                widget.onChanged(newValue ?? false);
              },
            ),
          ),
          SizedBox(width: screenWidth * 0.02), // ✅ Responsive spacing
          Text(
            widget.label,
            style: TextStyle(
              color: Colors.white,
              fontSize:
                  screenWidth *
                  0.04, // ✅ Responsive Font Size (4% of screen width)
            ),
          ),
        ],
      ),
    );
  }
}
