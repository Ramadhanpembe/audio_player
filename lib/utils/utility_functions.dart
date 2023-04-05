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

String durationFormatter(int milliseconds) {
  Duration duration = Duration(milliseconds: milliseconds);
  String formatDuration(int n) => n.toString().padLeft(2, '0');
  String minutes = formatDuration(duration.inMinutes.remainder(60));
  String seconds = formatDuration(duration.inSeconds.remainder(60));
  return '${formatDuration(duration.inHours)}:$minutes:$seconds';
}

String megabytesFromBytes(int bytes) {
  return (bytes / 1000000).toStringAsFixed(1);
}
