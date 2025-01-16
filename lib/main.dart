import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'App/Service/get_app_ersion.dart';
import 'App/View/home/Settings/screenSetting.dart';
import 'App/myapp.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await GetStorage.init();
  var f=storage.read<bool> ('isNotification' ); 
  if (storage.read<bool> ('isNotification' ) == null) {
    storage.write('isNotification', false);
 }
  // await CriNotificationService.initializeService(isBackground: false);

appVersion = await getAppVersion();
  // initializeNotifications(); 
  runApp(const MyApp());
}
