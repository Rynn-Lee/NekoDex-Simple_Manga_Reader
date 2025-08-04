import 'package:flutter/material.dart';
import 'package:neko_dex/controllers/mangadex_controller.dart';
import 'package:neko_dex/models/manga_model.dart';
import 'package:neko_dex/theme/theme_motifier.dart';
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

  

}