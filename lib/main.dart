import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'App/Service/get_app_ersion.dart';
import 'App/Service/notification_handler.dart';
import 'App/View/home/Settings/screenSetting.dart';
import 'App/myapp.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await GetStorage.init();
  if (storage.read<bool> ('isNotification' ) == null) {
    storage.write('isNotification', false);
    
  }
Logger().t( " isNotification "+storage.read<bool> ('isNotification' ).toString());
 if (storage.read<bool> ('isNotification' ) == true) {
  await CriNotificationService.initializeService(isBackground: false);
 }else{
  //  CriNotificationService.getNotifications ( );
   
 }
appVersion = await getAppVersion();
  // initializeNotifications(); 
  runApp(const MyApp());
}
