import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/company_controller.dart';
import 'package:mformatic_crm_delegate/App/RouteEndPoint/EndPoint.dart';
import 'package:http/http.dart' as http;
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';
import 'package:mformatic_crm_delegate/App/View/home/home.dart';
import 'dart:convert';

import '../../Model/mission.dart';
import '../../Util/app_exceptions/response_handler.dart';
import '../../View/widgets/showsnack.dart';
import '../auth/auth_controller.dart';
import '../widgetsController/expandable_controller.dart';

class MissionsControllerAll extends GetxController {
  List<Mission>? missions = [];
  Mission? mission;
  List<Mission>? missionsfilter = [];
  bool isLoading = false;
  bool isLoadingProfile = false;
  bool isLoadingMore = false;
  int offset = 0;
  int limit = 7;
  int missionslength = 0;
  int indexminu = 0;

  // Fetch all missions
  Future<void> getAllMission(context, int companyId,
      {String? startingDate = "",
      String? endingDate = "",
      String? statusId = "",
      String? creatorId = ""}) async {
    missions!.clear();
    update();
    offset = 0;

    final uri = Uri.parse('${Endpoint.apiMissions}').replace(
      queryParameters: {
        'companyId': companyId.toString(),
        'offset': offset.toString(),
        'limit': limit.toString(),
        if (startingDate != "") ...{'startDate': startingDate},
        if (creatorId!.isNotEmpty || creatorId != "") ...{
          'creatorId': creatorId
        },
        if (statusId!.isNotEmpty || statusId != "") ...{'statusId': statusId},
        if (endingDate != "") ...{'endDate': endingDate},
      },
    );
    if (companyId == 0) {
      return;
    }
    offset = 7;

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
      } else {
        missionsfilter!.clear();
      }
    } catch (e) {
      showMessage(context, title: 'Connection problem'.tr);
    } finally {
      isLoading = false;
      update();
    }
  }

  // Load more missions
  Future<void> loadingMoreMission(context,
      {String? startingDate = "",
      String? endingDate = "",
      String? statusId = "",
      String? creatorId = ""}) async {
    var controllercompany = Get.put(CompanyController());

    final uri = Uri.parse('${Endpoint.apiMissions}').replace(
      queryParameters: {
        'companyId': controllercompany.selectCompany!.id.toString(),
        'offset': offset.toString(),
        'limit': limit.toString(),
        if (startingDate != "") ...{'startDate': startingDate},
        if (creatorId!.isNotEmpty || creatorId != "") ...{
          'creatorId': creatorId
        },
        if (statusId!.isNotEmpty || statusId != "") ...{'statusId': statusId},
        if (endingDate != "") ...{'endDate': endingDate},
      },
    );

    isLoadingMore = true;
    update();
    try {
      final response = await http.get(
        uri,
        headers: {"x-auth-token": token.read("token").toString()},
      ).timeout(const Duration(seconds: 50));
      print(response.body);
      final responseData = ResponseHandler.processResponse(response);
      if (response.statusCode == 200) {
        offset = offset + limit;
        missions!.addAll(MissionResponse.fromJson(responseData).rows);
        update();
        missionslength = MissionResponse.fromJson(responseData).count;
        update();
        // onIndexChanged(indexminu);
      }
      print(missions!.first.client!.fullName);
    } catch (e) {
      isLoadingMore = false;
      update();
    } finally {
      isLoadingMore = false;
      update();
    }
  }
}
