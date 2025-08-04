import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:neko_dex/controllers/mangadex_controller.dart';
import 'package:neko_dex/models/manga_model.dart';
import 'package:neko_dex/theme/theme_motifier.dart';
import 'package:provider/provider.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Future<void> Function(MangaProvider controller, String searchQuery) fetchManga;
  const MyAppBar({super.key, required this.fetchManga});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  bool _isSearching = false;
  int _selectedSource = 0;
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  final List _sources = [
    ['MangaDex', 'lib/assets/icons/mangadex-logo.svg', MangadexController()],
    ['MangaLib [ru]', 'lib/assets/icons/mangalib-logo.svg', MangadexController()],
  ];
  
  @override
  void initState() {
    super.initState();
    _updateSystemUI();
  }

  void _toggleSearch(){
    setState(() {
      _isSearching = !_isSearching;
    });
  }

  void _changeAppMode() {
    Provider.of<ThemeNotifier>(context, listen: false).toggleTheme();
    _updateSystemUI();
  }
  
  void _updateSystemUI() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarIconBrightness: Provider.of<ThemeNotifier>(context, listen: false).themeMode == ThemeMode.dark ? Brightness.light : Brightness.dark, // Цвет иконок навигационной панели
    ));
  }

  void _changeSource() {
    setState(() {
      _selectedSource + 1 >= _sources.length ? _selectedSource = 0 : _selectedSource++;
    });
  }
  
  void _onSearchSubmit() {
    widget.fetchManga(_sources[_selectedSource][2], _searchQuery).then((value) => _searchController.clear()); // Очищаем поле();
    _toggleSearch();
  }

  void _onSearchChange(String value) {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return ClipRRect(
      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: AppBar(
            centerTitle: true,
            elevation: 8.0,
            surfaceTintColor: Colors.transparent,
            backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(200),
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: themeNotifier.themeMode == ThemeMode.dark ? Color(0xff1f1f1f) : Colors.white,
              statusBarIconBrightness: themeNotifier.themeMode == ThemeMode.dark ? Brightness.light : Brightness.dark,
            ),
            leading: Container(
              margin: EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.secondary.withAlpha(180)
              ),
              child: IconButton(
                onPressed: _changeSource,
                icon: SvgPicture.asset(_sources[_selectedSource][1], height: 24.0, width: 24.0),
              ),
            ),
            title: _isSearching ? TextField(
              controller: _searchController,
              autofocus: true,
              onChanged: _onSearchChange,
              decoration: InputDecoration(
                hintText: 'Search on ${_sources[_selectedSource][0]}',
                hintStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimary.withAlpha(100)),
                border: InputBorder.none,
              ),
            )
                : !_isSearching && _searchQuery.isEmpty
                  ? Text("NekoDex")
                  : Row(
                    children: [
                      _searchQuery.isNotEmpty
                        ? Icon(Icons.manage_search_rounded, color: Theme.of(context).colorScheme.onSecondary, size: 22)
                        : Container(),
                      Text(": $_searchQuery")
                    ],
                  ),
            titleTextStyle: TextStyle(
              fontFamily: "Monospace",
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 17.0,
            ),
            actions: [
              IconButton(
                onPressed: _toggleSearch,
                icon: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return SizeTransition(
                      sizeFactor: animation,
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
                  child: Icon(
                    _isSearching ? Icons.search_off_rounded : Icons.search_rounded,
                    key: ValueKey(_isSearching ? 'close' : 'search'),
                  ),
                ),
              ),
              IconButton(
                onPressed: _isSearching ? _onSearchSubmit : _changeAppMode,
                icon: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return SizeTransition(
                      sizeFactor: animation,
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
                  child: Icon(
                    _isSearching
                    ? Icons.send_rounded
                    : themeNotifier.themeMode == ThemeMode.dark
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    key: ValueKey(
                      _isSearching
                      ? 'send'
                      : themeNotifier.themeMode == ThemeMode.dark
                          ? 'dark'
                          : 'light',
                    ),
                  ),
                ),
              ),
            ],
          ),
      ),
    );
  }
}