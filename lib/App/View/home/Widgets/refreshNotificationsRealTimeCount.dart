import 'package:get/get.dart';

import '../../../Controller/home/notification/notification_controller.dart';
import '../../../Service/notification_handler.dart';

refreshNotificationsRealTimeCount() {
     Get.put(NotificationController()). GetCount();
    CriNotificationService.flutterBgInstance
        .on(
      'refreshNotificationsCount',
    )
        .listen((event) {
      // playNotificationSound();
    Get.put(NotificationController()).refreshNotificationsCount();
    });
  }