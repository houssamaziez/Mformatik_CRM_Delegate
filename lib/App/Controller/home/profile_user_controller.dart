import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mformatic_crm_delegate/App/Controller/auth/auth_controller.dart';
import 'package:mformatic_crm_delegate/App/RouteEndPoint/EndPoint.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/showsnack.dart';

class ProfileUserController extends GetxController {
  bool isloading = false;
  String message = "";
  updateProfile({required String firstName, required String lastName}) async {
    Uri url = Uri.parse(Endpoint.apipersonsUpdate);
    isloading = true;
    update();
    try {
      final response = await http.put(url, headers: {
        'x-auth-token': token.read("token").toString(),
      }, body: {
        'firstName': firstName,
        'lastName': lastName,
      });
      if (response.statusCode == 400) {
        message = jsonDecode(response.body)[0]["path"];
        showMessage(Get.context, title: jsonDecode(response.body)[0]["path"]);
      }
      if (response.statusCode == 204) {
        showMessage(
          Get.context,
          title: 'User updated successfully'.tr,
          color: Colors.green,
        );
        Get.put(AuthController()).updateMe(Get.context);
      } else {
        message = jsonDecode(response.body)[0]["path"];

        showMessage(Get.context,
            title: jsonDecode(response.body)[0]["path"].tr);
      }
    } catch (e) {
      showMessage(Get.context,
          title: message == "" ? 'Connection problem'.tr : message);
    } finally {
      isloading = false;
      update();
    }
  }

  updatePassword(
      {required String oldPassword, required String newPassword}) async {
    Uri url = Uri.parse(Endpoint.apipersonsUpdate);
    isloading = true;
    print("response.statusCode");
    update();
    try {
      final response = await http.put(url,
          headers: {
            "Content-Type": "application/json",
            'x-auth-token': token.read("token").toString(),
          },
          body: jsonEncode({
            'user': {
              "oldPassword": oldPassword,
              "newPassword": newPassword,
            },
          }));
      print(response.body);

      if (response.statusCode == 204) {
        showMessage(
          Get.context,
          title: 'Password updated successfully'.tr,
          color: Colors.green,
        );
        Get.put(AuthController()).updateMe(Get.context);
      } else {
        message = jsonDecode(response.body)[0]["code"];

        showMessage(Get.context,
            title: jsonDecode(response.body)[0]["code"].tr);
      }
    } catch (e) {
      showMessage(Get.context,
          title: message == "" ? 'Connection problem'.tr : message);
    } finally {
      isloading = false;
      update();
    }
  }
}
