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

  Map<int, String> notificationStatus = {
    1: 'unDelivred',
    2: 'delivered',
    3: 'seen',
    4: 'read',
  };

  int notificationcount = 0;

  refreshNotificationsCount(Map<String, dynamic>? event) async {
    WebSocketNotificationModel notificationDetails =
        WebSocketNotificationModel.fromJson(event!);
    notificationcount = notificationcount + 1;
    update();

    if (storage.read<bool>('isNotification') != true) {
      await playSound();

      Get.snackbar(
        retunTitle(notificationDetails.title!, 1),
        '@${notificationDetails.creator!.username} '.tr +
            retunSupTitle(notificationDetails.title!, 1),
      );
      editNotificationStatus(
          notificationId: notificationDetails.id!, status: 2);
    }
  }

  clhNotificationsCount() async {
    sendNotificationRequest(id: 2);
    sendNotificationRequest(id: 3);
    notificationcount = 0;
    update();
  }

  GetCount() async {
    final response = await http.get(
        Uri.parse('${Endpoint.apiNotifications}/delivered-count'),
        headers: {
          'x-auth-token': token.read("token").toString(),
        });

    notificationcount = int.parse(response.body);
    update();
    if (response.statusCode == 200) {
      notificationcount = int.parse(response.body);
      update();
    }
  }

  bool isLoading = false;
  List<NotificationRow> notifications = [];

  Future<void> editNotificationStatus(
      {required int notificationId, required int status}) async {
    final response = await http.put(
        Uri.parse('${Endpoint.apiNotifications}/$notificationId/to/$status'),
        headers: {
          'x-auth-token': token.read("token").toString(),
        });
    Logger().e(response.body);
    Logger().e(response.statusCode);

    if (response.statusCode == 204) {
      fetchNotifications(isRefresh: true);
    }
    // await ResponseHandler.processResponse(response);
  }

  bool hasMore = true; // To track if more data is available
  int limit = 10; // Number of notifications per page
  int offset = 0; // Starting point for pagination

  Future<void> fetchNotifications({bool isRefresh = false}) async {
    if (isLoading) return; // Prevent duplicate calls while loading

    try {
      isLoading = true;
      update();

      if (isRefresh) {
        // Reset the pagination on refresh
        offset = 0;
        hasMore = true;
        notifications.clear();
      }

      var response = await http.get(
        Uri.parse('${Endpoint.apiNotifications}?limit=$limit&offset=$offset'),
        headers: {
          "x-auth-token": token.read("token").toString(),
        },
      );

      Logger().i(response.body);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        List<dynamic> rows = responseData['rows'];

        // Check if new data is less than limit to determine if there's more data
        hasMore = rows.length == limit;

        // Append new notifications to the list
        notifications.addAll(
            rows.map((json) => NotificationRow.fromJson(json)).toList());
        offset += limit; // Increment offset for the next page
        update();
      } else {
        showMessage(Get.context, title: "Failed to load notifications.".tr);
      }
    } catch (e) {
      Logger().e(e);
      showMessage(Get.context, title: "Failed to load notifications.".tr);
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> sendNotificationRequest({required int id}) async {
    var headers = {
      'x-auth-token': token.read("token").toString(),
    };

    final respons =
        await http.put(Uri.parse('${Endpoint.apiNotifications}/$id'), headers: {
      'x-auth-token': token.read("token").toString(),
    }, body: {
      // "id" : 1 // work
      "id": "all" // also work
      //"id" : "all2" // also work
    } // to ways to send notifecation ids,
            );
    print(respons.body);

    if (respons.statusCode == 200) {
      print(respons.body);
    } else {
      print(respons.body);
    }
  }

  Future<void> loadMoreNotifications() async {
    if (hasMore) {
      await fetchNotifications();
    }
  }
}
