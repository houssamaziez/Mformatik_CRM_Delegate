import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/refresh.dart';
import '../../../Controller/home/notification/notification_controller.dart';
import '../../widgets/showsnack.dart';
import '../home_screens/home_mission/mission_details/profile_mission.dart';
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
    return CardNotification(status: notification.receiver!.status!,
      title: notification.title,
      createdAt: notification.createdAt,
      subtitle: "Subtitle or additional info here", // Customize this based on your data
      onTap: () {
        dynamic parsedId;

    if (notification.data!.id is int) {


      parsedId =notification.data!.id; // Single integer
    } else if (notification.data!.id is List) {
      // Check if it's a List of integers
      parsedId = (notification.data!.id as List).whereType<int>().toList(); // Ensure it's a List<int>
    } else {
      parsedId = 0; // Default value if id is null or invalid
    }


    if (parsedId is int) {

      Logger().i('notitificationnidf ${notification .id}');
      controller.editNotificationStatus(notificationId: notification .id  , status:  3);

      // Go.to(context,  MissionProfileScreen( missionId: notification.data!.id));
      
    }

    print( parsedId);
      }, entity:  notification.entity,
    );
  },
).addRefreshIndicator(onRefresh: () => controller.fetchNotifications());

        },
      ),
    );
  }
}
