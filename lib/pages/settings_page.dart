import 'package:flutter/material.dart';
import 'package:neko_dex/stores/search_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late Map<String, bool> preferences;

  @override
  void initState() {
    super.initState();
    preferences = SearchPreferences.instance.uiPreferences;
  }

  Future<void> _togglePreference(String key, bool value) async {
    final next = Map<String, bool>.from(preferences);
    next[key] = value;

    final countTurnedOn = next.values.where((v) => v).length;
    if (countTurnedOn == 0) return;

    setState(() => preferences = next);
    await SearchPreferences.instance.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App settings'), centerTitle: true),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            margin: const EdgeInsets.fromLTRB(8, 8, 8, 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Text(
                  'Search preferences',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            minTileHeight: 48,
            leading: const Icon(
              Icons.circle_rounded,
              color: Colors.green,
              size: 20,
            ),
            title: Text(
              'Show SAFE results',
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
            trailing: Switch(
              activeColor: Colors.green,
              value: preferences['showSafe'] ?? true,
              onChanged: (v) => _togglePreference('showSafe', v),
            ),
          ),
          ListTile(
            minTileHeight: 48,
            leading: const Icon(
              Icons.circle_rounded,
              color: Colors.orange,
              size: 20,
            ),
            title: Text(
              'Show SUGGESTIVE results',
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
            trailing: Switch(
              activeColor: Colors.orange,
              value: preferences['showSuggestive'] ?? true,
              onChanged: (v) => _togglePreference('showSuggestive', v),
            ),
          ),
          ListTile(
            minTileHeight: 48,
            leading: const Icon(
              Icons.circle_rounded,
              color: Colors.pinkAccent,
              size: 20,
            ),
            title: Text(
              'Show EROTICA results',
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
            trailing: Switch(
              activeColor: Colors.pinkAccent,
              value: preferences['showErotica'] ?? false,
              onChanged: (v) => _togglePreference('showErotica', v),
            ),
          ),
          ListTile(
            minTileHeight: 48,
            leading: const Icon(
              Icons.circle_rounded,
              color: Colors.red,
              size: 20,
            ),
            title: Text(
              'Show NSFW results',
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
            trailing: Switch(
              activeColor: Colors.red,
              value: preferences['showNsfw'] ?? false,
              onChanged: (v) => _togglePreference('showNsfw', v),
            ),
          ),
        ],
      ),
    );
  }
}
