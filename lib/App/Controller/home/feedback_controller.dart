import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mformatic_crm_delegate/App/Controller/home/company_controller.dart';
import 'dart:convert';

import '../../Model/feedback.dart';
import '../../RouteEndPoint/EndPoint.dart';
import '../auth/auth_controller.dart';

class FeedbackController extends GetxController {
  var feedbacks = <FeedbackMission>[].obs;
  var isLoading = false.obs;
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

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
