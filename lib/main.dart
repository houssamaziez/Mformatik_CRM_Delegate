import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'App/Service/get_app_ersion.dart';
import 'App/Service/ws_notification/notification_handler.dart';
import 'App/View/home/Settings/screenSetting.dart';
import 'App/myapp.dart';
import 'App/View/splashScreen/splashScreenanimation/app_loader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await GetStorage.init();
  // var f = storage.read<bool>('isNotification');
  // if (storage.read<bool>('isNotification') == null) {
  //   storage.write('isNotification', false);
  // }

  // if (storage.read<bool>('isNotification') == true) {
  //   await Future.delayed(Duration(seconds: 2));
  //   await CriNotificationService.initializeService(isBackground: false);
  // } else {
  //   CriNotificationService.flutterBgInstance.invoke('stopService');
  // }
  appVersion = await getAppVersion();

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // initializeNotifications();
  runApp(const AppLoader());
}
