import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mformatic_crm_delegate/App/RouteEndPoint/EndPoint.dart';
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';
import 'package:mformatic_crm_delegate/App/View/auth/screen_auth.dart';
import 'package:mformatic_crm_delegate/App/View/home/home.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/showsnack.dart';
import '../../Model/user.dart';
import '../../Util/app_exceptions/response_handler.dart';
import '../../View/splashScreen/splash_screen.dart';

GetStorage token = GetStorage();

class AuthController extends GetxController {
  TextEditingController namecontroller = TextEditingController(text: "");
  TextEditingController passwordcontroller = TextEditingController(text: "");
  var isLoading = false;
  User? user;
  Person? person;
  bool isPasswordVisible = false;

  Future<void> login(context,
      {required String username, required String password}) async {
    Uri url = Uri.parse(Endpoint.apiLogin);
    if (namecontroller.text == '' || passwordcontroller.text == '') {
      showMessage(context, title: "Please fill in the blank fields.".tr);
      return;
    }
    isLoading = true; // Set loading state
    update();
    try {
      final response = await http.post(url, body: {
        "username": username.trim(),
        "password": password.trim(),
      });
      print(response.statusCode);
      // Handle response and parse user data
      final responseData = ResponseHandler.processResponse(response);
      if (responseData != null && responseData.containsKey('user')) {
        user = User.fromJson(responseData['user']);
        person = Person.fromJson(responseData['user']["person"]);
        if (user!.roleId == 4) {
          token.write("token", responseData['token']);
          await spalshscreenfirst.write('key', true);

          Go.clearAndTo(context, HomeScreen());
        } else {
          showMessage(context, title: "You are not allowed to enter.".tr);
        }

        print('person in as: ${person?.firstName}');
        print('user in as: ${user?.username}');
      } else {}
      // ------------------------

      print(response.body);
      // ------------------------
      if (response.statusCode == 401) {
        showMessage(context,
            title:
                "Access Denied! You don't have permission to view this content."
                    .tr);
      }
      if (response.statusCode == 400) {
        showMessage(context, title: decodeResponseBody(response)[0]["message"]);
      }
    } catch (e) {
      // Handle exceptions
      showMessage(context, title: 'Connection problem'.tr);
    } finally {
      isLoading = false; // Reset loading state
      update();
    }
  }

  Future<void> getme(
    context,
  ) async {
    Uri url = Uri.parse(Endpoint.apIme);

    isLoading = true;
    update();
    try {
      final response = await http
          .get(url, headers: {"x-auth-token": token.read("token").toString()});
      print(response.body);
      final responseData = ResponseHandler.processResponse(response);
      print(response.statusCode);
      if (response.statusCode == 200) {
        user = User.fromJson(responseData['user']);
        update();
        person = Person.fromJson(responseData);
        update();

        print('person in as: ${person?.firstName}');
        print('user in as: ${user?.username}');
        if (user!.roleId == 4) {
          await spalshscreenfirst.write('key', true);

          Go.clearAndTo(context, HomeScreen());
        } else {
          Go.clearAndTo(context, ScreenAuth());
          showMessage(context, title: "You are not allowed to enter.".tr);
        }
      } else {
        if (response.statusCode == 401 ||
            response.statusCode == 403 ||
            response.statusCode == 404) {
          Go.clearAndTo(context, ScreenAuth());
        }
      }
    } catch (e) {
      // Handle exceptions
      showMessage(context, title: 'Connection problem'.tr);
    } finally {
      isLoading = false; // Reset loading state
      update();
    }
  }

  Future<void> updateMe(
    context,
  ) async {
    Uri url = Uri.parse(Endpoint.apIme);

    isLoading = true;
    update();
    try {
      final response = await http
          .get(url, headers: {"x-auth-token": token.read("token").toString()});
      print(response.body);
      final responseData = ResponseHandler.processResponse(response);
      if (response.statusCode == 200) {
        user = User.fromJson(responseData['user']);
        update();
        person = Person.fromJson(responseData);
        update();
      }
    } catch (e) {
      // Handle exceptions
      showMessage(context, title: 'Connection problem'.tr);
    } finally {
      isLoading = false; // Reset loading state
      update();
    }
  }

  passwordVisibleupdate() {
    isPasswordVisible = !isPasswordVisible;
    update();
  }

  static dynamic decodeResponseBody(http.Response response) {
    return jsonDecode(response.body);
  }
}
