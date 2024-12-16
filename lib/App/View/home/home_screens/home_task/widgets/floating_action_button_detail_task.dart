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
            true)
          ButtonAll(
              color: Colors.green,
              function: () {
                teskController.updateTaskStatus(
                  taskId: task.id,
                  status: 2,
                );
              },
              title: 'Start'),
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
              title: 'Close'),
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
              title: 'Responsible close'),
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
            title: 'Canceled',
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
            title: 'Revert cancellation',
            color: Colors.red,
          ),
      ],
    ),
  );
}
