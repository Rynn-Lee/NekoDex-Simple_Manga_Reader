import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Map<String, bool> preferences = {
    'showSafe': true,
    'showSuggestive': true,
    'showErotica': false,
    'showNsfw': false
  };

  void _togglePreference(String key, bool value) {
    int countTurnedOn = preferences.values.where((item) => item == true).length;
    if(countTurnedOn == 1 && value == false) return;
    setState(() {
      preferences[key] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App settings'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10, top: 8, right: 10, bottom: 8),
            margin: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.search_rounded, color: Theme.of(context).colorScheme.onPrimary, size: 24,),
                SizedBox(width: 10,),
                Text('Search preferences', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 18),)
              ],
            )
          ),
          ListTile(
            minTileHeight: 48,
            leading: Icon(Icons.circle_rounded, color: Colors.green, size: 20,),
            title: Text('Show SAFE results', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
            trailing: Switch(
              activeColor: Colors.green,
              value: preferences['showSafe']!,
              onChanged: (value) => _togglePreference('showSafe', value),
            ),
          ),
          ListTile(
            minTileHeight: 48,
            leading: Icon(Icons.circle_rounded, color: Colors.orange, size: 20,),
            title: Text('Show SUGGESTIVE results', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
            trailing: Switch(
              activeColor: Colors.orange,
              value: preferences['showSuggestive']!,
              onChanged: (value) => _togglePreference('showSuggestive', value),
            ),
          ),
          ListTile(
            minTileHeight: 48,
            leading: Icon(Icons.circle_rounded, color: Colors.pinkAccent, size: 20,),
            title: Text('Show EROTICA results', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
            trailing: Switch(
              activeColor: Colors.pinkAccent,
              value: preferences['showErotica']!,
              onChanged: (value) => _togglePreference('showErotica', value),
            ),
          ),
          ListTile(
            minTileHeight: 48,
            leading: Icon(Icons.circle_rounded, color: Colors.red, size: 20,),
            title: Text('Show NSFW results', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
            trailing: Switch(
              activeColor: Colors.red,
              value: preferences['showNsfw']!,
              onChanged: (value) => _togglePreference('showNsfw', value),
            ),
          ),
        ],
      ),
    );
  }
}