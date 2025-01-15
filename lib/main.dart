import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'App/Service/notification_handler.dart';
import 'App/myapp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await GetStorage.init();
  await CriNotificationService.initializeService(isBackground: false);
  // initializeNotifications();
  runApp(const MyApp());
}
 