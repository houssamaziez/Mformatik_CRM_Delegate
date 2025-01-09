import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';
import 'package:mformatic_crm_delegate/App/View/home/Settings/Notification/notificationscreen.dart';
import 'App/Service/notification_handler.dart';
 import 'App/View/home/notifications/notifications_screen.dart';
import 'App/myapp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await GetStorage.init();
  await CriNotificationService.initializeService(isBackground: false);
  initializeNotifications();
 
 
  runApp(const MyApp());
}

 Future<void> initializeNotifications() async {
  // Get the launch details to check if the app was launched by a notification
  final NotificationAppLaunchDetails? launchDetails =
      await CriNotificationService.flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  // Check if the app was launched by a notification and has a payload
  if (launchDetails != null && launchDetails.didNotificationLaunchApp) {
    Logger().i("Navigating to mission details");

    Logger().i(launchDetails.notificationResponse?.payload);
    final payload = launchDetails.notificationResponse?.payload;
    if (payload != null) {
      Map<String, dynamic> parsedData = jsonDecode(payload);
      onNotificationTappedRedirect(parsedData);
    }
  }
}

void onNotificationTappedRedirect(
  Map<String, dynamic> notificationData,
) async {
    Logger().i("Navigating to mission details");

  List listItems = notificationData['ids'];
  // debugPrint(listItems.toString());

  if (listItems.length > 1) {
    switch (notificationData['entity']) {
      case 'mission':
    Logger().e(notificationData['entity']);
        break;

      // case 'task':
      //   RoutingManager.router.pushNamed(RoutingManager.);
      //   break;

      default:
        return;
    }
  } else {
    switch (notificationData['entity']) {
  case 'mission':
    Logger().i("Navigating to mission details");
    if (listItems.length > 1) {
      Logger().e("Multiple missions: ${listItems.join(", ")}");
    } else {
WidgetsBinding.instance.addPostFrameCallback((_) {
  Go.to(Get.context, NotificationScreenAll());
});
    }
    break;

  case 'task':
    Logger().i("Navigating to task details");
    // Add task-specific navigation here
    break;

  default:
    Logger().e("Unknown entity: ${notificationData['entity']}");
}

  }
}
