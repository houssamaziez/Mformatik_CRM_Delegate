import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/RouteEndPoint/EndPoint.dart';
import 'package:http/http.dart' as http;
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';
import 'dart:convert';

import '../../Model/mission.dart';
import '../../Util/app_exceptions/response_handler.dart';
import '../../View/widgets/showsnack.dart';
import '../auth/auth_controller.dart';
import '../widgetsController/expandable_controller.dart';

class MissionsController extends GetxController {
  List<Mission>? missions = [];
  bool isLoading = false;
  bool isLoadingMore = false;
  int offset = 0;
  int limit = 20;

  // Fetch all missions
  Future<void> getAllMission(context) async {
    offset = 0;
    final uri =
        Uri.parse('${Endpoint.apiMissions}?offset=$offset&limit=$limit');
    offset = limit + offset;
    update();

    isLoading = true;
    update();
    try {
      final response = await http.get(
        uri,
        headers: {"x-auth-token": token.read("token").toString()},
      ).timeout(const Duration(seconds: 50));
      print(response.body);
      final responseData = ResponseHandler.processResponse(response);
      if (response.statusCode == 200) {
        missions = MissionResponse.fromJson(responseData).rows;
      }
    } catch (e) {
      offset = limit - offset;
      update();
      showMessage(context, title: 'Connection problem'.tr);
    } finally {
      isLoading = false;
      update();
    }
  }

  // Load more missions
  Future<void> loadingMoreMission(context) async {
    isLoadingMore = true;
    update();

    offset = limit + offset;
    update();

    final uri = Uri.parse('${Endpoint.apiMissions}').replace(
      queryParameters: {
        'offset': offset.toString(),
        'limit': limit.toString(),
      },
    );
    update();
    try {
      final response = await http.get(
        uri,
        headers: {"x-auth-token": token.read("token").toString()},
      ).timeout(const Duration(seconds: 50));
      print(response.body);
      final responseData = ResponseHandler.processResponse(response);
      if (response.statusCode == 200) {
        missions!.addAll(MissionResponse.fromJson(responseData).rows);
      }
    } catch (e) {
      offset = limit - offset;
      isLoadingMore = false;
      update();
    } finally {
      isLoadingMore = false;
      update();
    }
  }

  // Create a new mission
  Future<void> createMission({
    required String desc,
    required int clientId,
    required context,
  }) async {
    var reasonId;
    final uri = Uri.parse('${Endpoint.apiMissions}');
    final cilentID = Get.put(AuthController()).user!.id;
    ExpandableController controller = Get.put(ExpandableController());
    reasonId = controller.selectedItem.value!.id;

    final String label =
        Get.put(ExpandableController()).controllerTextEditingController!.text;

    if (reasonId == null) {
      showMessage(context, title: "Select Reasons");

      return;
    }
    if (label == "" && reasonId != 3) {
      print(reasonId);
      showMessage(context, title: "Complete the field");
      return;
    }
    isLoading = true;
    update();
    final body = {
      "label": label.toString(),
      "desc": desc,
      "isSuccessful": true,
      "clientId": clientId,
      "responsibleId": cilentID,
      "reasonId": reasonId,
    };

    try {
      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "x-auth-token": token.read("token").toString(),
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        showMessage(context,
            title: 'Mission created successfully!'.tr, color: Colors.green);
        // getAllMission(context); // Refresh the mission list after creation

        Go.back(context);
      } else {
        showMessage(context, title: 'Failed to create mission'.tr);
      }
    } catch (e) {
      showMessage(context, title: 'Connection problem'.tr);
    } finally {
      isLoading = false;
      update();
    }
  }
}
