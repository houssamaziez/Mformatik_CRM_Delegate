import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/company_controller.dart';
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/showsnack.dart';
import 'dart:convert';

import '../../Model/feedback.dart';
import '../../RouteEndPoint/EndPoint.dart';
import '../../Service/Location/get_location.dart';
import '../auth/auth_controller.dart';
import '../widgetsController/expandable_controller.dart';
import 'missions_controller.dart';

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
      String? endingDate = ""}) async {
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

    try {
      final response = await http.get(
        Uri.parse(Endpoint.apiFeedbacks).replace(
          queryParameters: {
            'companyId': companyId,
            'offset': offset.value.toString(),
            'limit': limit.toString(),
            'creatorId': Get.put(AuthController()).user!.id.toString(),
            if (startingDate!.isNotEmpty) ...{'startDate': startingDate},
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
      {String? startingDate = "", String? endingDate = ""}) async {
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

  upadteisloading(bool valu) {
    isLoadingadd = valu;
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
  }) async {
    isLoadingadd = true;
    update();
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(Endpoint.apiFeedbacks), // Adjust the endpoint as needed
      );

      request.headers['x-auth-token'] = token.read("token").toString();

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
      var response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        Get.back();
        if (missionId != null) {
          await Get.put(MissionsController())
              .changeStatuseMission(3, missionId!);
        }
        showMessage(Get.context,
            title: 'Feedback added successfully'.tr, color: Colors.green);

        print('Feedback added successfully');
        // Optionally refresh the feedbacks list or perform other actions
      } else {
        throw Exception('Failed to add feedback');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoadingadd = false;
      update();
    }
  }

  Future<void> updateFeedbacks(
      {required String feedbackId,
      required String lastLabel,
      required String Label,
      required String desc,
      String? lat,
      String? lng,
      String? requestDate,
      required int creatorId,
      required int clientId,
      required List<XFile>? imagesAdd,
      required int feedbackModelId,
      required List<dynamic> images}) async {
    isLoadingadd = true;
    update();
    var location = await LocationService.getCurrentLocation(Get.context);
    if (!location.isPermissionGranted) {
      return;
    }
    ExpandableControllerFeedback expandableControllerFeedback =
        Get.put(ExpandableControllerFeedback());
    // Indicate loading state

    try {
      // return;

      final url =
          Uri.parse('${Endpoint.apiFeedbacks}/$feedbackId'); // Endpoint URL

      String feedbackModelFilter = '0';

      if (expandableControllerFeedback.selectedItem.value.isNull == true) {
        if (lastLabel == Label) {
          feedbackModelFilter = feedbackModelId.toString();
        } else {
          feedbackModelFilter = "1".toString();
        }
        update();
      } else {
        feedbackModelFilter =
            expandableControllerFeedback.selectedItem.value!.id.toString();
        update();
      }

      final List imagpath = [];
      for (var i = 0; i < images.length; i++) {
        // print(images[i]["id"]);
        for (var i = 0; i < images.length; i++) {
          imagpath.add({
            "id": images[i]["id"].toString(),
            "path": images[i]["id"].toString()
          });
        }
      }
      Map<String, Object?> map = {
        'label': lastLabel,
        'desc': desc,
        'lat': lat,
        'lng': lng,
        'requestDate': requestDate,
        // 'clientId': clientId,
        'feedbackModelId': feedbackModelFilter,
        'gallery': imagpath,
      };
      print(map);
      // return;

      final response = await http.put(
        url,
        headers: {
          'x-auth-token': token.read("token").toString(),
          'Content-Type': 'application/json',
        },
        body: jsonEncode(map),
      );
      print(response.body);
      if (imagesAdd!.isNotEmpty) {
        await updateFeedbackImage(
            feedbackId: feedbackId,
            lastLabel: lastLabel,
            label: lastLabel,
            desc: desc,
            creatorId: creatorId,
            clientId: clientId,
            feedbackModelId: feedbackModelId,
            imagesAdd: imagesAdd,
            images: images);
      }

      // Handle response based on status code
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
        print('Failed to update feedback: ${response.body}');
      }
    } on SocketException catch (e) {
      // Handle network-related errors
      showMessage(
        Get.context,
        title: 'No Internet Connection'.tr,
        color: Colors.red,
      );
      print('Network error: $e');
    } catch (e) {
      // Handle other types of errors
      showMessage(
        Get.context,
        title: 'No Internet Connection'.tr,
        color: Colors.red,
      );
      print('Unexpected error: $e');
    } finally {
      // Reset loading state
      isLoadingadd = false;
      update();
    }
  }

  Future<void> updateFeedbackImage({
    required String feedbackId,
    required String lastLabel,
    required String label,
    required String desc,
    String? lat,
    String? lng,
    String? requestDate,
    required int creatorId,
    required int clientId,
    required int feedbackModelId,
    required List<XFile>? imagesAdd,
    required List<dynamic> images,
  }) async {
    try {
      final url =
          Uri.parse('${Endpoint.apiFeedbacks}/$feedbackId'); // Endpoint URL

      Map<String, dynamic> fields = {
        'label': lastLabel,
        'desc': desc,
        'lat': lat ?? '',
        'lng': lng ?? '',
        // "gallery": jsonEncode(imagpath), // Encode as JSON if needed
        // 'requestDate': requestDate ?? '',
        'feedbackModelId': feedbackModelId,
      };

      var request = http.MultipartRequest('PUT', url);
      request.headers['x-auth-token'] = token.read("token").toString();

      fields.forEach((key, value) {
        request.fields[key] = value.toString(); // Ensure all values are strings
      });

      // Debugging output for images
      if (imagesAdd != null) {
        for (var image in imagesAdd) {
          print("Adding image: ${image.path}"); // Debugging output
          request.files.add(await http.MultipartFile.fromPath(
            'img', // Change this to the correct field name expected by your API
            image.path,
          ));
        }
      }
      var response = await request.send();

      // Send the request and handle response
      print("Response status code: ${response.statusCode}"); // Debugging output
      final responseBody = await response.stream.bytesToString();
      print("Response body: $responseBody"); // Debugging output

      // Check the response status
      if (response.statusCode == 204) {
        // fetchFeedbacks(
        //     Get.put(CompanyController()).selectCompany!.id.toString(),
        //     creatorId.toString());
        // showMessage(Get.context,
        //     title: 'Feedback updated successfully', color: Colors.green);
        print('Feedback updated successfully');
      } else {
        // showMessage(Get.context,
        //     title: 'Failed to update feedback', color: Colors.orange);
        print('Failed to update feedback: $responseBody');
      }
    } on SocketException catch (e) {
      // showMessage(Get.context,
      //     title: 'No Internet Connection', color: Colors.red);
      print('Network error: $e');
    } catch (e) {
      // showMessage(Get.context, title: 'Unexpected Error', color: Colors.red);
      print('Unexpected error: $e');
    } finally {}
  }
}
