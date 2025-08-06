import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:neko_dex/controllers/mangadex_controller.dart';
import 'package:neko_dex/models/manga_model.dart';
import 'package:neko_dex/theme/theme_motifier.dart';
// import 'package:neko_dex/theme/theme_motifier.dart';
import 'package:neko_dex/utils/capitalize_first_letter.dart';
import 'package:neko_dex/widgets/app_bar.dart';
// import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  late List<Manga> _manga = [];
  String _searchQuery = '';
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _endOfList = false;
  int page = 0;

  @override
  void initState() {
    super.initState();
    fetchManga(MangadexController(), _searchQuery);

    _scrollController.addListener(() {
      if (page == 0 ? (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) : (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 700) && !_endOfList) {
        addManga(MangadexController(), _searchQuery);
      }
    });
  }

  Future<void> fetchManga(MangaProvider controller, String searchQuery) async {
    setState(() {
      _isLoading = true;
      page = 0;
      _endOfList = false;
    });
    try{
      final result = await controller.searchManga(searchQuery, page);
      setState(() {
        _searchQuery = searchQuery;
        _manga = result;
        _isLoading = false;
      });
    } catch (error) {
      setState(() => _isLoading = false);
      throw Exception('Failed to fetch manga: $error');
    }
  }

  Future<void> addManga(MangaProvider controller, String searchQuery) async {
    if(_isLoadingMore || _endOfList) return;
    setState(() =>  _isLoadingMore = true);
    try{
      page++;
      final result = await controller.searchManga(searchQuery, page);
      if(result.length < 10) _endOfList = true;
      
      final existingIds = _manga.map((m) => m.id).toSet();
      final newItems = result.where((m) => !existingIds.contains(m.id)).toList();

      setState(() {
        _manga.addAll(newItems);
        _isLoadingMore = false;
      });
    } catch (error) {
      setState(() => _isLoadingMore = false);
      throw Exception('Failed to fetch manga: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: MyAppBar(fetchManga: fetchManga),
      
      body: _isLoading 
        ? Center(child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Theme.of(context).colorScheme.onPrimary,
        )) 
        : Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Stack(
            children: [
              ListView.builder(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                addAutomaticKeepAlives: false,
                addRepaintBoundaries: false,
                itemExtent: 160,
                cacheExtent: 300,
                itemCount: _manga.length,
                itemBuilder: (context, index) {
                  final mangaItem = _manga[index];
                  return mangaCard(mangaItem);
                }
              ),
              AnimatedPositioned(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
                width: MediaQuery.of(context).size.width,
                bottom: _isLoadingMore ? 100 : -60, // прячем ниже экрана
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withAlpha(150),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: CircularProgressIndicator(color: Theme.of(context).colorScheme.onPrimary,padding: EdgeInsets.all(10),),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]
          ),
        )
    );
  }

  GestureDetector mangaCard(Manga mangaItem) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final statusColor = parseMangaStatus(mangaItem.status);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/manga', arguments: mangaItem),
      child: Container(
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
            SizedBox(
              width: 105,
              height: 210,
              child: coverArtHero(mangaItem, statusColor)
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
                      title(statusColor, mangaItem),
                      description(mangaItem),
                      tagList(mangaItem),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Hero coverArtHero(Manga mangaItem, MangaStatus statusColor) {
    return Hero(
      tag: mangaItem.id,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            // Адаптивный размер через Positioned.fill
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: mangaItem.coverUrl,
                fit: BoxFit.cover,
                memCacheHeight: 256,
                memCacheWidth: 190,
                placeholder: (context, url) => Container(
                  color: Theme.of(context).colorScheme.primary,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Theme.of(context).colorScheme.primary,
                  child: Icon(
                    Icons.broken_image,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
            // Полоса с текстом внизу
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: statusColor.color.withAlpha(200),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    capitalizeFirstLetter(mangaItem.status),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onTertiary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row title(MangaStatus statusColor, Manga mangaItem) {
    return Row(children: [
      Icon(
        Icons.circle_rounded,
        size: 10,
        color: statusColor.color
      ),
      SizedBox(width: 4),
      Expanded(
        child: Text(
          mangaItem.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).colorScheme.onSecondary,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      ]
    ,);
  }

  Expanded description(Manga mangaItem) {
    return Expanded(
      child: Text(
        mangaItem.description,
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).colorScheme.onSecondary.withAlpha(100),
        ),
      ),
    );
  }

  SingleChildScrollView tagList(Manga mangaItem) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 2.0),
            child: Container(
              padding: EdgeInsets.only(left: 4, top: 4, right: 4, bottom: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: mangaItem.contentRating.color.withAlpha(180),
              ),
              child: RichText(
                text: TextSpan(
                text: mangaItem.contentRating.displayName.text,
                style: TextStyle(color: Theme.of(context).colorScheme.onTertiary),
                )
              ),
            )
          ),
          ...mangaItem.tags.map((tag) {
            return Padding(
              padding: const EdgeInsets.only(right: 2.0),
              child: Container(
                padding: EdgeInsets.only(left: 4, top: 2, right: 4, bottom: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Theme.of(context).colorScheme.tertiary.withAlpha(180),
                ),
                child: Text(
                  tag,
                  style: TextStyle(color: Theme.of(context).colorScheme.onTertiary),
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}