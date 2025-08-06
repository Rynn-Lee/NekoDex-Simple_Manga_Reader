import 'package:flutter/material.dart';

class Source {
  final String name;
  final String iconPath;
  final MangaProvider controller;

  Source({
    required this.name,
    required this.iconPath,
    required this.controller
  });
}

class Manga {
  final String id;
  final String sourceUrl;
  final String title;
  final String description;
  final List<String> altTitles;
  final String status;
  final String year;
  final List<String> tags;
  final String coverUrl;
  final Source source;
  final String lastChapter;
  final ContentRating contentRating;

  Manga({
    required this.id,
    required this.sourceUrl,
    required this.title,
    required this.description,
    required this.altTitles,
    required this.status,
    required this.year,
    required this.tags,
    required this.coverUrl,
    required this.source,
    required this.lastChapter,
    required this.contentRating
  });
}

abstract class MangaProvider {
  Future<List<Manga>> searchManga(String title, int page);
}

enum ContentRating {
  safe,
  suggestive,
  erotica,
  pornographic;

  static ContentRating fromApi(String rating) {
    switch (rating.toLowerCase()) {
      case 'safe':
        return ContentRating.safe;
      case 'suggestive':
        return ContentRating.suggestive;
      case 'erotica':
        return ContentRating.erotica;
      case 'pornographic':
        return ContentRating.pornographic;
      default:
        return ContentRating.safe;
    }
  }

  TextSpan get displayName  {
    switch (this) {
      case ContentRating.safe:
        return TextSpan(text: 'Safe', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold));
      case ContentRating.suggestive:
        return TextSpan(text: 'Suggestive', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold));
      case ContentRating.erotica:
        return TextSpan(text: 'Erotica', style: TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.bold));
      case ContentRating.pornographic:
        return TextSpan(text: 'Pornographic', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold));
    }
  }

  Color get color {
    switch (this) {
      case ContentRating.safe:
        return Colors.green;
      case ContentRating.suggestive:
        return Colors.orange;
      case ContentRating.erotica:
        return Colors.pinkAccent;
      case ContentRating.pornographic:
        return Colors.red;
    }
  }
}

enum MangaStatus {
  ongoing,
  completed,
  hiatus,
  cancelled,
  unknown, // fallback
}

extension MangaStatusColor on MangaStatus {
  Color get color {
    switch (this) {
      case MangaStatus.ongoing:
        return Colors.green;
      case MangaStatus.completed:
        return Colors.blue;
      case MangaStatus.hiatus:
        return Colors.orange;
      case MangaStatus.cancelled:
        return Colors.red;
      case MangaStatus.unknown:
        return Colors.grey;
    }
  }
}

MangaStatus parseMangaStatus(String status) {
  switch (status.toLowerCase()) {
    case 'ongoing':
      return MangaStatus.ongoing;
    case 'completed':
      return MangaStatus.completed;
    case 'hiatus':
      return MangaStatus.hiatus;
    case 'cancelled':
      return MangaStatus.cancelled;
    default:
      return MangaStatus.unknown;
  }
}
