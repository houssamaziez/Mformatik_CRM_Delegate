import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/company_controller.dart';
import 'package:mformatic_crm_delegate/App/RouteEndPoint/EndPoint.dart';
import 'package:http/http.dart' as http;
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';
import 'package:mformatic_crm_delegate/App/View/home/Home%20screen/home_screen.dart';
import 'dart:convert';

import '../../Model/mission.dart';
import '../../Util/app_exceptions/response_handler.dart';
import '../../View/widgets/showsnack.dart';
import '../auth/auth_controller.dart';
import '../widgetsController/expandable_controller.dart';

class MissionsController extends GetxController {
  List<Mission>? missions = [];
  List<Mission>? missionsfilter = [];
  bool isLoading = false;
  bool isLoadingMore = false;
  int offset = 0;
  int limit = 7;
  int indexminu = 0;
  onIndexChanged(indexselect) {
    var controllerUser = Get.put(AuthController());
    print(controllerUser.user!.roleId);
    inProgress = 0;
    update();
    completed = 0;
    update();
    canceled = 0;
    update();
    missionsfilter!.clear();
    missions!.forEach((action) {
      getStatusLabel(action.statusId);
      if (indexselect == 1) {
        if (action.creatorRoleId == controllerUser.user!.roleId) {
          missionsfilter!.add(action);
        }
      } else {
        if (action.creatorRoleId != controllerUser.user!.roleId) {
          missionsfilter!.add(action);
        }
      }
    });
    update();
    print(missionsfilter);
    indexminu = indexselect;
    update();
    print("----------------------");
    print(inProgress.toString() +
        " " +
        completed.toString() +
        " " +
        canceled.toString());
    print("----------------------");
  }

  // Fetch all missions
  Future<void> getAllMission(context, int companyId) async {
    var controllerUser = Get.put(AuthController());

    offset = 0;
    // final uri =
    //     Uri.parse('${Endpoint.apiMissions}?offset=$offset&limit=$limit');
    final uri = Uri.parse('${Endpoint.apiMissions}').replace(
      queryParameters: {
        'companyId': companyId.toString(),
      },
    );
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
        onIndexChanged(0);
      } else {
        missionsfilter!.clear();
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
  Future<void> loadingMoreMission(
    context,
  ) async {
    var controllerUser = Get.put(AuthController());
    var controllercompany = Get.put(CompanyController());

    isLoadingMore = true;
    update();
    offset = limit + offset;
    update();

    final uri = Uri.parse('${Endpoint.apiMissions}').replace(
      queryParameters: {
        'companyId': controllercompany.selectCompany!.id.toString(),
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
        onIndexChanged(indexminu);
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
  Future<void> createMission(
      {required String desc,
      required int clientId,
      required context,
      required String text}) async {
    var reasonId;
    final uri = Uri.parse('${Endpoint.apiMissions}');
    final cilentID = Get.put(AuthController()).user!.id;
    ExpandableController controller = Get.put(ExpandableController());
    reasonId = controller.selectedItem.value!.id;

    String label = text;

    if (reasonId == null) {
      showMessage(context, title: "Select Reasons");

      return;
    }
    if (label == "" && reasonId != 1) {
      showMessage(context, title: "Complete the field");
      return;
    }
    isLoading = true;
    update();
    final body = {
      "label": label.toString(),
      "desc": desc,
      "isSuccessful": null,
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
        // Navigator.of(context).popUntil();
        Go.clearAndTo(context, HomeScreen());
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

  int inProgress = 0;
  int completed = 0;
  int canceled = 0;
  getStatusLabel(int statusId) {
    switch (statusId) {
      case 2:
        inProgress = inProgress + 1;
        // 'In Progress'.tr; // Translates to "In Progress"
        update();
      case 3:
        completed = completed + 1;
        update();
      // 'Completed'.tr; // Translates to "Completed"
      case 4:
        canceled = canceled + 1;
        update();
      // 'Canceled'.tr; // Translates to "Canceled"
    }
  }
}
