import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neko_dex/app_home.dart';
import 'package:neko_dex/models/manga_model.dart';
import 'package:neko_dex/pages/mangaProviderSettings.dart';
import 'package:neko_dex/pages/manga_page.dart';
import 'package:neko_dex/pages/settings_page.dart';
import 'package:neko_dex/stores/search_preferences.dart';
import 'package:neko_dex/theme/theme_motifier.dart';
import 'package:neko_dex/theme/themes.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SearchPreferences.instance.init();
  runApp(
    ChangeNotifierProvider(create: (_) => ThemeNotifier(), child: NekoDex()),
  );
}

class NekoDex extends StatefulWidget {
  const NekoDex({super.key});

  @override
  State<NekoDex> createState() => _NekoDexState();
}

class _NekoDexState extends State<NekoDex> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: themeNotifier.themeMode == ThemeMode.dark
            ? Color(0xff1f1f1f)
            : Colors.white,
        statusBarColor: themeNotifier.themeMode == ThemeMode.dark
            ? Color(0xff1f1f1f)
            : Colors.white,
        statusBarIconBrightness: themeNotifier.themeMode == ThemeMode.dark
            ? Brightness.light
            : Brightness.dark,
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "NekoDex",
        theme: myLightTheme,
        darkTheme: myDarkTheme,
        themeMode: themeNotifier.themeMode,
        routes: {
          '/': (context) => AppHome(),
          '/settings': (context) => SettingsPage(),
          '/mangaProviderSettings': (context) {
            final Widget child = ModalRoute.of(context)!.settings.arguments as Widget;
            return MangaProviderSettingsPage(child: child);
          },
          '/manga': (context) {
            final Manga manga = ModalRoute.of(context)!.settings.arguments as Manga;
            return MangaPage(manga: manga);
          },
        },
      ),
    );
  }
}
