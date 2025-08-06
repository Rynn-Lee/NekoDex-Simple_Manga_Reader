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
  String _searchQuery = "";
  late Map<String, dynamic> _selectedSource;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _sources = [
    {
      "name": "MangaDex",
      "iconPath": "lib/assets/icons/mangadex-logo.svg",
      "controller": MangadexController()
    },{
      "name": "MangaLib [ru]",
      "iconPath": "lib/assets/icons/mangalib-logo.svg",
      "controller": MangadexController()
    },
  ];
  
  @override
  void initState() {
    super.initState();
    _selectedSource = _sources.first;
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
  
  void _onSearchSubmit() {
    final source = _sources.firstWhere((element) => element["name"] == _selectedSource["name"]);
    widget.fetchManga(source["controller"], _searchQuery); // Очищаем поле();
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
            centerTitle: !_isSearching && _searchQuery.isEmpty ? true : false,
            elevation: 8.0,
            surfaceTintColor: Colors.transparent,
            backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(200),
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: themeNotifier.themeMode == ThemeMode.dark ? Color(0xff1f1f1f) : Colors.white,
              statusBarIconBrightness: themeNotifier.themeMode == ThemeMode.dark ? Brightness.light : Brightness.dark,
            ),
            leading: leadingPopupMenu(context),
            title: _isSearching ? TextField(
              controller: _searchController,
              onSubmitted: (_) => _onSearchSubmit(),
              autofocus: true,
              onChanged: _onSearchChange,
              decoration: InputDecoration(
                hintText: 'Search on ${_selectedSource['name']}',
                hintStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimary.withAlpha(100)),
                border: InputBorder.none,
              ),
            )
              : !_isSearching && _searchQuery.isEmpty
                ? Text("NekoLib")
                : TextButton(
                  onPressed: _toggleSearch,
                  child: Text(_searchQuery, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),)),
            titleTextStyle: TextStyle(
              fontFamily: "Monospace",
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 17.0,
            ),
            actions: [
              searchToggleButton(),
              sendRequestAndSettings()
            ],
          ),
      ),
    );
  }

  AnimatedSwitcher sendRequestAndSettings() {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return SizeTransition(
          sizeFactor: animation,
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: _isSearching
        ? IconButton(
            key: ValueKey('send'),
            onPressed: _onSearchSubmit,
            icon: Icon(Icons.send_rounded, color: Theme.of(context).colorScheme.onPrimary, size: 24),
          )
        : Container(
          margin: EdgeInsets.only(right: 14, left: 10),
          child: PopupMenuButton<String>(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          surfaceTintColor: Colors.transparent,
          color: Theme.of(context).colorScheme.primary,
            key: ValueKey('settings'),
            onSelected: (value) {
              switch (value) {
                case 'theme':
                  _changeAppMode();
                  break;
                case 'settings':
                  Navigator.pushNamed(context, '/settings');
                  break;
                default:
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'theme',
                child: Row(
                  children: [
                    Icon(themeNotifier.themeMode == ThemeMode.dark ? Icons.dark_mode_rounded : Icons.light_mode_rounded, color: Theme.of(context).colorScheme.onPrimary, size: 24),
                    SizedBox(width: 8),
                    Text('Сменить тему'),
                  ],
                )
              ),
              PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings_rounded, color: Theme.of(context).colorScheme.onPrimary, size: 24),
                    SizedBox(width: 8),
                    Text('Все настройки'),
                  ],
                )
              ),
            ],
            child: Icon(Icons.settings_rounded, color: Theme.of(context).colorScheme.onPrimary, size: 24),
          ),
        ),
    );
  }

  IconButton searchToggleButton() {
    return IconButton(
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
    );
  }

  PopupMenuButton<Object> leadingPopupMenu(BuildContext context) {
    return PopupMenuButton(
      icon: SvgPicture.asset(_selectedSource['iconPath'], height: 24.0, width: 24.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      surfaceTintColor: Colors.transparent,
      color: Theme.of(context).colorScheme.primary,
      onSelected: (value) {
        setState(() {
          _selectedSource = _sources.firstWhere((element) => element["name"] == value);
        });
      },
      itemBuilder: (context) => _sources.map((source) => PopupMenuItem(
        value: source["name"],
        child: Row(
          children: [
            SvgPicture.asset(source["iconPath"], height: 24.0, width: 24.0),
            SizedBox(width: 6,),
            Expanded(child: Text(source["name"]))
          ],
        ),
      )).toList()
    );
  }
}