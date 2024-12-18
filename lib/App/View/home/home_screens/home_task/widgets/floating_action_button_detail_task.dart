import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../Controller/auth/auth_controller.dart';
import '../../../../../Controller/home/Task/task_controller.dart';
import '../../../../../Model/task_models/task.dart';
import '../../../../../Service/Task/task_list_menu_helper.dart';
import '../../../../widgets/Buttons/buttonall.dart';
import 'task_card.dart';

SizedBox floatingActionButtonDetailTask(
    Task task, TaskController teskController) {
  Map<int, String> taskStatusEnumString = {
    1: 'New'.tr,
    2: 'Start'.tr,
    3: 'Owner Respond'.tr,
    4: 'Responsible Respond'.tr,
    5: 'Responsible close'.tr,
    6: 'Close'.tr,
    7: 'Canceled'.tr,
  };
  String getStatusLabelTask(int statusId) {
    return taskStatusEnumString[statusId] ?? 'Unknown Status'.tr;
  }

  return SizedBox(
    width: 190,
    child: Column(
      children: [
        Spacer(),
        if (Workflow().isCanShow(
                    getStatusLabelTask(task.statusId),
                    teskController.task!.ownerId ==
                        Get.put(AuthController()).user!.id,
                    (teskController.task!.responsibleId ==
                        Get.put(AuthController()).user!.id),
                    "Start") ==
                true &&
            teskController.task!.isStart != true)
          ButtonAll(
              color: Colors.green,
              function: () {
                teskController.updateTaskStatus(
                  taskId: task.id,
                  status: 2,
                );
              },
              title: 'Start'.tr),
        SizedBox(
          height: 10,
        ),
        if (Workflow().isCanShow(
                getStatusLabelTask(task.statusId),
                teskController.task!.ownerId ==
                    Get.put(AuthController()).user!.id,
                (teskController.task!.responsibleId ==
                    Get.put(AuthController()).user!.id),
                "Close") ==
            true)
          ButtonAll(
              color: Colors.green,
              function: () {
                teskController.updateTaskStatus(
                  taskId: task.id,
                  status: 6,
                );
              },
              title: 'Close'.tr),
        if (Workflow().isCanShow(
                getStatusLabelTask(task.statusId),
                teskController.task!.ownerId ==
                    Get.put(AuthController()).user!.id,
                (teskController.task!.responsibleId ==
                    Get.put(AuthController()).user!.id),
                'Responsible close') ==
            true)
          ButtonAll(
              color: Colors.green,
              function: () {
                teskController.updateTaskStatus(
                  taskId: task.id,
                  status: 5,
                );
              },
              title: 'Responsible close'.tr),
        SizedBox(
          height: 10,
        ),
        if ((Workflow().isCanShow(
                    getStatusLabelTask(task.statusId),
                    teskController.task!.ownerId ==
                        Get.put(AuthController()).user!.id,
                    (teskController.task!.responsibleId ==
                        Get.put(AuthController()).user!.id),
                    'Canceled') ==
                true &&
            teskController.task!.isStart != true))
          ButtonAll(
            function: () {
              teskController.updateTaskStatus(
                taskId: task.id,
                status: 7,
              );
            },
            title: 'Canceled'.tr,
            color: Colors.red,
          ),
        if (Workflow().isCanShow(
                getStatusLabelTask(task.statusId),
                teskController.task!.ownerId ==
                    Get.put(AuthController()).user!.id,
                (teskController.task!.responsibleId ==
                    Get.put(AuthController()).user!.id),
                'Revert cancellation') ==
            true)
          ButtonAll(
            function: () {
              teskController.revertCancellation(
                taskId: task.id,
              );
            },
            title: 'Revert cancellation'.tr,
            color: Colors.red,
          ),
      ],
    ),
  );
}
