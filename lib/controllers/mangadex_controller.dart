import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:neko_dex/stores/search_preferences.dart';
import 'dart:convert';
import '../models/manga_model.dart';

class MangadexController extends MangaProvider {
  static String baseUrl = 'https://api.mangadex.org';
  static String coversUrl = 'https://uploads.mangadex.org';

  @override
  Future<List<Manga>> searchManga(String title, int page) async {
    final ratings = SearchPreferences.instance.selectedContentRatings;

    final queryParams = <String, dynamic>{
      'title': title,
      'includes[]': ['cover_art', 'author'],
      'limit': '10',
      'offset': '${page * 10}',
      'contentRating[]': ratings,
    };

    final uri = Uri.https(
      baseUrl.replaceAll('https://', ''),
      '/manga',
      queryParams,
    );

    final response = await http.get(uri);
    if (response.statusCode != 200) throw Exception('Failed to load manga');
    return await compute(_parseMangaList, response.body);
  }

  @override
  Widget searchProviderPreferences() => const Text('');
}

String getPreferredTitle(Map<String, dynamic> attributes) {
  final titleMap = attributes['title'] as Map<String, dynamic>? ?? {};
  if (titleMap.containsKey('en')) return titleMap['en'];
  if (titleMap.containsKey('ja')) return titleMap['ja'];
  if (titleMap.isNotEmpty) return titleMap.values.first;

  final altTitles = attributes['altTitles'] as List<dynamic>? ?? [];
  for (var item in altTitles) {
    if (item is Map<String, dynamic> && item.containsKey('en')) {
      return item['en'];
    }
  }
  for (var item in altTitles) {
    if (item is Map<String, dynamic> && item.containsKey('ja')) {
      return item['ja'];
    }
  }
  if (altTitles.isNotEmpty && altTitles.first is Map<String, dynamic>) {
    return (altTitles.first as Map<String, dynamic>).values.first;
  }

  return 'No title';
}

String getPreferredDescription(Map<String, dynamic> attributes) {
  final descMap = attributes['description'] as Map<String, dynamic>? ?? {};
  if (descMap.containsKey('en')) return descMap['en'];
  if (descMap.containsKey('ja')) return descMap['ja'];
  if (descMap.isNotEmpty) return descMap.values.first;

  return 'No description';
}

Future<double> parseMangaScore(String id) async {
  final Uri parseURL = Uri.parse(
    '${MangadexController.baseUrl}/statistics/manga/$id',
  );
  final response = await http.get(parseURL);
  if (response.statusCode != 200) throw Exception('Failed to load manga');
  return jsonDecode(response.body)['statistics'][id]['rating']['bayesian'];
}

Future<List<Manga>> _parseMangaList(String body) async {
  final json = jsonDecode(body);
  final List data = json['data'];

  final mangas = await Future.wait(
    data.map((manga) async {
      final attributes = manga['attributes'] as Map<String, dynamic>;
      final String title = getPreferredTitle(attributes);
      final String description = getPreferredDescription(attributes);
      final String id = manga['id'];
      final relationships = manga['relationships'];
      final score = await parseMangaScore(id);
      final altTitles = (attributes['altTitles'] as List).cast<Map<String, dynamic>>();

      final coverArt = relationships.firstWhere(
        (relationship) => relationship['type'] == 'cover_art',
        orElse: () => null,
      )?['attributes']?['fileName'];

      final author = relationships.firstWhere(
        (relationship) => relationship['type'] == 'author',
        orElse: () => null,
      )?['attributes']?['name'];


      final tags = (attributes['tags'] as List)
          .map((tag) => tag['attributes']['name']['en'].toString())
          .toList();

      return Manga(
        source: Source(
          controller: MangadexController(),
          name: 'Mangadex',
          iconPath: 'lib/assets/icons/mangadex-logo.svg',
        ),
        sourceUrl: 'https://mangadex.org/title/$id',
        contentRating: ContentRating.fromApi(attributes['contentRating']),
        id: manga['id'],
        title: title,
        description: description,
        score: score,
        altTitles: altTitles,
        tags: tags,
        author: author,
        lastChapter: (attributes['lastChapter'] ?? '').isNotEmpty
            ? attributes['lastChapter']
            : 'N/A',
        status: attributes['status'],
        year:
            (attributes['year'] != null &&
                attributes['year'].toString().isNotEmpty)
            ? attributes['year'].toString()
            : 'N/A',
        coverUrl: coverArt != null
            ? '${MangadexController.coversUrl}/covers/$id/$coverArt.256.jpg'
            : '',
      );
    }).toList(),
  );
  return mangas;
}
