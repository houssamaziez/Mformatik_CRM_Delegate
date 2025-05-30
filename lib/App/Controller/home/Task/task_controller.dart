import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:mformatic_crm_delegate/App/Model/task_models/task.dart';
import 'package:mformatic_crm_delegate/App/RouteEndPoint/EndPoint.dart';
import 'package:http/http.dart' as http;
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';
import 'dart:convert';
import '../../../Model/mission.dart';
import '../../../Model/task_models/task_respones.dart';
import '../../../Service/permission_handler/storage.dart';
import '../../../Util/app_exceptions/response_handler.dart';
import '../../../Util/extention/file.dart';
import '../../../View/widgets/showsnack.dart';
import '../../auth/auth_controller.dart';

final Map<String, Map<String, dynamic>> fileCache = {};

class TaskController extends GetxController {
  List<Task>? tasks = [];
  Task? task;
  List<File>? files;
  bool voicedownloadLoading = false;
  String? pahtFile;
  List<Mission>? missionsfilter = [];
  bool isLoading = false;
  bool isLoadingCreate = false;
  bool isLoadingProfile = false;
  bool isLoadingProfilebutton = false;
  bool isLoadingMore = false;
  int isAssigned = 0;
  int detailsSelect = 0;
  int offset = 0;
  int limit = 7;
  int tasklength = 0;
  int news = 0;
  int canceled = 0;
  int closed = 0;
  int start = 0;
  int ownerRespond = 0;
  int responsipleRespond = 0;
  int responsibleColsed = 0;
  state(int status) {
    switch (status) {
      case 1:
        news = news + 1;
        break;
      case 6:
        closed = closed + 1;
        break;
      case 7:
        canceled = canceled + 1;
        break;
      case 2:
        start = start + 1;
        break;
      case 3:
        ownerRespond = ownerRespond + 1;
        break;
      case 4:
        responsipleRespond = responsipleRespond + 1;
        break;
      case 5:
        responsibleColsed = responsibleColsed + 1;
        break;
    }
  }

  onIndexChanged(int indexselect) {
    final userid = Get.put(AuthController()).user!.id.toString();
    isAssigned = indexselect;
    update();

    if (indexselect == 0) {
      getAllTask(
        Get.context,
        responsibleId: userid,
      );
      return;
    }
    if (indexselect == 2) {
      getAllTask(
        Get.context,
        observerId: userid,
      );

      return;
    }
    if (indexselect == 1) {
      getAllTask(Get.context, ownerId: userid);

      return;
    }
  }

  onIndexChangedSelect(int indexselect) {
    detailsSelect = indexselect;
    update();
  }

  Future<void> createTask({
    required String label,
    required String responsibleId,
    String observerId = "",
    required String itemDescription,
    String? deadline,
    List<String>? imgPaths, // Optional
    List<String>? videoPaths, // Optional
    List<String>? excelPaths, // Optional
    List<String>? pdfPaths, // Optional
  }) async {
    String _userId = Get.put(AuthController()).user!.id.toString();

    isLoadingCreate = true;
    update();
    try {
      var headers = {
        'x-auth-token': token.read("token").toString(),
      };

      var request = http.MultipartRequest('POST', Uri.parse(Endpoint.apiTask));
      request.fields.addAll({
        'label': label,
        if (deadline != "" && deadline != null) ...{
          'deadline': deadline.toString()
        },
        'responsibleId': responsibleId,
        if (observerId != "" && observerId != null) ...{
          'observerId': observerId.toString()
        },
        'items[0][desc]': itemDescription,
      });

      if (imgPaths != null) {
        for (var filePath in imgPaths) {
          request.files
              .add(await http.MultipartFile.fromPath('prImg', filePath));
        }
      }

      // Add PDF files (if any)
      if (pdfPaths != null) {
        for (var filePath in pdfPaths) {
          request.files
              .add(await http.MultipartFile.fromPath('prPdf', filePath));
        }
      }

      // Add Excel files (if any)
      if (excelPaths != null) {
        for (var filePath in excelPaths) {
          request.files
              .add(await http.MultipartFile.fromPath('prExcel', filePath));
        }
      }

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        var decodedResponse = jsonDecode(responseBody);
        print('Task created successfully: $decodedResponse');
        print('statusCode created  task: ${response.statusCode}');

        Go.back(Get!.context);
        onIndexChanged(1);
        showMessage(Get.context,
            title: "Task created successfully".tr, color: Colors.green);

        getAllTask(Get.context,
            observerId: isAssigned == 2 ? _userId : "",
            responsibleId: isAssigned == 0 ? _userId : "",
            ownerId: isAssigned == 1 ? _userId : "");
      } else {
        showMessage(Get.context, title: "Failed to create task".tr);
        throw Exception('Failed to create task: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error while creating task: $e');
    } finally {
      isLoadingCreate = false;
      update();
    }
  }

