import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:mformatic_crm_delegate/App/RouteEndPoint/EndPoint.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/showsnack.dart';

import '../../Model/reason_mission.dart';
import '../auth/auth_controller.dart';

class ReasonsMissionController extends GetxController {
  var reasons = <ReasonMission>[]; // Observable list of reasons
  var isLoading = false; // Loading state

  Future<void> fetchReasons() async {
    isLoading = true; // Set loading state to true
    update();
    try {
      final response = await http.get(
        Uri.parse(Endpoint.apiMissionsReasons),
        headers: {"x-auth-token": token.read("token").toString()},
      ).timeout(const Duration(seconds: 30));

       Logger() .i(response.body);
      if (response.statusCode == 200) {
        // Parse the JSON response
        final responseData = ReasonResponse.fromJson(jsonDecode(response.body));
        reasons = responseData.reasons; // Update the observable list
        update();
      } else {
        // Handle error responses
        showMessage(Get.context, title: "Failed to load reasons:".tr);
      }
    } catch (e) {
      // Handle exceptions
      showMessage(Get.context, title: "Failed to load reasons:".tr);
    } finally {
      isLoading = false; // Reset loading state
      update();
    }
  }

  @override
  void onInit() {
    fetchReasons();
    super.onInit();
  }
}
