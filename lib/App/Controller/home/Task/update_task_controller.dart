import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mformatic_crm_delegate/App/Controller/home/Task/task_controller.dart';
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/showsnack.dart';
import '../../../RouteEndPoint/EndPoint.dart';
import '../../auth/auth_controller.dart';

class UpdateTaskController extends GetxController {
  bool isLoading = false;
  updateTask(
      {required String label,
      required int responsibleId,
      required int taskID,
      required String deadline,
      required int observerId}) async {
    final _body = jsonEncode({
      if (label.isNotEmpty && label != null && label != "") ...{
        "label": label.toString()
      },
      "deadline": deadline == "" ? null.toString() : deadline.toString(),
      if (responsibleId != null) ...{"responsibleId": responsibleId.toString()},
      "observerId": observerId == 0 ? null.toString() : observerId.toString()
    });

    // print(_body);
    // return;
    try {
      isLoading = true;
      update();
      var headers = {
        'x-auth-token': token.read("token").toString(),
      };
      print(deadline);
      final response = await http.put(
          Uri.parse(
            '${Endpoint.apiTask}/$taskID',
          ),
          headers: headers,
          body: _body);
      if (kDebugMode) {
        print("___________________________________");
      }
      print("___________________________________");

      if (response.statusCode == 204) {
        showMessage(Get.context,
            title: 'Task updated successfully'.tr, color: Colors.green);

        Get.put(TaskController()).getTaskById(Get.context, taskID);
        Go.back(Get.context);
      } else {
        showMessage(Get.context,
            title: 'Error updating task'.tr, color: Colors.red);
      }
    } catch (e) {
      print("Error updating task: $e");
    } finally {
      isLoading = false;
      update();
    }
  }
}
