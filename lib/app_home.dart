import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neko_dex/pages/home_page.dart';
import 'package:neko_dex/pages/reading_list_page.dart';
import 'package:neko_dex/theme/theme_motifier.dart';
import 'package:provider/provider.dart';

class AppHome extends StatefulWidget {
  const AppHome({super.key});

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  int _pageIndex = 0;

  void _changeAppMode() {
    Provider.of<ThemeNotifier>(context, listen: false).toggleTheme();
    _updateSystemUI();
  }

  final List<Widget> _pages = const [
    HomePage(),
    ReadingList()
  ];

  void _changePage(int index) {
    setState(() {
      _pageIndex = index;
    });
  }
  
  @override
  void initState() {
    super.initState();
    _updateSystemUI(); // Обновляем системную панель при инициализации приложения
  }

  void _updateSystemUI() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarIconBrightness: Provider.of<ThemeNotifier>(context, listen: false).themeMode == ThemeMode.dark ? Brightness.light : Brightness.dark, // Цвет иконок навигационной панели
    ));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_pageIndex],
      appBar: appBarMethod(),
      bottomNavigationBar: bottomAppBarMethod(),
    );
  }

  AppBar appBarMethod() {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return AppBar(
        centerTitle: true,
        elevation: 8.0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("NekoDex"),
        titleTextStyle: TextStyle(
          fontFamily: "Monospace",
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: 17.0,
        ),
        actions: [
          IconButton(
            icon: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return SizeTransition(
                  sizeFactor: animation,
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: Icon(themeNotifier.themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode, key: ValueKey(themeNotifier.themeMode))
            ),
            onPressed: _changeAppMode,
          ),
        ],
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