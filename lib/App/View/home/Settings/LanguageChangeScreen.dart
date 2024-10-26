import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../widgets/app_bar.dart';

class LanguageChangeScreen extends StatelessWidget {
  const LanguageChangeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final currentLocale = box.read('locale') ?? 'ar';

    return Scaffold(
      appBar: appbarblue(context, title: 'اختيار اللغة'.tr),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          ListTile(
            title: const Text('English'),
            trailing: currentLocale == 'en'
                ? const Icon(Icons.check, color: Colors.green)
                : null,
            onTap: () {
              _changeLanguage('en');
            },
          ),
          ListTile(
            title: const Text('عربي'),
            trailing: currentLocale == 'ar'
                ? const Icon(Icons.check, color: Colors.green)
                : null,
            onTap: () {
              _changeLanguage('ar');
            },
          ),
          // يمكنك إضافة لغات أخرى هنا
        ],
      ),
    );
  }

  void _changeLanguage(String langCode) {
    Get.updateLocale(Locale(langCode));
    GetStorage().write('locale', langCode);
  }
}
