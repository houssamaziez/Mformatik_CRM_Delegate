import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/Dialog/showExitConfirmationDialog.dart';

import '../../../../Controller/home/notification/notification_controller.dart';
import '../../../../Util/Date/formatDate.dart';
import '../../../../Util/Route/Go.dart';

// Assuming DrawableAssetStrings is a class that holds your asset paths for icons.
class DrawableAssetStrings {
  static const String missionIcon = 'assets/icons/target.png';
  static const String taskIcon = 'assets/icons/Group2.png';
  static const String decisionIcon = 'assets/icons/decision_icon.png';
  static const String feedbackIcon = 'assets/icons/feedback_icon.png';
}

class CardNotification extends StatelessWidget {
  final String title;
  final String createdAt;
  final String subtitle;
  final String entity;

  final int status;
  final int notificationId;
  final VoidCallback onTap;

  const CardNotification({
    Key? key,
    required this.title,
    required this.createdAt,
    required this.subtitle,
    required this.entity,
    required this.onTap, required this.status, required this.notificationId,
  }) : super(key: key);
  
    Color getColorsForEntity(int entity) {
    switch (entity) {
      case 1:
        return Colors.blue[200]!.withOpacity(0.2);

      case 2:
        return Colors.blue[200]!.withOpacity(0.2);

      case 3:
       return Colors.white;

      case 4:
    return Colors.blue[200]!.withOpacity(0.2);

      default:
        return  Colors.blue[200]!.withOpacity(0.2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(color: getColorsForEntity( status ),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:getColorsForEntity( status ) ,// Theme.of(context).primaryColor.withOpacity(0.2),
              ),
              child: Image.asset(
                getIconForEntity(entity),
                width: 24,
                height: 24,
                color: Theme.of(context).primaryColor,
              ),
            ),
            title: Text(
              retunTitle(title),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '@$subtitle '.tr+ retunSupTitle(title),
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                 
              ],
            ),
            trailing:Column(
              children: [
                Text(
                timeDifference(DateTime.parse(createdAt)),
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              
      ]),
            onTap: onTap,onLongPress: (){


            showExitConfirmationDialog(context, onPressed: (){

              Get.put(NotificationController()).editNotificationStatus(notificationId:  notificationId  , status: 4);
              Go.back(context);
            }, title:"Change Status", details: "Do you want to mark the notification as unread?");
            },
          ),
        ),
      Container(color: const Color.fromARGB(255, 207, 207, 207),height: 1,)],
    );
  }
}


String getIconForEntity(String entity) {
    switch (entity) {
      case "mission":
        return DrawableAssetStrings.missionIcon;

      case "task":
        return DrawableAssetStrings.taskIcon;

      case "decision":
        return DrawableAssetStrings.decisionIcon;

      case "feedback":
        return DrawableAssetStrings.feedbackIcon;

      default:
        return DrawableAssetStrings.missionIcon;
    }
  }


 String retunTitle(String title){
switch (title) {
  case "newMission":
    return "New mission notification";
  case "missionStatusChange":
    return "Mission status updated";
  case "newTask":
    return "New task created";
  case "taskObserver":
  return "Assigned as task observer";
  case "assignAsObserver":
    return "Assigned as task observer";
  case "taskResponsible":
  return "Assigned as task responsible";
  case "assignAsResponsible":
    return "Assigned as task responsible";
  case "taskStatusChange":
    return "Task status updated";
  default:
    return "Unknown title";
}
  }


String retunSupTitle(String title) {
  switch (title) {
    case "newMission":
      return " has created a new mission for you. Check it out now!";
    case "missionStatusChange":
      return "The status of a mission has been updated. Please review it.";
    case "newTask":
      return " has created a new task for you. Check it out now!";
    case "taskObserver":
      return "You have been assigned as an observer for a task.";
    case "assignAsObserver":
      return "You are now assigned as an observer for this task.";
    case "taskResponsible":
      return "You have been marked as responsible for a task.";
    case "assignAsResponsible":
      return "You are now assigned as the responsible person for this task.";
    case "taskStatusChange":
      return "The status of a task has been changed. Please check it.";
    default:
      return "Unknown title.";
  }
}
