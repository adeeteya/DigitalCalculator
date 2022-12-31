import 'package:digital_calculator/constants.dart';
import 'package:flutter/material.dart';

class CalculatorButton extends StatefulWidget {
  const CalculatorButton({
    Key? key,
    this.isBlue = false,
    this.isDoubleTile = false,
    required this.width,
    required this.text,
    required this.onTap,
  }) : super(key: key);
  final double width;
  final bool isBlue;
  final String text;
  final bool isDoubleTile;
  final VoidCallback onTap;
  @override
  State<CalculatorButton> createState() => _CalculatorButtonState();
}

class _CalculatorButtonState extends State<CalculatorButton> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        setState(() {
          isPressed = true;
        });
      },
      onPointerUp: (event) {
        setState(() {
          isPressed = false;
        });
        widget.onTap();
      },
      child: AnimatedContainer(
        width: widget.width,
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: (MediaQuery.of(context).platformBrightness == Brightness.light)
              ? (widget.isBlue)
                  ? chineseBlue
                  : antiFlashWhite
              : (widget.isBlue)
                  ? hanBlue
                  : charlestonGreen,
          borderRadius: BorderRadius.circular(20),
          boxShadow: (isPressed || widget.isBlue)
              ? null
              : (MediaQuery.of(context).platformBrightness == Brightness.light)
                  ? const [
                      BoxShadow(
                        color: darkVioletBlue,
                        offset: Offset(5, 5),
                        blurRadius: 10,
                      ),
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(-5, -5),
                        blurRadius: 10,
                      ),
                    ]
                  : const [
                      BoxShadow(
                        color: raisinBlack,
                        offset: Offset(5, 5),
                        blurRadius: 10,
                      ),
                      BoxShadow(
                        color: gunMetal,
                        offset: Offset(-5, -5),
                        blurRadius: 10,
                      ),
                    ],
        ),
        child: AspectRatio(
          aspectRatio: (widget.isDoubleTile) ? 2.1 : 1,
          child: Center(
            child: Text(
              widget.text,
              style: TextStyle(
                color: (widget.isBlue)
                    ? Colors.white
                    : (MediaQuery.of(context).platformBrightness ==
                            Brightness.light)
                        ? chineseBlue
                        : hanBlue,
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
