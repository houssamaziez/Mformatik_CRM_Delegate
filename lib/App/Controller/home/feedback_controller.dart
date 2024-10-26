import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/company_controller.dart';
import 'dart:convert';

import '../../Model/feedback.dart';
import '../../RouteEndPoint/EndPoint.dart';
import '../auth/auth_controller.dart';

class FeedbackController extends GetxController {
  RxList<FeedbackMission> feedbacks = <FeedbackMission>[].obs;
  FeedbackMission? feedbackprofile;
  var isLoading = false.obs;
  var isLoadingprofile = false;
  var isLoadingadd = false;
  var offset = 0.obs;
  final int limit = 10;

  late ScrollController scrollController;

  @override
  void onInit() {
    super.onInit();
    // final controller = Get.put(CompanyController());

    // fetchFeedbacks(controller.selectCompany!.id
    //     .toString()); // Replace with actual company ID
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      addOffset(
          Get.put(CompanyController()).selectCompany!.id.toString(),
          Get.put(AuthController())
              .user!
              .id
              .toString()); // Fetch more when reaching the end
    }
  }

  Future<void> fetchFeedbacks(String companyId, String creatorId,
      {bool isreafrach = false}) async {
    // if (isLoading.value && feedbacks.isNotEmpty) return;
    isLoading(true);
    print("object");
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
            'creatorId': creatorId
          },
        ),
        headers: {"x-auth-token": token.read("token").toString()},
      );
      print(response.body);
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
      print('Error: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> addOffset(String companyId, String creatorId) async {
    // if (isLoading.value && feedbacks.isNotEmpty) return;
    // isLoading(true);
    print("object");
    try {
      final response = await http.get(
        Uri.parse(Endpoint.apiFeedbacks).replace(
          queryParameters: {
            'companyId': companyId,
            'offset': offset.value.toString(),
            'limit': limit.toString(),
            'creatorId': creatorId
          },
        ),
        headers: {"x-auth-token": token.read("token").toString()},
      );
      print(response.body);
      if (response.statusCode == 200) {
        List<dynamic> responseData = json.decode(response.body)['rows'];
        if (responseData.isNotEmpty) {
          feedbacks.addAll(responseData
              .map((data) => FeedbackMission.fromJson(data))
              .toList());
          offset.value += limit;
        }
      } else {
        throw Exception('Failed to load feedbacks');
      }
    } catch (e) {
      offset.value == offset.value - limit;

      print('Error: $e');
    } finally {
      // isLoading(false);
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

  Future<void> addFeedback({
    required String label,
    required String desc,
    String? lat,
    String? lng,
    String? requestDate,
    required int clientId,
    required int missionId,
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
      request.fields['missionId'] = missionId.toString();
      request.fields['feedbackModelId'] = feedbackModelId.toString();

      // // Add images if they are provided
      // if (images != null) {
      //   for (var image in images) {
      //     request.files.add(await http.MultipartFile.fromPath(
      //       'img', // Change to the correct field name expected by your API
      //       image.path,
      //     ));
      //   }
      // }
      var response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
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

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
