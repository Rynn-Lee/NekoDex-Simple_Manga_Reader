import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/svg.dart';
import 'package:neko_dex/models/manga_model.dart';
import 'package:neko_dex/utils/capitalize_first_letter.dart';
import 'package:neko_dex/utils/get_flag.dart';
import 'package:neko_dex/widgets/build_scrolling_title.dart';
import 'package:neko_dex/widgets/link_button.dart';

class MangaPage extends StatefulWidget {
  final Manga manga;
  const MangaPage({super.key, required this.manga});

  @override
  State<MangaPage> createState() => _MangaPageState();
}

class _MangaPageState extends State<MangaPage> {
  int _selectedTab = 1;

  @override
  Widget build(BuildContext context) {
    final statusColor = parseMangaStatus(widget.manga.status);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 356,
            pinned: true,
            title: SizedBox(
              height: 26,
              child: buildScrollingTitle(widget.manga.title, TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold), 290, context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  backgroundCoverArt(context),
                  Positioned(
                    bottom: 20,
                    left: 10,
                    right: 10,
                    child: Column(
                      children: [
                        Row(
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
                                padding: const EdgeInsets.only(left: 14.0, top: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    mangaInfoRow(context, 'Source: ', Row(children: [
                                      SvgPicture.asset(widget.manga.source.iconPath, height: 20.0, width: 20.0),
                                      SizedBox(width: 8),
                                      Text(widget.manga.source.name, style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold)),
                                      SizedBox(width: 4),
                                      OpenLinkButton(url: widget.manga.sourceUrl)
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
                                        capitalizeFirstLetter(widget.manga.status),
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context).colorScheme.onPrimary,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      ]
                                    )
                                    ),
                                    mangaInfoRow(context, 'Year: ', Text(widget.manga.year.toString(), style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold))),
                                    mangaInfoRow(context, 'Rating: ', Padding(padding: const EdgeInsets.only(right: 2.0),
                                      child: Container(
                                        padding: EdgeInsets.only(left: 4, top: 4, right: 4, bottom: 4),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(4),
                                          color: widget.manga.contentRating.color.withAlpha(220),
                                        ),
                                        child: RichText(
                                          text: TextSpan(
                                          text: widget.manga.contentRating.displayName.text,
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
                                          Text(widget.manga.score.toStringAsFixed(2), style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold))
                                        ]
                                      ),
                                    )),
                                    mangaInfoRow(context, 'Last chapter: ', Text(
                                      widget.manga.lastChapter,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).colorScheme.onPrimary,
                                        fontWeight: FontWeight.bold
                                        )
                                      )
                                    ),
                                    mangaInfoRow(context, "Author: ", Expanded(child: Text(widget.manga.author, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold)))),
                                 ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        tagList(context, widget.manga.tags)
                      ],
                    )
                  )
                ]
              )
            )
          ),
          SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomSlidingSegmentedControl<int>(
                  fixedWidth: (MediaQuery.of(context).size.width / 3).floorToDouble()-1,
                  initialValue: _selectedTab,
                  children: {
                    1: Text('Description'),
                    2: Text('Chapters'),
                    3: Text('Comments'),
                  },
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(30),
                        spreadRadius: 0,
                        blurRadius: 2,
                        offset: const Offset(0, 3),
                      )
                    ],
                    color: Theme.of(context).colorScheme.secondary.withAlpha(255),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                  ),
                  thumbDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary.withAlpha(100),
                    border: Border.all(color: Theme.of(context).colorScheme.onSecondary.withAlpha(100)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  duration: Duration(milliseconds: 400),
                  curve: Curves.ease,
                  onValueChanged: (v) {
                    setState(()=> _selectedTab = v);
                  },
                ),
                if (_selectedTab == 1) moreInfo(context)
                else if (_selectedTab == 2) chapters(context)
                else if (_selectedTab == 3) chapters(context)
              ],
            ),
          )
        ]
      )
    );
  }

  Column moreInfo(BuildContext context) {
    return Column(
      children: [
       Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.only(top: 6.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary.withAlpha(255),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(30),
                spreadRadius: 0,
                blurRadius: 2,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Description", style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),),
              SizedBox(height: 12),
              Markdown(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                data: widget.manga.description,
                onTapLink: (value, url, title) => launchExternalUrl(url),
                styleSheet: MarkdownStyleSheet(
                  p: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontWeight: FontWeight.normal
                  ),
                ),
              ),
            ],
          ),
        ),
       Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.only(top: 6.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary.withAlpha(255),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withAlpha(30),
                  spreadRadius: 0,
                  blurRadius: 2,
                  offset: const Offset(0, 3),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Alternative titles", style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),),
              SizedBox(height: 12),
              Column(
                children: widget.manga.altTitles.map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(borderRadius: BorderRadius.circular(6), child: getFlag(item.keys.first)),
                        SizedBox(width: 10,),
                        Expanded(child: Text(item.values.first)),
                      ],
                    ),
                  );
                }).toList(),
              )
            ],
          ),
        ),
      ],
    );
  }

  Padding chapters(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text('chapters'),
    );
  }

  Row mangaInfoRow(BuildContext context, String title, Widget info) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
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
          imageUrl: widget.manga.coverUrl,
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
      tag: widget.manga.id,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: widget.manga.coverUrl,
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
          ],
        ),
      ),
    );
  }

  Container tagList(BuildContext context, List<String> tags) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
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
      ),
    );
  }
}