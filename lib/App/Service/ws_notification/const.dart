import 'dart:convert';
import 'dart:math';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:mformatic_crm_delegate/App/View/home/home_screens/home_mission/mission_details/profile_mission.dart';

import '../../Controller/auth/auth_controller.dart';
import '../../RouteEndPoint/EndPoint.dart';
import '../../Util/Route/Go.dart';
import '../../View/home/home_screens/home_mission/mission_all/mission_list_screen.dart';
import '../../View/home/home_screens/home_task/task_details/details_task.dart';
import '../../View/home/notifications/notifications_screen.dart';
import 'notification_handler.dart';
import 'package:http/http.dart' as http;

@pragma('vm:entry-point')
class ConstWsNotification {
  static Future<void> editNotificationStatus(
      {required int notificationId, required int status}) async {
    final response = await http.put(
        Uri.parse('${Endpoint.apiNotifications}/$notificationId/to/$status'),
        headers: {
          'x-auth-token': token.read("token").toString(),
        },
        body: {
          "id": "all" // also work
        });
    Logger().e(response.body);
    Logger().e(response.statusCode);

    // await ResponseHandler.processResponse(response);
  }

  static const notificationId2 = 442;
  static const String channelDescription =
      'This channel is used for important notifications';
  static const String channelId = 'high_importance_channel';
  static const String channelName = 'High Importance Notifications';
  static const String notificationIcon = '@mipmap/ic_launcher';
  static IosConfiguration iosConfig = IosConfiguration();

  static const oneNotificationChannel = AndroidNotificationChannel(
    channelId,
    channelName,
    description: '${channelDescription}',
    importance: Importance.max,
    playSound: false,
    showBadge: true,
  );

  static const serviceNotificationChannel = AndroidNotificationChannel(
    '${channelId}1',
    '${channelName}1',
    playSound: false,
    description: '${channelDescription}1.',
    importance: Importance.max,
  );

  static final flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin()
        ..initialize(
          const InitializationSettings(
            android: AndroidInitializationSettings(
              ConstWsNotification.notificationIcon,
            ),
          ),
          onDidReceiveNotificationResponse: notificationResponse,
          onDidReceiveBackgroundNotificationResponse: notificationResponse,
        );

  @pragma('vm:entry-point')
  static void notificationResponse(NotificationResponse notificationResponse) {
    if (notificationResponse.payload != null) {
      Logger().i(notificationResponse.payload);
      var payload = notificationResponse.payload;
      if (payload != null) {
        Map<String, dynamic> parsedData = jsonDecode(payload);
        // Go.to(Get.context, NotificationScreenAll());
        Logger().i(" notification payload:  ${parsedData}");
        if (parsedData['ids'][0] is int) {
          if (parsedData['entity'] == "mission") {
            editNotificationStatus(
                notificationId: parsedData['ids'][0], status: 3);
            Go.to(Get.context,
                MissionProfileScreen(missionId: parsedData['ids'][0]));
          }
          if (parsedData['entity'] == "task") {
            editNotificationStatus(
                notificationId: parsedData['ids'][0], status: 3);

            Go.to(Get.context, TaskProfileScreen(taskId: parsedData['ids'][0]));
          }
        } else {
          editNotificationStatus(notificationId: parsedData['ids'], status: 3);

          if (parsedData['entity'] == "mission") {
            Go.to(Get.context, MissionListScreen(ids: parsedData['ids']));
          }
        }
        // RoutingManager.router.pushNamed(RoutingManager.missionDetailsScreen, extra: int.parse(parsedData['id']));
      }
    }
  }
}
