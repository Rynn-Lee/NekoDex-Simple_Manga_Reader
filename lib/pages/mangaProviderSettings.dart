import 'package:flutter/material.dart';

class MangaProviderSettingsPage extends StatelessWidget {
  final Widget child;
  const MangaProviderSettingsPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Manga Provider Settings'),
      ),
      body: child
    );
  }
}