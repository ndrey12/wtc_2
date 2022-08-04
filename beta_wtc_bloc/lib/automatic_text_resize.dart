import 'package:flutter/material.dart';

Size textSize(String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr)
    ..layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.size;
}

class AutmaticTextSize {
  static int getMaxSize(
      String text, double width, double height, int startingSize) {
    for (int i = startingSize; i >= 1; i--) {
      final TextStyle textStyle = TextStyle(
        fontSize: i.toDouble(),
        color: Colors.white,
      );
      Size varSize = textSize(text, textStyle);
      if (varSize.width > width || varSize.height > height) {
        continue;
      }
      return i;
    }
    return 1;
  }
}
