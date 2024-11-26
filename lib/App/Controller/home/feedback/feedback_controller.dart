import 'dart:io';

// import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/company_controller.dart';
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/showsnack.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

import '../../../Model/feedback.dart';
import '../../../RouteEndPoint/EndPoint.dart';
import '../../../Service/Location/get_location.dart';
import '../../auth/auth_controller.dart';
import '../../widgetsController/expandable_controller.dart';
import '../missions_controller.dart';

class FeedbackController extends GetxController {
  RxList<FeedbackMission> feedbacks = <FeedbackMission>[].obs;
  FeedbackMission? feedbackprofile;
  var isLoading = false.obs;
  var isLoadingoffset = false.obs;
  var isLoadingprofile = false;
  var isLoadingadd = false;
  var offset = 0.obs;
  final int limit = 10;
  int feedbacksWithMission = 0;
  int feedbacksWithOutMission = 0;
  int feedbackslength = 0;

  Future<void> fetchFeedbacks(String companyId, String creatorId,
      {bool isreafrach = true,
      String? startingDate = "",
      String? endingDate = "",
      bool? isItLinkedToAMission}) async {
    feedbacksWithMission = 0;
    feedbacksWithOutMission = 0;
    feedbackslength = 0;
    feedbacks.clear();
    isLoading(true);
    update();

    if (isreafrach) {
      offset.value = 0;
      feedbacks.clear();
    }
    if (companyId == 0) {
      return;
    }
    try {
      final response = await http.get(
        Uri.parse(Endpoint.apiFeedbacks).replace(
          queryParameters: {
            'companyId': companyId,
            'offset': offset.value.toString(),
            'limit': limit.toString(),
            'creatorId': Get.put(AuthController()).user!.id.toString(),
            if (startingDate!.isNotEmpty) ...{'startDate': startingDate},
            if (isItLinkedToAMission != null) ...{
              'isItLinkedToAMission': isItLinkedToAMission
            },
            if (endingDate!.isNotEmpty) ...{'endDate': endingDate},
          },
        ),
        headers: {"x-auth-token": token.read("token").toString()},
      );
      offset.value = 10;

      if (response.statusCode == 200) {
        List<dynamic> responseData = json.decode(response.body)['rows'];
        update();
        if (responseData.isNotEmpty) {
          feedbacks.addAll(responseData
              .map((data) => FeedbackMission.fromJson(data))
              .toList());
          update();
          final responseCounts = await http.get(
            Uri.parse("${Endpoint.apiFeedbacksCounts}?companyId=$companyId"),
            headers: {"x-auth-token": token.read("token").toString()},
          );
          print(responseCounts.body);
          if (responseCounts.statusCode == 200) {
            feedbacksWithMission =
                jsonDecode(responseCounts.body)["feedbacksWithMission"];
            update();

            feedbacksWithOutMission =
                jsonDecode(responseCounts.body)["feedbacksWithOutMission"];
            feedbackslength = feedbacksWithOutMission + feedbacksWithMission;
            update();
          }
        }
        throw Exception('Failed to load feedbacks');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading(false);
      update();
    }
  }

  Future<void> addOffset(String companyId, String creatorId,
      {String? startingDate = "",
      String? endingDate = "",
      bool? isItLinkedToAMission}) async {
    isLoadingoffset(true);
    update();
    try {
      final response = await http.get(
        Uri.parse(Endpoint.apiFeedbacks).replace(
          queryParameters: {
            'companyId': companyId,
            'offset': offset.value.toString(),
            'limit': limit.toString(),
            'creatorId': creatorId,
            if (isItLinkedToAMission != null) ...{
              'isItLinkedToAMission': isItLinkedToAMission
            },
            if (startingDate!.isNotEmpty) ...{'startDate': startingDate},
            if (endingDate!.isNotEmpty) ...{'endDate': endingDate},
          },
        ),
        headers: {"x-auth-token": token.read("token").toString()},
      );
      if (response.statusCode == 200) {
        List<dynamic> responseData = json.decode(response.body)['rows'];
        if (responseData.isNotEmpty) {
          feedbacks.addAll(responseData
              .map((data) => FeedbackMission.fromJson(data))
              .toList());
          update();
          offset.value += limit;
        }
      } else {
        throw Exception('Failed to load feedbacks');
      }
    } catch (e) {
      offset.value == offset.value - limit;
      print('Error: $e');
    } finally {
      isLoadingoffset(false);
      update();
    }
  }

  getFeedbackById(String feedbackId) async {
    isLoadingprofile = true;
    update();
    try {
      final response = await http.get(
        Uri.parse(
            '${Endpoint.apiFeedbacks}/$feedbackId'), // Adjust the endpoint as needed
        headers: {"x-auth-token": token.read("token").toString()},
      );
      print(response.statusCode);
      if (response.statusCode == 404) {
        feedbackprofile = null;
        update();
        return;
      }
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        print(data);
        feedbackprofile =
            FeedbackMission.fromJson(data); // Return the feedback object
        update();
        file = null;
        update();
        pahtFile = null;
        update();
        if (feedbackprofile!.voice != null) {
          downloadFeedbackVoice(feedbackId);
        }
        print(feedbackprofile);
      } else {
        throw Exception('Failed to load feedback');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoadingprofile = false;
      update();
    }
  }

  upadteisloading(bool valu) {
    isLoadingadd = valu;
    update();
  }

  updateIsLoading(value) {
    isLoadingadd = value;
    update();
  }

  Future<void> addFeedback({
    required String label,
    required String desc,
    String? lat,
    String? lng,
    String? requestDate,
    required int clientId,
    int? missionId,
    required int feedbackModelId,
    List<XFile>? images,
    String? path,
  }) async {
    XFile? voice;
    if (path!.isNotEmpty) {
      voice = XFile(path);
    }
    isLoadingadd = true;
    update();

    try {
      String? mp3FilePath;
      print(voice);
      if (voice != null) {
        mp3FilePath = "${voice!.path}";
        print(mp3FilePath);
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(Endpoint.apiFeedbacks), // Adjust the endpoint as needed
      );

      request.headers['x-auth-token'] = token.read("token").toString();
      print(feedbackModelId);

      if (feedbackModelId == 1) {
        print(feedbackModelId);
        if (label.isEmpty || label.length <= 2) {
          showMessage(Get.context, title: 'Please specify'.tr);
          return;
        }
      }
      request.fields['label'] = label;

      request.fields['desc'] = desc;
      if (lat != null) request.fields['lat'] = lat;
      if (lng != null) request.fields['lng'] = lng;
      if (requestDate != null) request.fields['requestDate'] = requestDate;
      request.fields['clientId'] = clientId.toString();
      if (missionId != null) {
        request.fields['missionId'] = missionId.toString();
      }
      request.fields['feedbackModelId'] = feedbackModelId.toString();

      // Add images if they are provided
      if (images != null) {
        for (var image in images) {
          request.files.add(await http.MultipartFile.fromPath(
            'img', // Change to the correct field name expected by your API
            image.path,
          ));
        }
      }
      if (voice != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'voice', // Change to the correct field name expected by your API
          mp3FilePath!,
        ));
      }
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      print(responseBody);
      if (response.statusCode == 406) {
        showMessage(Get.context,
            title: "A mission can only have one associated feedback entry.".tr);
      }
      if (response.statusCode == 200) {
        Get.back();
        Get.back();
        fetchFeedbacks(
            Get.put(CompanyController()).selectCompany!.id.toString(),
            Get.put(AuthController()).user!.id.toStringAsExponential());
        if (missionId != null) {
          await Get.put(MissionsController())
              .changeStatuseMission(3, missionId!);
        }
        showMessage(Get.context,
            title: 'Feedback added successfully'.tr, color: Colors.green);

        print('Feedback added successfully');
      } else {
        throw Exception('Failed to add feedback');
      }
    } catch (e) {
      showMessage(Get.context, title: 'Connection problem'.tr);

      print('Error: $e');
    } finally {
      isLoadingadd = false;
      update();
    }
  }

  Future<void> updateFeedbacks({
    required String feedbackId,
    required String lastLabel,
    required String Label,
    required String desc,
    required String lat,
    required String lng,
    String? requestDate,
    required int creatorId,
    required int clientId,
    required List<XFile>? imagesAdd,
    required int feedbackModelId,
    required List<dynamic> images,
    required int beforimages,
  }) async {
    isLoadingadd = true;
    update();

    try {
      // Check location permissions
      var location = await LocationService.getCurrentLocation(Get.context);
      if (!location.isPermissionGranted) {
        return;
      }

      // Get feedback model filter logic
      ExpandableControllerFeedback expandableControllerFeedback =
          Get.put(ExpandableControllerFeedback());
      String feedbackModelFilter = '0';
      if (expandableControllerFeedback.selectedItem.value == null) {
        feedbackModelFilter =
            (lastLabel == Label) ? feedbackModelId.toString() : "1";
      } else {
        feedbackModelFilter =
            expandableControllerFeedback.selectedItem.value!.id.toString();
      }

      if (feedbackModelFilter == "1" &&
          (lastLabel.isEmpty || lastLabel.length <= 2)) {
        showMessage(Get.context, title: 'Please specify'.tr);
        return;
      }

      // Prepare gallery field
      final List<Map<String, String>> imagpath = images
          .map((img) =>
              {"id": img["id"].toString(), "path": img["path"].toString()})
          .toList();

      // Construct API request
      final url = Uri.parse('${Endpoint.apiFeedbacks}/$feedbackId');
      var request = http.MultipartRequest('PUT', url);
      request.headers['x-auth-token'] = token.read("token").toString();

      // Add fields
      request.fields.addAll({
        'label': lastLabel,
        'desc': desc,
        'lat': lat,
        'lng': lng,
        'requestDate': requestDate ?? '',
        'feedbackModelId': feedbackModelFilter,
      });
      if (images.isEmpty) {
        request.fields.addAll({'gallery[]': ''});
      }
      if (images.length != beforimages) {
        for (var i = 0; i < imagpath.length; i++) {
          request.fields['gallery[$i][id]'] = imagpath[i]['id']!;
          request.fields['gallery[$i][path]'] = imagpath[i]['path']!;
        }
      }

      if (imagesAdd != null) {
        for (var image in imagesAdd) {
          request.files
              .add(await http.MultipartFile.fromPath('img', image.path));
        }
      }

      var response = await request.send();
      final responseBody = await response.stream.bytesToString();

      // Handle response
      if (response.statusCode == 204) {
        fetchFeedbacks(
            Get.put(CompanyController()).selectCompany!.id.toString(),
            creatorId.toString());
        Go.back(Get.context);
        Go.back(Get.context);

        showMessage(
          Get.context,
          title: 'Feedback updated successfully'.tr,
          color: Colors.green,
        );
        print('Feedback updated successfully');
      } else {
        showMessage(
          Get.context,
          title: 'Failed to update feedback'.tr,
          color: Colors.orange,
        );
        print('Failed to update feedback: $responseBody');
      }
    } on SocketException catch (e) {
      showMessage(Get.context,
          title: 'No Internet Connection'.tr, color: Colors.red);
      print('Network error: $e');
    } catch (e) {
      showMessage(Get.context, title: 'Unexpected Error'.tr, color: Colors.red);
      print('Unexpected error: $e');
    } finally {
      isLoadingadd = false;
      update();
    }
  }

  // ___________________________________________________

  getVoiceById(String feedbackId) async {
    isLoadingprofile = true;
    update();
    try {
      final response = await http.get(
        Uri.parse(
            '${Endpoint.apiFeedbacks}/$feedbackId/voice'), // Adjust the endpoint as needed
        headers: {"x-auth-token": token.read("token").toString()},
      );
      print(response.statusCode);
      if (response.statusCode == 404) {
        feedbackprofile = null;
        update();
      }
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('object');
        print(data);
        feedbackprofile =
            FeedbackMission.fromJson(data); // Return the feedback object
        update();
        print(feedbackprofile);
      } else {
        throw Exception('Failed to load feedback');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoadingprofile = false;
      update();
    }
  }

  File? file;
  bool voicedownloadLoading = false;
  String? pahtFile;
  downloadFeedbackVoice(String feedbackId) async {
    file = null;
    update();
    pahtFile = null;
    update();

    try {
      voicedownloadLoading = true;
      update();

      final url = Uri.parse(
          '${Endpoint.apiFeedbacks}/$feedbackId/voice'); // Adjust the endpoint as needed

      // Send the GET request to download the file
      final response = await http.get(
        url,
        headers: {"x-auth-token": token.read("token").toString()},
      );

      print('HTTP Response Code: ${response.statusCode}');

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Get the application's document directory to save the file
        final directory = await getApplicationDocumentsDirectory();
        final filePath =
            '${directory.path}/feedback_voice_$feedbackId.mp3'; // Set the file path and name

        // Write the response body to a file
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        pahtFile = file.path;
        update();
        print('File saved to: ${file.path}');
      } else {
        print('Failed to download file. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred during download: $e');
    } finally {
      voicedownloadLoading = false;
      update();
    }
  }
}
