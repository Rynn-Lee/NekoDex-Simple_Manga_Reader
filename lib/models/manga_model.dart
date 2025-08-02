class Manga {
  final String id;
  final String title;
  final String description;
  final List<String> altTitles;
  final String? status;
  final List<String> tags;
  final String coverUrl;

  Manga({
    required this.title,
    required this.id,
    required this.description,
    required this.status,
    required this.altTitles,
    required this.tags,
    required this.coverUrl
  });
}

abstract class MangaProvider {
  Future<List<Manga>> searchManga(String title);
}