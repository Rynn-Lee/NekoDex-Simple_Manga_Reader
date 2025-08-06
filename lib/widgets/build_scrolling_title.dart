import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

Widget buildScrollingTitle(String text, TextStyle style, double maxWidth) {
  // Создаём текст painter для измерения
  final textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: 1,
    textDirection: TextDirection.ltr,
  )..layout(minWidth: 0, maxWidth: double.infinity);

  final textWidth = textPainter.size.width;

  if (textWidth <= maxWidth) {
    // Текст помещается → просто выводим
    return Text(
      text,
      style: style,
      overflow: TextOverflow.ellipsis,
    );
  } else {
    // Текст длинный → используем Marquee
    return Marquee(
      text: text,
      style: style,
      blankSpace: 30.0,
      velocity: 30.0,
      pauseAfterRound: Duration(seconds: 2),
      scrollAxis: Axis.horizontal,
      // startPadding: 10.0,
      accelerationDuration: Duration(seconds: 1),
      accelerationCurve: Curves.linear,
      decelerationDuration: Duration(milliseconds: 500),
      decelerationCurve: Curves.easeOut,
    );
  }
}