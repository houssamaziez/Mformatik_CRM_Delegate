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

  final int statusNotification;
  final int status;
  final int notificationId;
  final VoidCallback onTap;

  const CardNotification({
    Key? key,
    required this.title,
    required this.createdAt,
    required this.subtitle,
    required this.entity,
    required this.onTap,
    required this.statusNotification,
    required this.status,
    required this.notificationId,
  }) : super(key: key);

  Color getColorsForEntity(int entity) {
    switch (entity) {
      case 1:
        return Colors.blue[200]!.withOpacity(0.2);

      case 2:
        return Colors.blue[200]!.withOpacity(0.2);

      case 4:
        return Colors.white;

      case 3:
        return Colors.blue[200]!.withOpacity(0.2);

      default:
        return Colors.blue[200]!.withOpacity(0.2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: getColorsForEntity(statusNotification),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: getColorsForEntity(
                    statusNotification), // Theme.of(context).primaryColor.withOpacity(0.2),
              ),
              child: Image.asset(
                getIconForEntity(entity),
                width: 24,
                height: 24,
                color: Theme.of(context).primaryColor,
              ),
            ),
            title: Text(
              retunTitle(title, status),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (entity != "mission" ? '@$subtitle '.tr : "") +
                      retunSupTitle(title, status),
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                const SizedBox(height: 4),
              ],
            ),
            trailing: Column(children: [
              Text(
                timeDifference(DateTime.parse(createdAt)),
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ]),
            onTap: onTap,
            onLongPress: () {
              showExitConfirmationDialog(context, onPressed: () {
                Get.put(NotificationController()).editNotificationStatus(
                    notificationId: notificationId, status: 3);
                Get.put(NotificationController())
                    .fetchNotifications(isRefresh: true);
                Go.back(context);
              },
                  title: "Change Status".tr,
                  details:
                      "Do you want to mark the notification as unread?".tr);
            },
          ),
        ),
        Container(
          color: const Color.fromARGB(255, 207, 207, 207),
          height: 1,
        )
      ],
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

String retunTitle(String title, int status) {
  switch (title) {
    case "newMission":
      return "New mission notification".tr;
    case "missionStatusChange":
      return "Mission status updated".tr;
    case "newTask":
      return "New task created".tr;
    case "taskObserver":
    case "assignAsObserver":
      return "Assigned as task observer".tr;
    case "taskResponsible":
    case "assignAsResponsible":
      return "Assigned as task responsible".tr;
    case "taskStatusChange":
      return _getTaskStatusMessage(status);
    default:
      return "Unknown title".tr;
  }
}

String _getTaskStatusMessage(int status) {
  switch (status) {
    case 1:
      return "Created a task".tr;
    case 2:
      return "Started a task".tr;
    case 3:
    case 4:
      return "Has responded to a task".tr;
    case 5:
      return "Has closed a task".tr;
    case 6:
      return "Closed a task".tr;
    case 7:
      return "Cancelled a task".tr;
    default:
      return "Unknown status".tr;
  }
}

String retunSupTitle(String title, int status) {
  switch (title) {
    case "newMission":
      return "A new mission has been created for you. Check it out now!".tr;
    case "missionStatusChange":
      return "The status of a mission has been updated. Please review it.".tr;
    case "newTask":
      return "A new task has been created for you. Check it out now!".tr;
    case "taskObserver":
    case "assignAsObserver":
      return "You have been assigned as an observer for this task.".tr;
    case "taskResponsible":
    case "assignAsResponsible":
      return "You have been assigned as the responsible person for this task."
          .tr;
    case "taskStatusChange":
      return _getTaskStatusSupMessage(status);
    default:
      return "Unknown title.".tr;
  }
}

String _getTaskStatusSupMessage(int status) {
  switch (status) {
    case 1:
      return "A task has been created. Please review it.".tr;
    case 2:
      return "A task has been started. Stay updated.".tr;
    case 3:
    case 4:
      return "A response has been added to the task. Check it now.".tr;
    case 5:
      return "The task has been closed. Review the details.".tr;
    case 6:
      return "The task has been completed and closed.".tr;
    case 7:
      return "The task has been cancelled.".tr;
    default:
      return "The task status has been updated. Please check it.".tr;
  }
}
