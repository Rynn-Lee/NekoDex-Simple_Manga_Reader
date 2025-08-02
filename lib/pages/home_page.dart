import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:neko_dex/controllers/mangadex_controller.dart';
import 'package:neko_dex/models/manga_model.dart';
import 'package:neko_dex/theme/theme_motifier.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Manga> _manga = [];
  bool _isSearching = false;
  bool _isLoading = false;
  String _searchQuery = "";
  int _selectedSource = 0;
  final TextEditingController _searchController = TextEditingController();
  final List _sources = [
    ['MangaDex', 'lib/assets/icons/mangadex-logo.svg', MangadexController()],
    ['MangaLib [ru]', 'lib/assets/icons/mangalib-logo.svg', MangadexController()],
  ];

  @override
  void initState() {
    super.initState();
    fetchManga();
    _updateSystemUI(); // Обновляем системн
  }

  void _onSearchSubmit() {
    fetchManga();
    _toggleSearch();
  }

  void _changeAppMode() {
    Provider.of<ThemeNotifier>(context, listen: false).toggleTheme();
    _updateSystemUI();
  }

  void _changeSource() {
    setState(() {
      _selectedSource + 1 >= _sources.length ? _selectedSource = 0 : _selectedSource++;
    });
  }
  
  void _updateSystemUI() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarIconBrightness: Provider.of<ThemeNotifier>(context, listen: false).themeMode == ThemeMode.dark ? Brightness.light : Brightness.dark, // Цвет иконок навигационной панели
    ));
  }

  void _onSearchChange(String value) {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  void _toggleSearch(){
    setState(() {
      _isSearching = !_isSearching;
    });
  }

  Future<void> fetchManga() async {
    // if (_searchQuery.trim().isEmpty) return;
    setState(() {_isLoading = true;});
    try{
      MangaProvider controller = _sources[_selectedSource][2];
      final result = await controller.searchManga(_searchQuery);
      setState(() {
        _manga = result;
        _isLoading = false;
      });
    } catch (error) {
      throw Exception('Failed to fetch manga: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBarMethod(),
      body: _isLoading 
        ? Center(child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Theme.of(context).colorScheme.onPrimary,
        )) 
        : ListView.builder(
          itemCount: _manga.length,
          itemBuilder: (context, index) {
            final mangaItem = _manga[index];
            return mangaCard(mangaItem);
          }
        )
    );
  }

  Container mangaCard(Manga mangaItem) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Container(
      margin: const EdgeInsets.only(top: 8, left: 8, right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: themeNotifier.themeMode == ThemeMode.light ? Colors.black.withAlpha(30) : Colors.transparent,
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          )
        ],
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(mangaItem.coverUrl, width: 100, height: 150, fit: BoxFit.cover)
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 134,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      mangaItem.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 8),
                    Expanded(
                      child: Text(
                        mangaItem.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSecondary.withAlpha(100),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: mangaItem.tags.map((tag) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 2.0),
                            child: Container(
                              padding: EdgeInsets.only(left: 4, top: 2, right: 4, bottom: 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Theme.of(context).colorScheme.tertiary.withAlpha(160),
                              ),
                              child: Text(
                                tag,
                                style: TextStyle(color: Theme.of(context).colorScheme.onTertiary),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  AppBar appBarMethod() {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return AppBar(
        centerTitle: true,
        elevation: 8.0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Theme.of(context).colorScheme.primary,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: themeNotifier.themeMode == ThemeMode.dark ? Color(0xff1f1f1f) : Colors.white,
          statusBarIconBrightness: themeNotifier.themeMode == ThemeMode.dark ? Brightness.light : Brightness.dark,
        ),
        leading: leadingWidget(),
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
      );
  }

  
  IconButton leadingWidget() {
    return IconButton(
      onPressed: _changeSource,
      icon: SvgPicture.asset(_sources[_selectedSource][1], height: 24.0, width: 24.0),
    );
  }

}