import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:neko_dex/models/manga_model.dart';
import 'package:neko_dex/utils/capitalize_first_letter.dart';
import 'package:neko_dex/widgets/build_scrolling_title.dart';
import 'package:neko_dex/widgets/link_button.dart';

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
              child: buildScrollingTitle(manga.title, TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold), 290, context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  backgroundCoverArt(context),
                  Positioned(
                    bottom: 30,
                    left: 10,
                    right: 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 160,
                          height: 230,
                          child: coverArtHero(statusColor, context)
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                mangaInfoRow(context, 'Source: ', Row(children: [
                                  SvgPicture.asset(manga.source.iconPath, height: 20.0, width: 20.0),
                                  SizedBox(width: 8),
                                  Text(manga.source.name, style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold)),
                                  SizedBox(width: 4),
                                  OpenLinkButton(url: manga.sourceUrl)
                                ],)),
                                mangaInfoRow(context, 'Status: ', Row(
                                  children: [
                                  Icon(
                                    Icons.circle_rounded,
                                    size: 10,
                                    color: statusColor.color
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    capitalizeFirstLetter(manga.status),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context).colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  ]
                                )
                                ),
                                mangaInfoRow(context, 'Year: ', Text(manga.year.toString(), style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold))),
                                mangaInfoRow(context, 'Rating: ', Padding(padding: const EdgeInsets.only(right: 2.0),
                                  child: Container(
                                    padding: EdgeInsets.only(left: 4, top: 4, right: 4, bottom: 4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: manga.contentRating.color.withAlpha(220),
                                    ),
                                    child: RichText(
                                      text: TextSpan(
                                      text: manga.contentRating.displayName.text,
                                      style: TextStyle(color: Theme.of(context).colorScheme.onTertiary),
                                      )
                                    ),
                                  )
                                )),
                                mangaInfoRow(context, 'Score: ', Container(padding: EdgeInsets.only(left: 2, top: 1, right: 4, bottom: 1),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Theme.of(context).colorScheme.primary.withAlpha(200),
                                  ),
                                  child: Row(children: [
                                      Icon(Icons.star_outline_rounded, color: Theme.of(context).colorScheme.onPrimary, size: 20),
                                      Text(manga.score.toStringAsFixed(2), style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold))
                                    ]
                                  ),
                                )),
                                mangaInfoRow(context, 'Last chapter: ', Text(
                                  manga.lastChapter,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context).colorScheme.onPrimary,
                                    fontWeight: FontWeight.bold
                                    )
                                  )
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  )
                ]
              )
            )
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12))
                  ),
                  child: tagList(context, manga.tags),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(manga.description, style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSecondary,)),
                ),
              ],
            ),
          )
        ]
      )
    );
  }

  Row mangaInfoRow(BuildContext context, String title, Widget info) {
    return Row(children: [
      Text(
        title,
        style: TextStyle(
          fontSize: 18,
          color: Theme.of(context).colorScheme.onSecondary,
          fontWeight: FontWeight.bold
        ),
      ),
      SizedBox(width: 4),
      info
    ],);
  }

  Stack backgroundCoverArt(BuildContext context) {
    return Stack(
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
    );
  }

  Widget coverArtHero(MangaStatus statusColor, BuildContext context, {double? width, double? height}) {
    return Hero(
      tag: manga.id,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: manga.coverUrl,
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
            // Positioned(
            //   bottom: 0,
            //   right: 0,
            //   left: 0,
            //   child: Container(
            //     decoration: BoxDecoration(
            //       color: statusColor.color.withAlpha(200),
            //     ),
            //     child: Material(
            //       color: Colors.transparent,
            //       child: Text(
            //         capitalizeFirstLetter(manga.status),
            //         textAlign: TextAlign.center,
            //         style: TextStyle(
            //           fontSize: 12,
            //           color: Theme.of(context).colorScheme.onTertiary,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
 
  SingleChildScrollView tagList(BuildContext context, List<String> tags) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(top: 4, bottom: 4, left: 4),
      child: Row(
        children: [
          ...tags.map((tag) {
            return Padding(
              padding: const EdgeInsets.only(right: 2.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                child: Text(
                  tag,
                  style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                ),
              ),
            );
          })
        ],
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