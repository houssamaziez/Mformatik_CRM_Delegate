import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'Util/Theme/theme_light.dart';
import 'Util/localizations/localizations.dart';
import 'View/auth/screen_auth.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Multi-Language App',
      theme: themeLight,

      translations: Messages(), // your translations
      locale: Locale('en'), // default locale
      fallbackLocale:
          Locale('en'), // fallback if the selected language is not available
      supportedLocales: [
        Locale('en', ''), // English
        Locale('fr', ''), // French
        Locale('ar', ''), // Arabiclocalizations
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: ScreenAuth(),
    );
  }
}
