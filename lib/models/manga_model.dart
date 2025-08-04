import 'package:flutter/material.dart';

class Manga {
  final String id;
  final String title;
  final String description;
  final List<String> altTitles;
  final String status;
  final int? year;
  final List<String> tags;
  final String coverUrl;

  Manga({
    required this.title,
    required this.id,
    required this.description,
    required this.status,
    required this.altTitles,
    required this.tags,
    required this.coverUrl,
    required this.year
  });
}

abstract class MangaProvider {
  Future<List<Manga>> searchManga(String title);
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
