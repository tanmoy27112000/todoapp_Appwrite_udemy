import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/l10n/l10n.dart';
import 'package:todoapp/login/login.dart';
import 'package:todoapp/splash/view/splash_page.dart';
import 'package:todoapp/util/prefs.dart';

Client client = Client();
Prefs prefs = Prefs();

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    client
        .setEndpoint('http://localhost/v1')
        .setProject('63ac9d5112f3f07b7bb2')
        .setSelfSigned();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: const Color(0xFF13B9FF),
        ),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const SplashPage(),
    );
  }
}
