import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import 'package:http/http.dart' as http;
import 'package:mformatic_crm_delegate/App/View/home/notifications/widgets/notification_card.dart';

import '../../../Model/notification.dart';
import '../../../Model/web_socket_notifcation_model.dart';
import '../../../RouteEndPoint/EndPoint.dart';

import '../../../Util/play_sound.dart';
import '../../../View/widgets/showsnack.dart';
import '../../../myapp.dart';
import '../../auth/auth_controller.dart';
 
class NotificationController extends GetxController {
Uri url = Uri.parse(Endpoint.apiNotifications);

Map<int, String> notificationStatus ={

  1: 'unDelivred',
  2: 'delivered',
  3: 'seen',
  4: 'read',
};


 int notificationcount = 0;

refreshNotificationsCount (Map<String, dynamic>? event) async {
WebSocketNotificationModel notificationDetails =  WebSocketNotificationModel.fromJson(event!);
  if (storage.read<bool> ('isNotification' ) != true) {
    notificationcount = notificationcount + 1;
update();
 await playSound();
 
    Get.snackbar(
      retunTitle(  notificationDetails.title!) ,
    '@${notificationDetails.creator!.username} '.tr+  retunSupTitle( notificationDetails.title!),);
  }

}

clhNotificationsCount () async {
notificationcount =0;
update();
}


GetCount()async{

  final response = await http.get(Uri.parse('${Endpoint.apiNotifications}/delivered-count'), headers:  {
      'x-auth-token': token.read("token").toString(),
    });
  
notificationcount = int.parse(response.body) ;
  update();
if (response.statusCode == 200) {
notificationcount = int.parse(response.body) ;
  update();
} 

}
bool isLoading = false;
  List<NotificationRow> notifications =  [] ;

  fetchNotifications({List? ids}) async { 
 

    try {
       isLoading = true;
       update();
      var response = await http.get(url  , headers: {
        "x-auth-token": token.read("token").toString(),
      });


       Logger().f(response.statusCode);
      if (response.statusCode == 200) {
       Map<String, dynamic> responseData = json.decode(response.body);
      List<dynamic> rows = responseData['rows'];
     
      
       // Access the `rows` field from the root JSON
      notifications = rows.map((json) => NotificationRow.fromJson(json)).toList();
        update();
      } else {
        showMessage(Get.context, title: "Failed to load notifications.".tr);
      }
    } catch (e) {
      Logger().e(e);
      showMessage(Get.context, title: "Failed to load notifications.".tr);
    } 
    finally {
      isLoading = false;
      update();
    }
 
}






Future<void> editNotificationStatus({required int notificationId, required int status}) async {
    final response = await http.put(Uri.parse('${Endpoint.apiNotifications}/$notificationId/to/$status'), headers:  {
      'x-auth-token': token.read("token").toString(),
    });
    Logger().e(response.body);
    Logger().e(response.statusCode);

if (response.statusCode == 204) {
  
  fetchNotifications();
}
    // await ResponseHandler.processResponse(response);
  }
}
