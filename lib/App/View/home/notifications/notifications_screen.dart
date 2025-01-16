
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/refresh.dart';
import 'package:mformatic_crm_delegate/App/View/home/home_screens/home_mission/mission_all/mission_list_screen.dart';
import '../../../Controller/home/notification/notification_controller.dart';
import '../../../Service/web_socket.dart';
import '../../../Service/ws_notification/notification_handler.dart';
import '../../../myapp.dart';
import '../home_screens/home_mission/mission_details/profile_mission.dart';
import '../home_screens/home_task/task_details/details_task.dart';
import 'widgets/notification_card.dart';

class NotificationScreenAll extends StatefulWidget {
  NotificationScreenAll({Key? key,  this.ishome  =false}) : super(key: key);
final bool   ishome;
  @override
  State<NotificationScreenAll> createState() => _NotificationScreenAllState();
}

class _NotificationScreenAllState extends State<NotificationScreenAll> {
  @override
  void initState() {
    super.initState();

    // Ensure that fetchNotifications is called after the build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.put(NotificationController()).fetchNotifications().then((value) {
        print('Notifications fetched successfully!');
      }).catchError((error) {
        print('Error fetching notifications: $error');
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      
      appBar:widget. ishome ? null : AppBar(
        title: Text(
          'Notifications'.tr,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: GetBuilder<NotificationController>(
        init: NotificationController(),
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
      subtitle: notification.creator!.username, // Customize this based on your data
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
print(notification.entity);

    if (parsedId is int) {
      if (notification.entity == "mission") {
controller.editNotificationStatus(notificationId: notification .id  , status:  3);
        Go.to(context, MissionProfileScreen(missionId: parsedId));
      }
      if (notification.entity == "task") {
controller.editNotificationStatus(notificationId: notification .id  , status:  3);

        Go.to(context, TaskProfileScreen(taskId: parsedId));
      }
 
    }else{
controller.editNotificationStatus(notificationId: notification .id  , status:  3);

  if (notification.entity == "mission"){
        Go.to(context, MissionListScreen(ids:parsedId));
  
}

Logger().e(parsedId);


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





  void playNotificationSound() {

    if (storage.read<bool> ('isNotification' ) == true) {
          CriNotificationService.flutterBgInstance
        .on(
      'refreshNotificationsCount',
    )
        .listen((event) {
            Get.put(NotificationController()).refreshNotificationsCount();
            Get.put(NotificationController()).fetchNotifications();
    
    });
    } else {
     initWS( );
    }

  }
 