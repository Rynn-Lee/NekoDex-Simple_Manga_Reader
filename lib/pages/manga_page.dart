import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:neko_dex/models/manga_model.dart';
import 'package:neko_dex/utils/capitalize_first_letter.dart';
import 'package:marquee/marquee.dart';
import 'package:neko_dex/widgets/build_scrolling_title.dart';

class MangaPage extends StatelessWidget {
  final Manga manga;
  const MangaPage({super.key, required this.manga});

  @override
  Widget build(BuildContext context) {
    final statusColor = parseMangaStatus(manga.status);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            title: SizedBox(
              height: 26,
              child: buildScrollingTitle(manga.title, const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold), 200),
              // Marquee(
              //   text: manga.title,
              //   style: const TextStyle(
              //     fontSize: 20,
              //     color: Colors.white,
              //     fontWeight: FontWeight.bold
              //   ),
              //   scrollAxis: Axis.horizontal,
              //   blankSpace: 130.0,
              //   velocity: 30.0,
              //   pauseAfterRound: Duration(seconds: 1),
              //   startPadding: 10.0,
              //   accelerationDuration: Duration(seconds: 1),
              //   accelerationCurve: Curves.linear,
              //   decelerationDuration: Duration(milliseconds: 500),
              //   decelerationCurve: Curves.easeOut,
              // )
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Stack(
                    fit: StackFit.expand,
                    children: [
                      ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                        child: CachedNetworkImage(
                          imageUrl: manga.coverUrl,
                          memCacheHeight: 256,
                          memCacheWidth: 190,
                          width: 200,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                          width: 100,
                          height: 150,
                          color: Theme.of(context).colorScheme.primary,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 100,
                          height: 150,
                          color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Theme.of(context).colorScheme.primary.withAlpha(110),
                              Theme.of(context).colorScheme.primary.withAlpha(220),
                            ],
                          ),
                        ),
                      ),
                    ],
                    ),
                  Positioned(
                    bottom: 30,
                    left: 10,
                    right: 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        coverArtHero(statusColor, context),
                      ],
                    )
                  )
                ]
              )
            )
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(manga.description),
            ),
          )
        ]
      )
    );
  }

  Hero coverArtHero(MangaStatus statusColor, BuildContext context) {
    return Hero(
      tag: manga.id,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: manga.coverUrl,
              memCacheHeight: 256,
              memCacheWidth: 190,
              width: 160,
              fit: BoxFit.fill,
              placeholder: (context, url) => Container(
                width: 100,
                height: 150,
                color: Theme.of(context).colorScheme.primary,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                width: 100,
                height: 150,
                color: Theme.of(context).colorScheme.primary,
                child: Icon(
                  Icons.broken_image,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
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
                    capitalizeFirstLetter(manga.status),
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
}



// Row(
//   mainAxisAlignment: MainAxisAlignment.center,
//   children: manga.tags.map((tag) => Padding(
//     padding: const EdgeInsets.only(right: 4.0),
//     child: Container(
//       padding: EdgeInsets.only(left: 4, top: 2, right: 4, bottom: 2),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(4),
//         color: Theme.of(context).colorScheme.tertiary.withAlpha(180),
//       ),
//       child: Text(
//         tag,
//         style: TextStyle(color: Theme.of(context).colorScheme.onTertiary),
//       ),
//     ),
//   )).toList(),
// )