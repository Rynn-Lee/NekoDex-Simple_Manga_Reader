import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final String searchQuery;
  const HomePage({super.key, required this.searchQuery});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<dynamic> _posts = [];

  @override
  void initState() {
    super.initState();
    _getPosts();
  }

  Future<void> _getPosts() async {
    final url = Uri.parse("https://api.mangadex.org/manga?title=${widget.searchQuery}");
    final response = await http.get(url);

    if(response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data['posts']);
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        itemCount: _posts.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 4, crossAxisSpacing: 4),
        itemBuilder: (context, index) {
          final post = _posts[index];
          return Card(
            child: Column(
              children: [
                Text(post["title"]),
              ],
            ),
          );
        }
      )
    );
  }
}