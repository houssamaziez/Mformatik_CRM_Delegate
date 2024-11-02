import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'Util/Theme/theme_light.dart';
import 'Util/localizations/localizations.dart';
import 'View/splashScreen/splash_screen.dart';

void main() async {
  await GetStorage.init(); // Initialize GetStorage
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Load the stored locale or use the default
    final GetStorage storage = GetStorage();
    String? storedLanguage = storage.read<String>('selected_language');
    Locale initialLocale =
        storedLanguage != null ? Locale(storedLanguage) : const Locale('en');

    return GetMaterialApp(
      title: 'CRM Delegate',
      theme: themeLight,

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
      home: const SpalshScreen(),
    );
  }
}
