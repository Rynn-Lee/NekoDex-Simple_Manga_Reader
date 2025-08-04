import 'dart:ui';

import 'package:flutter/material.dart';

class MyBottomAppBar extends StatefulWidget {
  final int pageIndex;
  final List<Widget> pages;
  final void Function (int index) changePage;
  const MyBottomAppBar({super.key, required this.pageIndex, required this.pages, required this.changePage});

  @override
  State<MyBottomAppBar> createState() => _MyBottomAppBarState();
}

class _MyBottomAppBarState extends State<MyBottomAppBar> {


  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
        color: Theme.of(context).colorScheme.primary.withAlpha(200),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            currentIndex: widget.pageIndex,
            onTap: widget.changePage,
            selectedItemColor: Theme.of(context).colorScheme.onPrimary, // Цвет выбранного текста и иконки
            unselectedItemColor: Colors.grey, // Цвет невыбранного текста и иконки
            items: [
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.search_rounded, color: Colors.orangeAccent),
                icon: Icon(Icons.search_rounded),
                label: "Search",
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.menu_book_rounded, color: Colors.orangeAccent),
                icon: Icon(Icons.menu_book_rounded),
                label: "My Lists",
              ),
            ]
          ),
        ),
      ),
    );
  }
}