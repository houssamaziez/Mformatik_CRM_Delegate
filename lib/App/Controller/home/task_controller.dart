import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/company_controller.dart';
import 'package:mformatic_crm_delegate/App/Model/task.dart';
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

class TaskController extends GetxController {
  List<Task>? tasks = [];
  Mission? mission;
  List<Mission>? missionsfilter = [];
  bool isLoading = false;
  bool isLoadingCreate = false;
  bool isLoadingProfile = false;
  bool isLoadingProfilebutton = false;
  bool isLoadingMore = false;
  int offset = 0;
  int limit = 7;
  int tasklength = 0;
  int indexminu = 0;
  int inProgress = 0;
  int created = 0;
  int completed = 0;
  int canceled = 0;
  onIndexChanged(indexselect) {}

  Future<void> createTask({
    required String label,
    required String responsibleId,
    required String observerId,
    required String itemDescription,
    List<String>? imgPaths, // Optional
    List<String>? videoPaths, // Optional
    List<String>? excelPaths, // Optional
    List<String>? pdfPaths, // Optional
  }) async {
    isLoadingCreate = true;
    update();
    try {
      var headers = {
        'x-auth-token': token.read("token").toString(),
      };

      var request = http.MultipartRequest('POST', Uri.parse(Endpoint.apiTask));
      request.fields.addAll({
        'label': label,
        'responsibleId': responsibleId,
        'observerId': observerId,
        'items[0][desc]': itemDescription,
      });

      // Add files if the lists are provided and not empty
      if (imgPaths != null && imgPaths.isNotEmpty) {
        await _addFilesFromList(request, 'prImg', imgPaths);
      }
      if (videoPaths != null && videoPaths.isNotEmpty) {
        await _addFilesFromList(request, 'prVideo', videoPaths);
      }
      if (excelPaths != null && excelPaths.isNotEmpty) {
        await _addFilesFromList(request, 'prExcel', excelPaths);
      }
      if (pdfPaths != null && pdfPaths.isNotEmpty) {
        await _addFilesFromList(request, 'prPdf', pdfPaths);
      }

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        var decodedResponse = jsonDecode(responseBody);
        print('Task created successfully: $decodedResponse');
      } else {
        throw Exception('Failed to create task: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error while creating task: $e');
    } finally {
      isLoadingCreate = false;
      update();
    }
  }

  Future<void> _addFilesFromList(http.MultipartRequest request,
      String fieldName, List<String> filePaths) async {
    for (var filePath in filePaths) {
      if (filePath.isNotEmpty && File(filePath).existsSync()) {
        request.files
            .add(await http.MultipartFile.fromPath(fieldName, filePath));
      } else {
        print('File for $fieldName not found or path is empty: $filePath');
      }
    }
  }

  // Fetch all missions
  Future<void> getAllTask(
    context,
  ) async {
    final uri = Uri.parse('${Endpoint.apiTask}').replace(
      queryParameters: {},
    );

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
        tasks = TaskResponse.fromJson(responseData).rows;
        update();

        tasklength = MissionResponse.fromJson(responseData).count;
        update();
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
