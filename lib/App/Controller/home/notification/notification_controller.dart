import 'dart:convert';

import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../../Model/in_app_notification_model.dart';
import 'package:http/http.dart' as http;

import '../../../Model/notification.dart';
import '../../../RouteEndPoint/EndPoint.dart';
import '../../../View/widgets/showsnack.dart';
import '../../auth/auth_controller.dart';
 
class NotificationController extends GetxController {
Uri url = Uri.parse(Endpoint.apiNotifications);

bool isLoading = false;
  List<NotificationRow> notifications =  [] ;

  fetchNotifications() async { 

    try {
       isLoading = true;
       update();
      var response = await http.get(url  , headers: {
        "x-auth-token": token.read("token").toString(),
      });


      Logger().i(response.statusCode);  
      if (response.statusCode == 200) {
       Map<String, dynamic> responseData = json.decode(response.body);
      List<dynamic> rows = responseData['rows'];
      Logger().i(rows);
      
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
}
