import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/company_controller.dart';
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/showsnack.dart';
import 'dart:convert';

import '../../../Model/feedback.dart';
import '../../../RouteEndPoint/EndPoint.dart';
import '../../../Service/Location/get_location.dart';
import '../../auth/auth_controller.dart';
import '../../widgetsController/expandable_controller.dart';
import '../missions_controller.dart';

class FeedbackControllerFilter extends GetxController {
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
              'isItLinkedToAMission': isItLinkedToAMission.toString()
            },
            if (endingDate!.isNotEmpty) ...{'endDate': endingDate},
          },
        ),
        headers: {"x-auth-token": token.read("token").toString()},
      );
      offset.value = 10;

      print(
          "------------------------------------------------------------------------");
      print(json.decode(response.body)['rows']);
      print(
          "------------------------------------------------------------------------");
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
              'isItLinkedToAMission': isItLinkedToAMission.toString()
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

  upadteisloading(bool valu) {
    isLoadingadd = valu;
    update();
  }

  updateIsLoading(value) {
    isLoadingadd = value;
    update();
  }
}
