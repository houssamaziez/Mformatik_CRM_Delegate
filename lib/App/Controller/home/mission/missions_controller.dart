import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/company_controller.dart';
import 'package:mformatic_crm_delegate/App/RouteEndPoint/EndPoint.dart';
import 'package:http/http.dart' as http;
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';
import 'package:mformatic_crm_delegate/App/View/home/home.dart';
import 'dart:convert';

import '../../../Model/mission.dart';
import '../../../Util/app_exceptions/response_handler.dart';
import '../../../View/widgets/showsnack.dart';
import '../../auth/auth_controller.dart';
import '../../widgetsController/expandable_controller.dart';

class MissionsController extends GetxController {
  List<Mission>? missions = [];
  Mission? mission;
  List<Mission>? missionsfilter = [];
  bool isLoading = false;
  bool isLoadingProfile = false;
  bool isLoadingProfilebutton = false;
  bool isLoadingMore = false;
  int offset = 0;
  int limit = 7;
  int missionslength = 0;
  int indexminu = 0;
  int inProgress = 0;
  int created = 0;
  int completed = 0;
  int canceled = 0;
  onIndexChanged(indexselect) {
    var controllerUser = Get.put(AuthController());
    print(controllerUser.user!.roleId);
    inProgress = 0;
    update();
    completed = 0;
    update();
    canceled = 0;
    update();
    created = 0;
    update();
    missionsfilter!.clear();
    missions!.forEach((action) {
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
  Future<void> getAllMission(context, int companyId,
      {String? startingDate = "", String? endingDate = ""}) async {
    missions!.clear();
    update();

    final uri = Uri.parse('${Endpoint.apiMissions}').replace(
      queryParameters: {
        'companyId': companyId.toString(),
        'offset': 0.toString(),
        'limit': limit.toString(),
      },
    );

    // offset = 7;
    if (companyId == 0) {
      return;
    }
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
        update();

        missionslength = MissionResponse.fromJson(responseData).count;
        update();
        // onIndexChanged(0);
      } else {
        missionsfilter!.clear();
      }
      final ff = jsonDecode(response.body);
      final responseCounts = await http.get(
        Uri.parse("${Endpoint.apiMissionCounts}?companyId=$companyId"),
        headers: {"x-auth-token": token.read("token").toString()},
      );
      print(
          "------------------------------------------------------------------------");
      print(response.body);
      print(
          "------------------------------------------------------------------------");

      if (responseCounts.statusCode == 200) {
        // Decode the JSON response into a list of maps
        List<dynamic> responseData = jsonDecode(responseCounts.body);

        // Iterate over the list to find the counts based on the labels
        for (var item in responseData) {
          switch (item["label"]) {
            case "NEW":
              created = item["count"];
              break;
            case "IN_PROGRESS":
              inProgress = item["count"];
              break;
            case "COMPLETED":
              completed = item["count"];
              break;
            case "CANCELED":
              canceled = item["count"];
              break;
          }
        }

        // Call update once after all assignments
        update();
      }
    } catch (e) {
      showMessage(context, title: 'Connection problem'.tr);
    } finally {
      isLoading = false;
      update();
    }
  }

  // Create a new mission
  Future<void> createMission(
      {required String desc,
      required int clientId,
      required context,
      required String text}) async {
    isLoading = true;
    update();
    var reasonId;
    final uri = Uri.parse('${Endpoint.apiMissions}');
    final cilentID = Get.put(AuthController()).user!.id;
    ExpandableControllerd controller = Get.put(ExpandableControllerd());
    reasonId = controller.selectedItem.value!.id;

    String label = "";

    if (reasonId == null) {
      showMessage(context, title: "Select Reasons");
      isLoading = false;
      update();
      return;
    }
    // if (reasonId != 1) {
    //   showMessage(context, title: "Complete the field");
    //   isLoading = false;
    //   update();
    //   return;
    // }
    label = controller.controllerTextEditingController!.text;
    if ((label == "" || label.length <= 3) && reasonId == 1) {
      showMessage(Get.context, title: 'Please specify'.tr);
      isLoading = false;
      update();
      return;
    }

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
        getAllMission(context, Get.put(CompanyController()).selectCompany!.id);

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

  upadtestatus(int nex) async {
    try {
      final respons = await http.put(Uri.parse(Endpoint.apiChangeStatus));
    } catch (e) {}
  }

  bool changestatus = false;

  Future<void> changeStatuseMission(int id, int missionId) async {
    try {
      changestatus = true;
      update();

      final response = await http.put(
        Uri.parse(Endpoint.apiChangeStatus + "/${id.toString()}"),
        headers: {
          'x-auth-token': token.read("token").toString(),
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "missions": [missionId]
        }),
      );
      if (response.statusCode == 200) {
        await getMissionById(Get.context, missionId, isLoding: true);
        getAllMission(
            Get.context, Get.put(CompanyController()).selectCompany!.id);
        // showMessage(
        //   Get.context,
        //   title: 'Mission Status updated successfully',
        //   color: Colors.green,
        // );
      }
    } catch (e) {
      showMessage(
        Get.context,
        title: "Failed to load Mission Status".tr,
      );
    } finally {
      changestatus = false;
      update();
    }
  }

  Future<void> getMissionById(context, int missionId,
      {bool isLoding = false}) async {
    if (isLoding) {
      isLoadingProfilebutton = true;
      update();
    } else {
      isLoadingProfile = true;
      update();
    }

    final uri = Uri.parse(
        '${Endpoint.apiMissions}/$missionId'); // Add API endpoint for single mission
    print("object");
    try {
      final response = await http.get(
        uri,
        headers: {"x-auth-token": token.read("token").toString()},
      ).timeout(const Duration(seconds: 50));
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 404) {
        mission = null;
        update();
      }
      if (response.statusCode == 200) {
        final responseData = ResponseHandler.processResponse(response);
        mission =
            Mission.fromJson(responseData); // Assuming mission is the model
        update(); // Update the state to refresh the screen
      } else {
        showMessage(context, title: 'Error fetching mission data'.tr);
      }
    } catch (e) {
      showMessage(context, title: 'Connection problem'.tr);
    } finally {}

    if (isLoding) {
      isLoadingProfilebutton = false;
      update();
    } else {
      isLoadingProfile = false;
      update();
    }
  }
}
