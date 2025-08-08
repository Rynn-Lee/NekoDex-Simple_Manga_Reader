import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchExternalUrl(url) async {
  final uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}

class OpenLinkButton extends StatelessWidget {
  final String url;

  const OpenLinkButton({super.key, required this.url});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => launchExternalUrl(url),
      child: const Icon(Icons.link_rounded, size: 24,)
    );
  }
}

