import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marquee/marquee.dart';

Widget buildScrollingTitle(String text, TextStyle style, double maxWidth, BuildContext context) {
  final textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: 1,
    textDirection: TextDirection.ltr,
  )..layout(minWidth: 0, maxWidth: double.infinity);

  final textWidth = textPainter.size.width;

  final Widget child = textWidth <= maxWidth
      ? Text(
          text,
          style: style,
          overflow: TextOverflow.ellipsis,
        )
      : Marquee(
          text: text,
          style: style,
          blankSpace: 30.0,
          velocity: 30.0,
          pauseAfterRound: Duration(seconds: 2),
          scrollAxis: Axis.horizontal,
          accelerationDuration: Duration(seconds: 1),
          accelerationCurve: Curves.linear,
          decelerationDuration: Duration(milliseconds: 500),
          decelerationCurve: Curves.easeOut,
        );

  return GestureDetector(
    onTap: () {
      Clipboard.setData(ClipboardData(text: text));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
          showCloseIcon: true,
          closeIconColor: Theme.of(context).colorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          content: Text('Title copied', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
        ),
      );
    },
    child: child,
  );
}