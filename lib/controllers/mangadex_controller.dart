import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/manga_model.dart';

class MangadexController extends MangaProvider {
  static String baseUrl = 'https://api.mangadex.org';
  static String coversUrl = 'https://uploads.mangadex.org';
  
  @override
  Future<List<Manga>> searchManga(String title) async {
    final response = await http.get(Uri.parse('$baseUrl/manga?title=$title&includes[]=cover_art'));
    if (response.statusCode != 200) throw Exception('Failed to load manga');

    final json = jsonDecode(response.body);
    final List data = json['data'];

    return data.map((manga) => _mapToManga(manga)).toList();
  }

  Manga _mapToManga (Map<String, dynamic> json) {
    final attributes = json['attributes'];
    final String title = attributes['title']['en'] ?? "No title";
    final String id = json['id'];
    final String description = attributes['description']['en'] ?? "No description";
    final relationships = json['relationships'];
    final coverUrl = relationships.firstWhere((relationship) => relationship['type'] == 'cover_art', orElse: () => null)['attributes']['fileName'];

    final altTitles = (attributes['altTitles'] as List).map((title) => title.values.first.toString()).toList();
    final tags = (attributes['tags'] as List).map((tag) => tag['attributes']['name']['en'].toString()).toList();
    return Manga(
      id: json['id'],
      title: title,
      description: description.split("\n").first,
      altTitles: altTitles,
      tags: tags,
      status: attributes['status'],
      year: attributes['year'],
      coverUrl: '$coversUrl/covers/$id/$coverUrl.256.jpg'
    );
  }
}