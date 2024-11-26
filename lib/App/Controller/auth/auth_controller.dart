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
import '../../Service/auth_service.dart';
import '../../Util/app_exceptions/response_handler.dart';
import '../../Util/app_exceptions/response_handler/process_response_auth.dart';
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
    if (namecontroller.text == '' || passwordcontroller.text == '') {
      showMessage(context, title: "Please fill in the blank fields.".tr);
      return;
    }
    isLoading = true;
    update();
    try {
      final responseData = await AuthService.login(
        username: username.trim(),
        password: password.trim(),
      );

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
      }
    } catch (e) {
      showMessage(context, title: 'Connection problem'.tr);
    } finally {
      isLoading = false;
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

      final responseData = ResponseHandlerAuth.processResponseGetMe(response);

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
