import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  final GetStorage _storage = GetStorage();
  late String _selectedLanguage;

  // Supported languages
  final Map<String, String> _languages = {
    'en': 'English',
    'fr': 'Français',
  };

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage();
  }

  void _loadSelectedLanguage() {
    final storedLanguage = _storage.read<String>('selected_language');
    setState(() {
      _selectedLanguage = storedLanguage ?? 'en';
      Get.updateLocale(Locale(_selectedLanguage));
    });
  }

  void _onLanguageSelected(String language) {
    setState(() {
      _selectedLanguage = language;
    });
    Get.updateLocale(Locale(language)); // Update the locale immediately
    _storage.write(
        'selected_language', language); // Save the language selection
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Language Selection'.tr),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            SizedBox(
              height: 60,
            ),
            Text(
              'Choose your preferred language to make it easier for you to use the application'
                  .tr,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _languages.entries.map((entry) {
                final bool isSelected = _selectedLanguage == entry.key;
                return GestureDetector(
                  onTap: () => _onLanguageSelected(entry.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.grey.shade300,
                        width: 2,
                      ),
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.2),
                            spreadRadius: 4,
                            blurRadius: 8,
                          ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        entry.value,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 40),
            // ElevatedButton(
            //   onPressed: () {
            //     Get.back();
            //   },
            //   style: ElevatedButton.styleFrom(
            //     padding:
            //         const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
            //     backgroundColor: Colors.teal,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //   ),
            //   child: Text(
            //     'save'.tr,
            //     style: const TextStyle(fontSize: 18),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
