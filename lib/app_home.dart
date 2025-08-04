import 'package:flutter/material.dart';
import 'package:neko_dex/pages/home_page.dart';
import 'package:neko_dex/pages/reading_list_page.dart';
import 'package:neko_dex/widgets/bottom_app_bar.dart';

class AppHome extends StatefulWidget {
  const AppHome({super.key});

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  int _pageIndex = 0;
  
  final List<Widget> _pages = [
    HomePage(),
    ReadingList()
  ];  
  
  void _changePage(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _pages[_pageIndex],
      bottomNavigationBar: MyBottomAppBar(changePage: _changePage, pageIndex: _pageIndex, pages: _pages),
    );
  }
}