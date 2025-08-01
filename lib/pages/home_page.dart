import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
    final url = Uri.parse("https://dummyjson.com/posts");
    final response = await http.get(url);

    if(response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data['posts']);
      setState(() {
        _posts = data['posts'];
      });
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: GridView.builder(
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
        ),
      )
    );
  }
}