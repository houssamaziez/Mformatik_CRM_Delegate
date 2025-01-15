import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/Buttons/buttonall.dart';

import '../../../Service/notification_handler.dart';
import '../../../myapp.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  late String _selectedLanguage;

  // Supported languages with associated images
  final Map<String, Map<String, String>> _languages = {
    'fr': {'name': 'Français', 'image': 'assets/icons/fr.png'},
    'en': {'name': 'English', 'image': 'assets/icons/EN.png'},
    'ar': {'name': 'عربية', 'image': 'assets/icons/Flag-Saudi-Arabia.png'},
  };

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage();
  }

  void _loadSelectedLanguage() {
    final storedLanguage = storage.read<String>('selected_language');
    setState(() {
      _selectedLanguage = storedLanguage ?? 'en';
      Get.updateLocale(Locale(_selectedLanguage));
    });
  }

  void _onLanguageSelected(String language)async {
    setState(() {
      _selectedLanguage = language;
    });
    Get.updateLocale(Locale(language)); // Update the locale immediately
    storage.write(
        'selected_language', language); // Save the language selection
   CriNotificationService. flutterBgInstance.invoke( 'stopService');

//  await CriNotificationService.initializeService( isBackground: false , );

    CriNotificationService.flutterBgInstance.invoke('stopService');
                await Future.delayed(Duration(seconds: 2));
                await CriNotificationService.initializeService(isBackground: false);
                setState(() {});

                

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
            const SizedBox(height: 20),
            Text(
              'Choose your preferred language to make it easier for you to use the application'
                  .tr,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // List of languages with images
            ListView.builder(
              shrinkWrap: true,
              itemCount: _languages.length,
              itemBuilder: (context, index) {
                String languageCode = _languages.keys.elementAt(index);
                String languageName = _languages[languageCode]!['name']!;
                String imagePath = _languages[languageCode]!['image']!;
                bool isSelected = _selectedLanguage == languageCode;

                return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    child: ListTile(
                      onTap: () => _onLanguageSelected(languageCode),
                      leading: CircleAvatar(
                        backgroundImage:
                            AssetImage(imagePath), // Language flag icon
                      ),
                      title: Text(
                        languageName,
                        style: TextStyle(
                          color: isSelected ? Colors.blue : Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: Colors.blue)
                          : null,
                      tileColor:
                          isSelected ? Colors.blue.withOpacity(0.1) : null,
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: 150,
              child: ButtonAll(
                  color: Theme.of(context).primaryColor,
                  function: () {
                    Get.back();
                  },
                  title: 'Save'.tr),
            ),
            const Spacer(
              flex: 4,
            ),
          ],
        ),
      ),
    );
  }
}
