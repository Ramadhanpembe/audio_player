import 'package:flutter/cupertino.dart';

bool hasTextOverflow(
  String text,
  TextStyle style, {
  double minWidth = 0,
  required double maxWidth,
  int maxLines = 1,
}) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: maxLines,
    textDirection: TextDirection.ltr,
  )..layout(minWidth: minWidth, maxWidth: maxWidth);
  return textPainter.didExceedMaxLines;
}
