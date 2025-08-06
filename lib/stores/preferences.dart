import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveTheme(ThemeMode theme) async {
  final prefs = await SharedPreferences.getInstance();
  final saveTheme = theme == ThemeMode.dark ? 'dark' : 'light';
  await prefs.setString('theme', saveTheme);
}

Future<ThemeMode> loadTheme() async {
  final prefs = await SharedPreferences.getInstance();
  final theme = prefs.getString('theme') ?? 'dark';
  return theme == 'dark' ? ThemeMode.dark : ThemeMode.light;
}