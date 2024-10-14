import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mformatic_crm_delegate/App/RouteEndPoint/EndPoint.dart';
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';
import 'package:mformatic_crm_delegate/App/View/auth/screen_auth.dart';
import 'package:mformatic_crm_delegate/App/View/home/home_screen.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/showsnack.dart';
import '../../Model/user.dart';
import '../../Util/app_exceptions/global_expcetion_handler.dart';
import '../../Util/app_exceptions/response_handler.dart';

String key =
    "seyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NTMsInVzZXJuYW1lIjoiYWRtaW4iLCJpc0FjdGl2ZSI6dHJ1ZSwicm9sZUlkIjoyLCJhbm5leElkIjpudWxsLCJjb21wYW55SWQiOm51bGwsInBlcnNvbiI6eyJpZCI6MjcsImZpcnN0TmFtZSI6IkFkbWluIiwibGFzdE5hbWUiOiJBY2NvdW50IiwiaW1nIjpudWxsLCJ1c2VySWQiOjUzLCJjcmVhdGVkQXQiOiIyMDI0LTEwLTAyVDA4OjMyOjAyLjAwMFoiLCJ1cGRhdGVkQXQiOiIyMDI0LTEwLTA5VDA4OjAwOjU2LjAwMFoifSwiaWF0IjoxNzI4OTIyNTcyfQ.OulMvLjEqEfua-eNlIoiSgSicRxTjyuQsVHr9F6b5pY";

class AuthController extends GetxController {
  TextEditingController namecontroller = TextEditingController(text: "admin");
  TextEditingController passwordcontroller =
      TextEditingController(text: "123456");
  // Observable state management using GetX's Rx types
  var isLoading = false;
  User? user;
  bool isPasswordVisible = false; // Variable to toggle password visibility

  // Login method with improved structure and feedback for UI
  Future<void> login(context,
      {required String username, required String password}) async {
    Uri url = Uri.parse(Endpoint.apiLogin);
    if (namecontroller.text == '' || passwordcontroller.text == '') {
      showMessage(context, title: "Please fill in the blank fields.");
      return;
    }
    isLoading = true; // Set loading state
    update();
    try {
      final response = await http.post(url, body: {
        "username": username,
        "password": password,
      });

      // Handle response and parse user data
      final responseData = ResponseHandler.processResponse(response);
      if (responseData != null && responseData.containsKey('user')) {
        user = User.fromJson(responseData['user']);
        print('Logged in as: ${user?.username}');
      } else {}
    } catch (e) {
      // Handle exceptions
      showMessage(context, title: 'Connection problem'.tr);
    } finally {
      isLoading = false; // Reset loading state
      update();
    }
  }

// Login method with improved structure and feedback for UI
  Future<void> getme(
    context,
  ) async {
    Uri url = Uri.parse(Endpoint.apime);
    if (namecontroller.text == '' || passwordcontroller.text == '') {
      showMessage(context, title: "Please fill in the blank fields.");
      return;
    }
    isLoading = true; // Set loading state
    update();
    try {
      final response = await http.get(url, headers: {"x-auth-token": key});
      print(response.body);
      // Handle response and parse user data
      final responseData = ResponseHandler.processResponse(response);
      if (jsonDecode(response.body)[0]["message"] != "invalid token") {
        // user = User.fromJson(responseData['user']);
        print('Logged in as: ${user?.username}');
        Go.clearAndTo(context, HomeScreen());
      } else {
        if (response.statusCode == 401) {
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

  passwordVisibleupdate() {
    isPasswordVisible = !isPasswordVisible;
    update();
  }
}
