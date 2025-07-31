import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neko_dex/pages/home_page.dart';
import 'package:neko_dex/pages/reading_list.dart';

void main() {
  runApp(const NekoDex());
}

class NekoDex extends StatefulWidget {
  const NekoDex({super.key});

  @override
  State<NekoDex> createState() => _NekoDexState();
}

class _NekoDexState extends State<NekoDex> with TickerProviderStateMixin{
  int _pageIndex = 0;
  ThemeMode _themeMode = ThemeMode.system;

  final List<Widget> _pages = const [
    HomePage(),
    ReadingList()
  ];

  void _changePage(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  void _changeAppMode() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
      _updateSystemUI(); // Добавляем вызов функции для обновления системной панели
    });
  }

  @override
  void initState() {
    super.initState();
    _updateSystemUI(); // Обновляем системную панель при инициализации приложения
  }

  void _updateSystemUI() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Прозрачный статус-бар
      systemNavigationBarColor: _themeMode == ThemeMode.dark ? Colors.black.withAlpha(10) : Colors.white.withAlpha(10), // Цвет навигационной панели
      systemNavigationBarIconBrightness: _themeMode == ThemeMode.dark ? Brightness.light : Brightness.dark, // Цвет иконок навигационной панели
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: _themeMode == ThemeMode.dark ? Color(0xff151515) : Colors.white,
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "NekoDex",
        theme: _themeMode == ThemeMode.dark ? ThemeData.dark() : ThemeData.light(),
        home: Scaffold(
          appBar: appBarMethod(),
          body: _pages[_pageIndex],
          bottomNavigationBar: bottomAppBarMethod(),
        ),
      ),
    );
  }

  AppBar appBarMethod() {
    return AppBar(
        centerTitle: true,
        elevation: 8.0,
        surfaceTintColor: Colors.transparent,
      backgroundColor: _themeMode == ThemeMode.dark ? Colors.black.withAlpha(10) : Colors.white.withAlpha(10),
        title: const Text("NekoDex"),
        titleTextStyle: TextStyle(
          fontFamily: "Monospace",
          color: _themeMode == ThemeMode.dark ? Colors.white : Colors.black,
          fontSize: 17.0,
        ),
        actions: [
          IconButton(
            icon: _themeMode == ThemeMode.dark ? const Icon(Icons.dark_mode) : const Icon(Icons.light_mode),
            onPressed: _changeAppMode,
          ),
        ],
      );
  }

  BottomNavigationBar bottomAppBarMethod() {
    return BottomNavigationBar(
      backgroundColor: _themeMode == ThemeMode.dark ? Colors.black.withAlpha(10) : Colors.white.withAlpha(10),
      elevation: 0.0,
      currentIndex: _pageIndex,
      onTap: _changePage,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: "Home",
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.menu_book_rounded),
          label: "Reading",
        ),
      ]
    );
  }
}