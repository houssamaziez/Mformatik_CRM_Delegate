  import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:mformatic_crm_delegate/App/View/home/home_screens/home_mission/mission_details/profile_mission.dart';

import '../../Model/web_socket_notifcation_model.dart';
import '../../Util/Route/Go.dart';
import '../../View/home/home_screens/home_mission/mission_all/mission_list_screen.dart';
import '../../View/home/home_screens/home_task/task_details/details_task.dart';
import '../../View/home/notifications/notifications_screen.dart';
import 'notification_handler.dart';

@pragma('vm:entry-point')
    class ConstWsNotification {
    static    const notificationId2 = 442;
   static const String channelDescription = 'This channel is used for important notifications';
   static const String channelId = 'high_importance_channel';
   static const String channelName = 'High Importance Notifications';
  static const String notificationIcon = '@mipmap/ic_launcher';
  static IosConfiguration iosConfig = IosConfiguration();

  static const oneNotificationChannel = AndroidNotificationChannel(
 channelId,
   channelName,
    description: '${channelDescription}',
    importance: Importance.max,
    playSound: true,
    showBadge: true,
  );



    static const serviceNotificationChannel = AndroidNotificationChannel(
    '${channelId}1',
    '${channelName}1',
    description: '${channelDescription}1.',
    importance: Importance.max,
  );



  
  static final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin()
    ..initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings(
        ConstWsNotification.  notificationIcon,
        ),
      ),
      onDidReceiveNotificationResponse: notificationResponse,
      onDidReceiveBackgroundNotificationResponse: notificationResponse,
    );



      @pragma('vm:entry-point')
  static void notificationResponse(NotificationResponse notificationResponse) {
    if (notificationResponse.payload != null) {
      Logger( ).i(notificationResponse.payload);
      var payload = notificationResponse.payload;
      if (payload != null) {
        Map<String, dynamic> parsedData = jsonDecode(payload);
  Go.to(Get.context,NotificationScreenAll());

     if (parsedData['ids'] is int) {
      if (parsedData['entity'] == "mission") {
CriNotificationService.editNotificationStatus(notificationId: parsedData['ids']  , status:  3);
        Go.to(Get.context, MissionProfileScreen(missionId: parsedData['ids']));
      }
      if (parsedData['entity'] == "task") {
CriNotificationService.editNotificationStatus(notificationId: parsedData['ids']  , status:  3);

        Go.to(Get.context, TaskProfileScreen(taskId: parsedData['ids']));
      }
 
    }else{
 CriNotificationService.editNotificationStatus(notificationId: parsedData['ids']   , status:  3);

  if (parsedData['entity'] == "mission"){
        Go.to(Get.context, MissionListScreen(ids:parsedData['ids']));
  
}



    }
        // RoutingManager.router.pushNamed(RoutingManager.missionDetailsScreen, extra: int.parse(parsedData['id']));
      }
    }
   
    }



    
  @pragma('vm:entry-point')
  static void showNotificationMultiEntities(WebSocketNotificationModel notificationDetails) {
   ConstWsNotification. flutterLocalNotificationsPlugin.show(
      Random().nextInt(10000),
      'New ${notificationDetails.entity}s',
      'By : ${notificationDetails.creator!.username}',
      payload:
          '{"ids": ${notificationDetails.data!.ids}, "entity": "${notificationDetails.entity}", "companyId": ${notificationDetails.data!.companyId},"annexId": ${notificationDetails.data!.annexId}}',
      NotificationDetails(
        android: AndroidNotificationDetails(
        ConstWsNotification.  oneNotificationChannel.id,
        ConstWsNotification.  oneNotificationChannel.name,
          channelDescription:ConstWsNotification. oneNotificationChannel.description,
          importance: Importance.high,
          priority: Priority.max,
          color: Colors.deepOrange,
          channelShowBadge: true,
          enableLights: true,

          //  sound: const RawResourceAndroidNotificationSound(notificationSound),
          // playSound: true,
          icon:ConstWsNotification. notificationIcon,
        ),
      ),
    );
  }
 @pragma('vm:entry-point')
  static void showNotification(WebSocketNotificationModel notificationDetails) {
  ConstWsNotification.  flutterLocalNotificationsPlugin.show(
      Random().nextInt(10000000),
      'New ${notificationDetails.entity}',
      'By : ${notificationDetails.creator!.username}',
      payload:
          '{"ids": ${notificationDetails.data!.ids}, "entity": "${notificationDetails.entity}", "companyId": ${notificationDetails.data!.companyId},"annexId": ${notificationDetails.data!.annexId}}',
      NotificationDetails(
        android: AndroidNotificationDetails(
        ConstWsNotification.  oneNotificationChannel.id,
         ConstWsNotification. oneNotificationChannel.name,
          channelDescription:ConstWsNotification. oneNotificationChannel.description,
          importance: Importance.high,
          priority: Priority.max,
          color: Colors.deepOrange,
          channelShowBadge: true,
          enableLights: true,

          //  sound: const RawResourceAndroidNotificationSound(notificationSound),
          // playSound: true,
          icon:ConstWsNotification. notificationIcon,
        ),
      ),
    );
  }
  @pragma('vm:entry-point')
static void showNotification2(String title, String subtitle , int id) {
  Logger().i("Displaying notification: $title - $subtitle");
  
  // Example using flutter_local_notifications:
  // Replace this with your actual notification logic
ConstWsNotification.  flutterLocalNotificationsPlugin.show(
    id,
    title, 
    subtitle, 
    NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_id', // Channel ID
        'channel_name', // Channel Name
        importance: Importance.high,
        priority: Priority.high,
      ),
      // iOS: IOSNotificationDetails(),
    ),
  );
}
    }