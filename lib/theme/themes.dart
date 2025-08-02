import 'package:flutter/material.dart';

ThemeData myLightTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: Colors.white, //Front UI
    onPrimary: Colors.black, //Front UI text
    secondary: Colors.white70, //Background UI
    onSecondary: Colors.black87, //Background UI text
    tertiary: Colors.deepOrangeAccent,
    onTertiary: Colors.white
  )
);

ThemeData myDarkTheme = ThemeData(
  colorScheme: const ColorScheme.dark(
    primary: Color(0xff1f1f1f), //Front UI
    onPrimary: Colors.white, //Front UI text
    secondary: Color(0xff212121), //Background UI
    onSecondary: Colors.white70, //Background UI text
    tertiary: Colors.deepOrangeAccent,
    onTertiary: Colors.white
  )
);