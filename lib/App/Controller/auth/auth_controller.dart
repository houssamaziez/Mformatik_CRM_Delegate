import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mformatic_crm_delegate/App/RouteEndPoint/EndPoint.dart';
import '../../Model/user.dart';
import '../../Util/app_exceptions/global_expcetion_handler.dart';
import '../../Util/app_exceptions/response_handler.dart';

class AuthController extends GetxController {
  TextEditingController namecontroller = TextEditingController(text: "admin");
  TextEditingController passwordcontroller =
      TextEditingController(text: "123456");
  // Observable state management using GetX's Rx types
  var isLoading = false;
  User? user;
  bool isPasswordVisible = false; // Variable to toggle password visibility

  // Login method with improved structure and feedback for UI
  Future<void> login(
      {required String username, required String password}) async {
    isLoading = true; // Set loading state
    update();
    Uri url = Uri.parse(Endpoint.apiLogin);
    if (namecontroller.text == null || passwordcontroller.text == null) {}
    try {
      final response = await http.post(url, body: {
        "username": username,
        "password": password,
      });

      // Handle response and parse user data
      final responseData = ResponseHandler.processResponse(response);
      if (responseData != null ||
          passwordcontroller.text == null && responseData.containsKey('user')) {
        user = User.fromJson(responseData['user']);
        print('Logged in as: ${user?.username}');
      } else {
        print('Failed to login. Invalid response.');
      }
    } catch (e) {
      // Handle exceptions
      GlobalExceptionHandler.handle(e);
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
