import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/Buttons/buttonall.dart';

import '../../../../../Controller/home/Task/task_controller.dart';
import '../../../../../Model/task_models/task.dart';
import '../task_details/widgets/buildTaskHeader.dart';
import '../task_details/widgets/taskInformation.dart';

Padding infoTask(
    BuildContext context, Task task, TaskController teskController) {
  return Padding(
    padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Row(
        children: [
          Spacer(), 
          Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                  color: Get.put(TaskController()).task!.isStart ? Colors.green  : Colors.red,
                borderRadius: BorderRadius.circular(
                  180
                ),
            )),

            SizedBox(width: 10,)
        ],
      ) ,  
        buildTaskHeader(context, task),
        taskInformation(teskController),
        SizedBox(
          height: 10,
        ),
      ],
    ),
  );
}
