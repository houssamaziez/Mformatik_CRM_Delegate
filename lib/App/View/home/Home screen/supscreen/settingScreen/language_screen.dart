import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  final GetStorage _storage = GetStorage(); // Initialize GetStorage
  String _selectedLanguage = 'en'; // Default language is English

  // List of supported languages
  final Map<String, String> _languages = {
    'en': 'English',
    'fr': 'Français',
    'ar': 'العربية',
  };

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage(); // Load the saved language on startup
  }

  void _loadSelectedLanguage() {
    final String? storedLanguage = _storage.read<String>('selected_language');
    if (storedLanguage != null) {
      setState(() {
        _selectedLanguage = storedLanguage;
      });
      Get.updateLocale(
          Locale(storedLanguage)); // Update locale based on stored value
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('select_language'.tr), // Translation key
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'select_language'.tr, // Translation key
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: _selectedLanguage,
              icon: const Icon(Icons.language),
              isExpanded: true,
              items: _languages.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLanguage = newValue!;
                });

                // Change the locale based on the selected language
                Get.updateLocale(Locale(_selectedLanguage));
                _storage.write('selected_language',
                    _selectedLanguage); // Save selected language
              },
            ),
          ],
        ),
      ),
    );
  }
}
