import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mformatic_crm_delegate/App/RouteEndPoint/EndPoint.dart';

import '../../Model/reason.dart';
import '../auth/auth_controller.dart';

class ReasonsController extends GetxController {
  var reasons = <Reason>[]; // Observable list of reasons
  var isLoading = false; // Loading state

  Future<void> fetchReasons() async {
    isLoading = true; // Set loading state to true
    update();
    try {
      final response = await http.get(
        Uri.parse(Endpoint.apiMissionsReasons),
        headers: {"x-auth-token": token.read("token").toString()},
      ).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        // Parse the JSON response
        final responseData = ReasonResponse.fromJson(jsonDecode(response.body));
        reasons = responseData.reasons; // Update the observable list
        update();
      } else {
        // Handle error responses
        Get.snackbar('Error', 'Failed to load reasons: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      Get.snackbar('Error', 'Failed to load reasons: $e');
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
