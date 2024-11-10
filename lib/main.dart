import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'App/View/splashScreen/splash_screen.dart';
import 'App/myapp.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await GetStorage.init();

  print(spalshscreenfirst.read('key'));
  runApp(const MyApp());
}
