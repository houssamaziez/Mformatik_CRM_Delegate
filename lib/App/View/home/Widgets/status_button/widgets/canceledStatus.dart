
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/Style/style_text.dart';

import '../../../../../Controller/home/Task/task_controller.dart';
import '../../../../widgets/flutter_slider.dart';

InkWell canceledStatus(BuildContext context, TaskController taskController,
    Color getSliderColor(int value)) {
  return InkWell(
    onTap: () {
      // Go.to(context, MissionListScreenByReason(statusId: 4.toString()));
    },
    child: Column(
      children: [
        Row(
          children: [
            Text(
              "Canceled".tr + " ( ${taskController.canceled} )",
              style: const TextStyle(fontSize: 10),
            ),
            const Spacer(),
            taskController.canceled == 0
                ? 0.toString().style()
                : ((taskController.canceled * 100) / taskController.tasklength)
                    .toStringAsFixed(2)
                    .style(),
            "%".style(),
          ],
        ),
        SizedBox(
          height: 10,
          child: Row(
            children: [
              flutterSlider(
                  getSliderColor,
                  taskController.tasklength.toDouble(),
                  taskController.canceled.toDouble(),
                  Colors.red),
            ],
          ),
        ),
      ],
    ),
  );
}
