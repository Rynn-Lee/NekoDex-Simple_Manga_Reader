import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';
import '../models/manga_model.dart';

class MangadexController extends MangaProvider {
  static String baseUrl = 'https://api.mangadex.org';
  static String coversUrl = 'https://uploads.mangadex.org';
  
  @override
  Future<List<Manga>> searchManga(String title, int page) async {
    final parseURL = Uri.parse('$baseUrl/manga?title=$title&includes[]=cover_art&limit=10&offset=${page * 10}');
    final response = await http.get(parseURL);
    if (response.statusCode != 200) throw Exception('Failed to load manga');
    return await compute(_parseMangaList, response.body);
  }
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


List<Manga> _parseMangaList (String body) {
  final json = jsonDecode(body);
  final List data = json['data'];

  return data.map((manga) {
    final attributes = manga['attributes'] as Map<String, dynamic>;
    final String title = getPreferredTitle(attributes);
    final String description = getPreferredDescription(attributes);
    final String id = manga['id'];
    final relationships = manga['relationships'];
    
    final coverArt = relationships.firstWhere(
      (relationship) => relationship['type'] == 'cover_art',
      orElse: () => null
    )?['attributes']?['fileName'];

    final altTitles = (attributes['altTitles'] as List)
        .map((title) => title.values.first.toString())
        .toList();

    final tags = (attributes['tags'] as List)
        .map((tag) => tag['attributes']['name']['en'].toString())
        .toList();

    return Manga(
      source: Source(controller: MangadexController(), name: 'Mangadex', iconPath: 'lib/assets/icons/mangadex-logo.svg'),
      sourceUrl: 'https://mangadex.org/title/$id',
      contentRating: ContentRating.fromApi(attributes['contentRating']),
      id: manga['id'],
      title: title,
      description: description.split("\n").first,
      altTitles: altTitles,
      tags: tags,
      lastChapter: (attributes['lastChapter'] ?? '').isNotEmpty ? attributes['lastChapter'] : 'N/A',
      status: attributes['status'],
      year: (attributes['year'].toString()).isNotEmpty ? attributes['year'].toString() : 'N/A',
      coverUrl: coverArt != null ? '${MangadexController.coversUrl}/covers/$id/$coverArt.256.jpg' : ''
    );
  }).toList();
}