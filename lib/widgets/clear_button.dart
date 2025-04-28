import 'package:digital_calculator/constants.dart';
import 'package:flutter/material.dart';

class ClearButton extends StatelessWidget {
  const ClearButton({
    super.key,
    required this.width,
    required this.onTap,
    required this.onLongPress,
  });
  final double width;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color:
              (MediaQuery.platformBrightnessOf(context) == Brightness.light)
                  ? chineseBlue
                  : hanBlue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const AspectRatio(
          aspectRatio: 1,
          child: Center(
            child: Text(
              "C",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
