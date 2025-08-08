// lib/core/app_prefs.dart
import 'package:shared_preferences/shared_preferences.dart';

class SearchPreferences {
  SearchPreferences._();
  static final SearchPreferences instance = SearchPreferences._();

  static const _kShowSafe = 'showSafe';
  static const _kShowSuggestive = 'showSuggestive';
  static const _kShowErotica = 'showErotica';
  static const _kShowNsfw = 'showNsfw';

  static const Map<String, bool> _defaults = {
    _kShowSafe: true,
    _kShowSuggestive: true,
    _kShowErotica: false,
    _kShowNsfw: false,
  };

  late SharedPreferences _sp;

  Future<void> init() async {
    _sp = await SharedPreferences.getInstance();
  }

  bool getBool(String key) => _sp.getBool(key) ?? _defaults[key] ?? false;

  Future<void> setBool(String key, bool value) async {
    await _sp.setBool(key, value);
  }

  Map<String, bool> get uiPreferences => {
    _kShowSafe: getBool(_kShowSafe),
    _kShowSuggestive: getBool(_kShowSuggestive),
    _kShowErotica: getBool(_kShowErotica),
    _kShowNsfw: getBool(_kShowNsfw),
  };

  List<String> get selectedContentRatings {
    final map = {
      _kShowSafe: 'safe',
      _kShowSuggestive: 'suggestive',
      _kShowErotica: 'erotica',
      _kShowNsfw: 'pornographic',
    };
    final result = <String>[];
    map.forEach((k, v) {
      if (getBool(k)) result.add(v);
    });

    if (result.isEmpty) return ['safe'];
    return result;
  }
}
