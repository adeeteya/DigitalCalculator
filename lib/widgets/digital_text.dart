import 'package:digital_calculator/constants.dart';
import 'package:flutter/material.dart';

class DigitalText extends StatelessWidget {
  const DigitalText(
      {Key? key,
      required this.initialMaxChars,
      required this.text,
      required this.scrollController})
      : super(key: key);
  final int initialMaxChars;
  final String text;
  final ScrollController scrollController;
  @override
  Widget build(BuildContext context) {
    String bgDisplayText = "";
    int maxChars = initialMaxChars;
    if (text.length > initialMaxChars) {
      maxChars = text.length;
    }
    for (int i = 0; i < maxChars; i++) {
      bgDisplayText += "8";
    }
    return SingleChildScrollView(
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      physics: (initialMaxChars > text.length)
          ? const NeverScrollableScrollPhysics()
          : const BouncingScrollPhysics(),
      reverse: true,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: onyx,
              fontSize: 35,
              fontFamily: "Digital Numbers",
            ),
            maxLines: 1,
          ),
          Text(
            bgDisplayText,
            style: TextStyle(
              color: onyx.withOpacity(0.08),
              fontSize: 35,
              fontFamily: "Digital Numbers",
            ),
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
