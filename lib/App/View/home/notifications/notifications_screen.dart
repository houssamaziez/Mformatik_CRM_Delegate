import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controller/home/notification/notification_controller.dart';
import '../../widgets/showsnack.dart';
import 'widgets/notification_card.dart';

class NotificationScreenAll extends StatefulWidget {
  NotificationScreenAll({Key? key}) : super(key: key);

  @override
  State<NotificationScreenAll> createState() => _NotificationScreenAllState();
}

class _NotificationScreenAllState extends State<NotificationScreenAll> {
  final NotificationController _notificationController = Get.put(NotificationController());
initState() {
  super.initState();
  _notificationController.fetchNotifications();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     'Notifications'.tr,
      //     style: const TextStyle(fontWeight: FontWeight.bold),
      //   ),
      //   centerTitle: true,
      // ),
      body: GetBuilder<NotificationController>(
        builder: (controller) {


          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (controller.notifications.isEmpty) {
            return Center(
              child: Text(
                'No notifications found.'.tr,
                style: const TextStyle(fontSize: 16),
              ),
            );
          }

  return   ListView.builder(
  itemCount: controller. notifications.length,
  itemBuilder: (context, index) {
    final notification = controller.notifications[index];
    return CardNotification(
      title: notification.title,
      createdAt: notification.createdAt,
      subtitle: "Subtitle or additional info here", // Customize this based on your data
      onTap: () {
        showMessage(
          context,
          title: 'Notification Clicked'.tr,
          // message: notification.title,
        );
      }, entity:  notification.entity,
    );
  },
);

        },
      ),
    );
  }
}
