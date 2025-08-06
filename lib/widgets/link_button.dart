import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OpenLinkButton extends StatelessWidget {
  final String url;

  const OpenLinkButton({super.key, required this.url});

  Future<void> _launchUrl() async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _launchUrl,
      child: const Icon(Icons.link_rounded, size: 24,)
    );
  }
}