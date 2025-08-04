import 'package:flutter/material.dart';
import 'package:neko_dex/controllers/mangadex_controller.dart';
import 'package:neko_dex/models/manga_model.dart';
import 'package:neko_dex/theme/theme_motifier.dart';
import 'package:neko_dex/utils/capitalize_first_letter.dart';
import 'package:neko_dex/widgets/app_bar.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Manga> _manga = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchManga(MangadexController(), '');
  }

  Future<void> fetchManga(MangaProvider controller, String searchQuery) async {
    setState(() {_isLoading = true;});
    try{
      final result = await controller.searchManga(searchQuery);
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
      appBar: MyAppBar(fetchManga: fetchManga),
      body: _isLoading 
        ? Center(child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Theme.of(context).colorScheme.onPrimary,
        )) 
        : Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: ListView.builder(
            itemCount: _manga.length,
            itemBuilder: (context, index) {
              final mangaItem = _manga[index];
              return mangaCard(mangaItem);
            }
          ),
        )
    );
  }

  Container mangaCard(Manga mangaItem) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final statusColor = parseMangaStatus(mangaItem.status);

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
            child: Stack(
              children: [
                Image.network(
                  mangaItem.coverUrl,
                  width: 100,
                  height: 150,
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child; // картинка загрузилась
                    return Container(
                      width: 100,
                      height: 150,
                      color: Theme.of(context).colorScheme.primary,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.onPrimary,
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: statusColor.color.withAlpha(200),
                    ),
                    child: Text(
                      capitalizeFirstLetter(mangaItem.status),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onTertiary,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  )
                )
              ]
            )
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
        children: mangaItem.tags.map((tag) {
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
        }).toList(),
      ),
    );
  }
}