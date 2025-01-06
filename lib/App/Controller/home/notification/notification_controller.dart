// import 'package:audioplayers/audioplayers.dart';
// import 'package:get/get.dart';

// import '../../../Model/in_app_notification_model.dart';
// import '../../../Service/notification_handler.dart';
// import '../../../Util/global_expcetion_handler.dart';
 

// class NotificationController extends GetxController {
//   final AudioPlayer player = AudioPlayer();

//   RxInt notificationCount = 0.obs;
//   RxBool isMultiSelecting = false.obs;

//   RxList<InAppNotificationModel> notificationsList = <InAppNotificationModel>[].obs;
//   RxList<InAppNotificationModel> selectedNotifications = <InAppNotificationModel>[].obs;

//   final NotificationRepository notificationRepo;

//   NotificationController({required this.notificationRepo});

//   Future<void> getNotifications() async {
//     try {
//       notificationsList.clear();
//       notificationsList.addAll(await notificationRepo.getNotifications());
//     } catch (e) {
//       GlobalExceptionHandler.handle(exception: e);
//     }
//   }

//   Future<void> editNotificationStatus({required int notificationId, required int status}) async {
//     try {
//       await notificationRepo.editNotificationStatus(notificationId: notificationId, status: status);
//     } catch (e) {
//       GlobalExceptionHandler.handle(exception: e);
//     }
//   }

//   Future<void> editNotificationsBulkStatus({required List<int> notificationsIdsList, required int status}) async {
//     try {
//       await notificationRepo.editNotificationsBulkStatus(
//         notificationsIdsList: notificationsIdsList,
//         status: status,
//       );
//     } catch (e) {
//       GlobalExceptionHandler.handle(exception: e);
//     }
//   }

//   void selectNotification(InAppNotificationModel notification) {
//     if (selectedNotifications.any((element) => element.id == notification.id)) {
//       selectedNotifications.remove(notification);
//     } else {
//       selectedNotifications.add(notification);
//     }
//     isMultiSelecting.value = selectedNotifications.length > 1;
//   }

//   bool checkNotificationSelection(InAppNotificationModel notification) {
//     return selectedNotifications.any((element) => element.id == notification.id);
//   }

//   void quitMultiSelectingMode() {
//     isMultiSelecting.value = false;
//     selectedNotifications.clear();
//   }

//   Future<void> markNotificationsAsRead(List<InAppNotificationModel> notifications) async {
//     try {
//       if (notifications.length == 1) {
//         await markOneNotificationAsRead(notifications.first);
//       } else {
//         await markMultiNotificationsAsRead(notifications);
//       }
//     } catch (e) {
//       GlobalExceptionHandler.handle(exception: e);
//     }
//   }

//   Future<void> markOneNotificationAsRead(InAppNotificationModel notification) async {
//     try {
//       await notificationRepo.editNotificationStatus(
//         notificationId: notification.id,
//         status: NotificationStatus.read.id,
//       );
//       final index = notificationsList.indexWhere((element) => element.id == notification.id);
//       if (index != -1) {
//         notificationsList[index].receiver.status = NotificationStatus.read.id;
//         notificationsList.refresh();
//       }
//       selectedNotifications.removeWhere((element) => element.id == notification.id);
//     } catch (e) {
//       GlobalExceptionHandler.handle(exception: e);
//     }
//   }

//   Future<void> markMultiNotificationsAsRead(List<InAppNotificationModel> notifications) async {
//     try {
//       await notificationRepo.editNotificationsBulkStatus(
//         notificationsIdsList: notifications.map((e) => e.id).toList(),
//         status: NotificationStatus.read.id,
//       );
//       for (var notification in notifications) {
//         final index = notificationsList.indexWhere((element) => element.id == notification.id);
//         if (index != -1) {
//           notificationsList[index].receiver.status = NotificationStatus.read.id;
//         }
//       }
//       notificationsList.refresh();
//       selectedNotifications.removeWhere((element) => notifications.any((n) => n.id == element.id));
//     } catch (e) {
//       GlobalExceptionHandler.handle(exception: e);
//     }
//   }

//   void refreshNotificationsRealTimeCount() {
//     CriNotificationService.flutterBgInstance.on('refreshNotificationsCount').listen((event) {
//       playNotificationSound();
//       notificationCount.value += event!['count'] as int;
//     });
//   }

//   void resetNotificationsRealTimeCount() {
//     notificationCount.value = 0;
//   }

//   Future<void> playNotificationSound() async {
//     await player.play(AssetSource("asstes/sounds/notification_track.wav"));
//     player.onPlayerComplete.listen((event) {
//       player.stop();
//     });
//   }

//   @override
//   void onClose() {
//     player.dispose();
//     super.onClose();
//   }
// }

// enum NotificationStatus {
//   unDelivred(
//     id: 1,
//   ),
//   delivered(
//     id: 2,
//   ),
//   seen(id: 3),
//   read(id: 4);

//   final int id;
//   const NotificationStatus({required this.id});
// }