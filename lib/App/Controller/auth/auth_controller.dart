import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mformatic_crm_delegate/App/RouteEndPoint/EndPoint.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/showsnack.dart';
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
