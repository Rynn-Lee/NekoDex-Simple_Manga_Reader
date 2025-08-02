import 'package:flutter/material.dart';
import 'package:neko_dex/pages/home_page.dart';
import 'package:neko_dex/pages/reading_list_page.dart';

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
      body: _pages[_pageIndex],
      bottomNavigationBar: bottomAppBarMethod(),
    );
  }

  BottomNavigationBar bottomAppBarMethod() {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      elevation: 0.0,
      currentIndex: _pageIndex,
      onTap: _changePage,
      selectedItemColor: Theme.of(context).colorScheme.onPrimary, // Цвет выбранного текста и иконки
      unselectedItemColor: Colors.grey, // Цвет невыбранного текста и иконки
      items: [
        BottomNavigationBarItem(
          activeIcon: Icon(Icons.home_rounded, color: Colors.orangeAccent),
          icon: Icon(Icons.home_rounded),
          label: "Home",
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(Icons.menu_book_rounded, color: Colors.orangeAccent),
          icon: Icon(Icons.menu_book_rounded),
          label: "Reading",
        ),
      ]
    );
  }
}