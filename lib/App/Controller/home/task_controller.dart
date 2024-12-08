import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/company_controller.dart';
import 'package:mformatic_crm_delegate/App/Model/task.dart';
import 'package:mformatic_crm_delegate/App/RouteEndPoint/EndPoint.dart';
import 'package:http/http.dart' as http;
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';
import 'package:mformatic_crm_delegate/App/View/home/home.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../Model/mission.dart';
import '../../Util/app_exceptions/response_handler.dart';
import '../../Util/extention/file.dart';
import '../../View/home/home_screens/home_task/task_details/ShowPDFs.dart';
import '../../View/widgets/showsnack.dart';
import '../auth/auth_controller.dart';
import '../widgetsController/expandable_controller.dart';

final Map<String, Map<String, dynamic>> fileCache = {};

class TaskController extends GetxController {
  List<Task>? tasks = [];
  Task? task;
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

        Go.back(Get!.context);
        showMessage(Get.context,
            title: "Task created successfully", color: Colors.green);
        getAllTask(Get.context);
      } else {
        showMessage(Get.context, title: "Failed to create task");
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
      queryParameters: {
        'offset': offset.toString(), // Add offset
        'limit': limit.toString(), // Add limit
      },
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
        await getTaskById(Get.context, missionId, isLoding: true);
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

  Future<void> getTaskById(context, int taskId, {bool isLoding = false}) async {
    if (isLoding) {
      isLoadingProfilebutton = true;
      update();
    } else {
      isLoadingProfile = true;
      update();
    }

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

  List<File>? files;
  bool voicedownloadLoading = false;
  String? pahtFile;
  Future downloadfile({
    required String taskId,
    required String taskItemId,
    required String attachmentId,
  }) async {
    try {
      voicedownloadLoading = true;
      update();

      final url = Uri.parse(
          'http://192.168.2.102:5500/api/v1/tasks/$taskId/items/$taskItemId/attachments/$attachmentId');

      // Send the GET request to download the file
      final response = await http.get(
        url,
        headers: {"x-auth-token": token.read("token").toString()},
      );

      if (response.statusCode == 200) {
        // Extract content type from headers
        final contentType = response.headers['content-type'];
        if (contentType != null) {
          print('Content-Type: $contentType');

          if (imgFileTypes.any((type) => contentType.contains(type))) {
            ListImage.add(response.bodyBytes);
            print("The file is an image.");
          } else if (voiceFileTypes.any((type) => contentType.contains(type))) {
            print("The file is a voice file.");
          } else if (videoFileTypes.any((type) => contentType.contains(type))) {
            print("The file is a video.");
          } else if (pdfFileTypes.any((type) => contentType.contains(type))) {
            ListPDF.add(response.bodyBytes);
            print("The file is a PDF.");
          } else if (excelFileTypes.any((type) => contentType.contains(type))) {
            ListExcel.add(response.bodyBytes);
            print("The file is an Excel document.");
          } else {
            print("Unknown file type.");
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

  int totalBytes = 0; // Variable to track the total downloaded size
  int downloadselect = 0; // Variable to track the total downloaded size

// Cache to store downloaded files and timestamps
  Future<Uint8List> downloadFileStream(
      {required String taskId,
      required String taskItemId,
      required String attachmentId,
      required int index,
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

      final url = Uri.parse(
          'http://192.168.2.102:5500/api/v1/tasks/$taskId/items/$taskItemId/attachments/$attachmentId');

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

        // Request storage permissions before saving the file
        await _requestStoragePermissions();

        // Save the file to the Downloads folder
        await saveFile(Uint8List.fromList(bytes), name);

        print("Download complete. Total size: $totalBytes bytes");
        return Uint8List.fromList(bytes);
      } else {
        print("Failed to download file. Status code: ${request.statusCode}");
      }
    } catch (e) {
      print('An error occurred during download: $e');
    } finally {
      voicedownloadLoading = false;
      update();
    }

    // Return an empty Uint8List in case of failure
    return Uint8List(0);
  }

  Future<void> _requestStoragePermissions() async {
    // Requesting the necessary permission for Android
    if (Platform.isAndroid) {
      PermissionStatus status = await Permission.storage.request();
      if (!status.isGranted) {
        // If permission is not granted, you can show a message or handle it
        print("Storage permission not granted.");
      }
    }
  }

  Future<void> saveFile(Uint8List fileBytes, String name) async {
    try {
      // Get the directory where you want to save the file
      final directory =
          await getExternalStorageDirectory(); // Get external storage directory
      if (directory == null) {
        print("Directory not found!");
        return;
      }

      // Define initial directory path (you can set it to any desired folder)
      final dirInstance = Directory(directory.path);
      final fileName =
          "$name-${DateTime.now().millisecondsSinceEpoch}.pdf"; // Modify as needed

      // Show the file picker to save the file
      final result = await FilePicker.platform.saveFile(
        bytes: fileBytes,
        type: FileType.any, // Set the file type
        initialDirectory: dirInstance.path, // Directory to start file picker
        fileName: fileName, // Name of the file
      );

      if (result != null) {
        print("File saved at: $result");
      } else {
        print("No file was saved.");
      }
    } catch (e) {
      print("Error saving file: $e");
    }
  }

  DateTime? getDownloadTimestamp({
    required String taskId,
    required String taskItemId,
    required String attachmentId,
  }) {
    final String cacheKey = '$taskId-$taskItemId-$attachmentId';
    return fileCache[cacheKey]?['timestamp'] as DateTime?;
  }
  // Get the download timestamp for a specific file
}
