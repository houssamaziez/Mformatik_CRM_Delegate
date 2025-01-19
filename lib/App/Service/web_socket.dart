import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as web_socket_io;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';

import '../Controller/auth/auth_controller.dart';
import '../Controller/home/notification/notification_controller.dart';
import 'ws_notification/notification_handler.dart';

Future<void> initWS() async {
  await GetStorage.init();
  await dotenv.load(fileName: ".env");
  try {
    // debugPrint("i'm inside download fucntion");
    String WEBSOCKET_URL = dotenv.get('urlHost');
    var socket = web_socket_io.io(
      WEBSOCKET_URL,
      web_socket_io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuth({"token": token.read("token")})
          .build(),
    );
    socket.connect();
    socket.onConnect((data) {
      print('Connected to server');
    });
    socket.onDisconnect((data) {
      print('Disconnected to server');
      Logger().i(data);
    });
    socket.on('notification', (data) {
      Logger().i(data);
      var data2 = data;
      if (data2 is Map) {
        Logger().i("data is map");
      } else {
        data.forEach((value) {
          CriNotificationService.editNotificationStatus(
              notificationId: value['id'], status: 2);
          Get.put(NotificationController()).refreshNotificationsCount(data);
          Get.put(NotificationController()).fetchNotifications();
        });
      }
      if (data['data']['id'] is List) {
        List<int> ids =
            (data['data']['id'] as List).map<int>((e) => e as int).toList();

        CriNotificationService.editNotificationStatus(
            notificationId: data['data']['id'].first, status: 2);
        Get.put(NotificationController()).refreshNotificationsCount(data);
        Get.put(NotificationController()).fetchNotifications();
      } else {
        CriNotificationService.editNotificationStatus(
            notificationId: data['data']['id'], status: 2);
        Get.put(NotificationController()).refreshNotificationsCount(data);
        Get.put(NotificationController()).fetchNotifications();
      }
    });
    socket.onError((data) {
      print("ws data ==>$data");
      Logger().e(data);
    });
  } catch (e, stackTrace) {
    // GlobalExceptionHandler.handle(exception: e, exceptionStackTrace: stackTrace);
  }
}
