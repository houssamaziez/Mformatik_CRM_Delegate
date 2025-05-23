import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mformatic_crm_delegate/App/View/splashScreen/splash_screen.dart';

import 'Util/Theme/theme_light.dart';
import 'Util/localizations/localizations.dart';

final GetStorage storage = GetStorage();

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    String? storedLanguage = storage.read<String>('selected_language');
    Locale initialLocale =
        storedLanguage != null ? Locale(storedLanguage) : const Locale('en');
    return GetMaterialApp(
      title: 'CRM Report',
      theme: themeLight,
      debugShowCheckedModeBanner: false,
      translations: Messages(), // Your translations
      locale: initialLocale, // Load the stored locale
      fallbackLocale: const Locale('en'), // Fallback locale
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('fr', ''), // French
        Locale('ar', ''), // Arabic
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: SpalshScreen(),
    );
  }
}