  // Fetch all missions
  Future<void> getAllTask(
    context, {
    responsibleId = "",
    observerId = "",
    ownerId = "",
  }) async {
    final uri = Uri.parse('${Endpoint.apiTask}').replace(
      queryParameters: {
        // 'offset': offset.toString(), // Add offset
        // 'limit': limit.toString(), // Add limit

        if (responsibleId != "") ...{'responsibleId': responsibleId},
        if (observerId != "") ...{'observerId': observerId},
        if (ownerId != "") ...{'ownerId': ownerId},
      },
    );

    isLoading = true;
    update();
    try {
      tasks!.clear();
      update();
      news = 0;
      update();
      canceled = 0;
      update();

      closed = 0;
      update();

      start = 0;
      update();

      ownerRespond = 0;
      update();

      responsipleRespond = 0;
      update();

      responsibleColsed = 0;
      update();
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

        tasks!.forEach((element) {
          state(element.statusId!);
        });
        update();
      }
    } catch (e) {
      showMessage(context, title: 'Connection problem'.tr);
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> getTaskById(context, int taskId, {bool isLoding = false}) async {
    if (isLoding) {
      isLoadingProfilebutton = true;
      update();
    } else {
      isLoadingProfile = true;
      update();
    }
    task = null;
    update();
    final uri = Uri.parse('${Endpoint.apiTask}/$taskId');
    print("object");
    try {
      final response = await http.get(
        uri,
        headers: {"x-auth-token": token.read("token").toString()},
      ).timeout(const Duration(seconds: 50));
      print(response.body);

      if (response.statusCode == 200) {
        final responseData = ResponseHandler.processResponse(response);
        task = Task.fromJson(responseData);
        update();
      } else {
        showMessage(context, title: 'Error fetching Task data'.tr);
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

  List ListImage = [];
  List ListPDF = [];
  List ListExcel = [];
  cleanListImage() {
    ListImage = [];
    update();
  }

  cleanListPDF() {
    ListPDF = [];
    update();
  }

  cleanListExcel() {
    ListExcel = [];
    update();
  }

  Future downloadfile({
    required String taskId,
    required String taskItemId,
    required String attachmentId,
  }) async {
    try {
      voicedownloadLoading = true;
      update();

      final url = Uri.parse(
          '${Endpoint.apiTask}/$taskId/items/$taskItemId/attachments/$attachmentId');

      // Send the GET request to download the file
      final response = await http.get(
        url,
        headers: {"x-auth-token": token.read("token").toString()},
      );

      if (response.statusCode == 200) {
        final contentType = response.headers['content-type'];
        if (contentType != null) {
          print('Content-Type: $contentType');

          if (imgFileTypes.any((type) => contentType.contains(type))) {
            ListImage.add(response.bodyBytes);
          } else if (pdfFileTypes.any((type) => contentType.contains(type))) {
            ListPDF.add(response.bodyBytes);
          } else if (excelFileTypes.any((type) => contentType.contains(type))) {
            ListExcel.add(response.bodyBytes);
          }
        } else {
          print("Content-Type header is missing.");
        }
      } else {
        print("Failed to download file. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print('An error occurred during download: $e');
    } finally {
      voicedownloadLoading = false;
      update();
    }
  }

  int totalBytes = 0;
  int downloadselect = 0;

// Cache to store downloaded files and timestamps
  Future<Uint8List> downloadFileStream(
      {required String taskId,
      required String taskItemId,
      required String attachmentId,
      required int index,
      required bool isShow,
      required String name}) async {
    try {
      totalBytes = 0;
      update();
      voicedownloadLoading = true;
      update();
      downloadselect = index;
      update();
      // Generate a unique cache key for the file
      final String cacheKey = '$taskId-$taskItemId-$attachmentId';
      if (fileCache.containsKey(cacheKey)) {
        print("File retrieved from cache.");

        return fileCache[cacheKey]!['data'] as Uint8List;
      }
      final url = Uri.parse(
          '${Endpoint.apiTask}/$taskId/items/$taskItemId/attachments/$attachmentId');

      // Send the GET request to download the file using stream
      final client = http.Client();
      final request = await client.send(
        http.Request('GET', url)
          ..headers.addAll({
            "x-auth-token": token.read("token").toString(),
          }),
      );

      if (request.statusCode == 200) {
        final List<int> bytes = [];

        // Stream the response data
        await for (var chunk in request.stream) {
          bytes.addAll(chunk);
          totalBytes += chunk.length; // Add the size of the current chunk
          update();
          print(
              "Downloaded: $totalBytes bytes"); // Print the size after each chunk
        }

        // Cache the file with the download timestamp
        fileCache[cacheKey] = {
          'data': Uint8List.fromList(bytes),
          'timestamp': DateTime.now(),
        };
        await requestStoragePermissions();

        return Uint8List.fromList(bytes);
      } else {
        print("Failed to download file. Status code: ${request.statusCode}");
      }
    } catch (e) {
      print('An error occurred during download: $e');
    } finally {
      totalBytes = 0;
      update();
      voicedownloadLoading = false;
      update();
    }

    // Return an empty Uint8List in case of failure
    return Uint8List(0);
  }

// Helper function to get the file type based on file extension
  bool issend = false;
  Future<void> createItems({
    required String desc,
    required String taskId,
    List<String>? imgPaths,
    List<String>? excelPaths,
    List<String>? pdfPaths,
  }) async {
    issend = true;
    update();
    var headers = {
      'x-auth-token': token.read("token").toString(),
    };
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${Endpoint.apiTask}/$taskId/items'),
      );
      // Add description field
      request.fields.addAll({'desc': '$desc'});
      print(request.fields);
      // Add image files (if any)
      if (imgPaths != null) {
        for (var filePath in imgPaths) {
          request.files
              .add(await http.MultipartFile.fromPath('prImg', filePath));
        }
      }

      // Add PDF files (if any)
      if (pdfPaths != null) {
        for (var filePath in pdfPaths) {
          request.files
              .add(await http.MultipartFile.fromPath('prPdf', filePath));
        }
      }

      // Add Excel files (if any)
      if (excelPaths != null) {
        for (var filePath in excelPaths) {
          request.files
              .add(await http.MultipartFile.fromPath('prExcel', filePath));
        }
      }

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      print(response.statusCode);
      // Handle response
      print(await response.stream.bytesToString());
      if (response.statusCode == 200) {
        getTaskById(Get.context, int.parse(taskId));
      } else {
        showMessage(Get.context, title: "Failed to create task item".tr);
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Request failed: $e');
    } finally {}
    issend = false;
    update();
  }

  Future<void> updateTaskStatus({
    required int taskId,
    required int status,
  }) async {
    String _userId = Get.put(AuthController()).user!.id.toString();

    var url = Uri.parse('${Endpoint.apiTask}/$taskId/change-status/$status');
    var headers = {
      'x-auth-token': token.read("token").toString(),
    };

    var request = http.Request('PUT', url);
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 204) {
        getTaskById(Get.context, taskId);
        getAllTask(Get.context,
            observerId: isAssigned == 2 ? _userId : "",
            responsibleId: isAssigned == 0 ? _userId : "",
            ownerId: isAssigned == 1 ? _userId : "");
        String responseBody = await response.stream.bytesToString();
        print('Success: $responseBody');
      } else {
        getTaskById(Get.context, taskId);

        Logger().e(response.statusCode);
        showMessage(Get.context, title: "Failed to update task status".tr);

        print('Failed: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> deleteTask({
    required int taskId,
  }) async {
    String _userId = Get.put(AuthController()).user!.id.toString();

    var url = Uri.parse('${Endpoint.apiTask}/$taskId');
    var headers = {
      'x-auth-token': token.read("token").toString(),
    };

    var request = http.Request('DELETE', url);
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 204) {
        Get.back();
        getAllTask(Get.context,
            observerId: isAssigned == 2 ? _userId : "",
            responsibleId: isAssigned == 0 ? _userId : "",
            ownerId: isAssigned == 1 ? _userId : "");
        String responseBody = await response.stream.bytesToString();
        print('Success: $responseBody');
        showMessage(Get.context, title: "Task deleted successfully".tr);
      } else {
        getTaskById(Get.context, taskId);
        showMessage(Get.context, title: "Failed to update task status".tr);
        showMessage(Get.context,
            title: "Failed to update task status".tr, color: Colors.green);

        print('Failed: ${response.reasonPhrase}');
      }
    } catch (e) {
      showMessage(Get.context, title: "Failed to update task status".tr);

      print('Error: $e');
    }
  }

  Future<void> revertCancellation({
    required int taskId,
  }) async {
    String _userId = Get.put(AuthController()).user!.id.toString();

    var url = Uri.parse('${Endpoint.apiTask}/$taskId/revert-cancellation');
    var headers = {
      'x-auth-token': token.read("token").toString(),
    };

    var request = http.Request('PUT', url);
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 204) {
        getTaskById(Get.context, taskId);
        getAllTask(Get.context,
            observerId: isAssigned == 2 ? _userId : "",
            responsibleId: isAssigned == 0 ? _userId : "",
            ownerId: isAssigned == 1 ? _userId : "");
        String responseBody = await response.stream.bytesToString();
        print('Success: $responseBody');
      } else {
        getTaskById(Get.context, taskId);

        print('Failed: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
