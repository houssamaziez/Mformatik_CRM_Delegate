
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/View/home/Widgets/status_button/widgets/closeStatus.dart';
import 'package:mformatic_crm_delegate/App/View/home/Widgets/status_button/widgets/newStatus.dart';
import 'package:mformatic_crm_delegate/App/View/home/Widgets/status_button/widgets/responsibleColsedStatus.dart';
import 'package:mformatic_crm_delegate/App/View/home/Widgets/status_button/widgets/startStatus.dart';

import '../../../../../Controller/home/Task/task_controller.dart';
import '../../../../../Util/Style/stylecontainer.dart';
import '../../../../widgets/flutter_spinkit.dart';
import 'canceledStatus.dart';
import 'ownerRespondeStatus.dart';
import 'responsipleRespondStatus.dart';

Expanded statuseTaskButton(
    BuildContext context, Color Function(int value) getSliderColor) {
  return Expanded(
      flex: 3,
      child: GetBuilder<TaskController>(
          init: TaskController(),
          builder: (taskController) {
            return taskController.isLoading == false
                ? Container(
                    decoration: StyleContainer.style1,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 5.0, right: 4, top: 8, bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Statistics Tasks".tr,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                          newStatus(context, taskController, getSliderColor),
                          closeStatus(context, taskController, getSliderColor),
                          startStatus(context, taskController, getSliderColor),
                          responsibleColsedStatus(
                              context, taskController, getSliderColor),
                          responsipleRespondStatus(
                              context, taskController, getSliderColor),
                          ownerRespondeStatus(
                              context, taskController, getSliderColor),
                          canceledStatus(
                              context, taskController, getSliderColor),
                        ],
                      ),
                    ),
                  )
                : Container(
                    decoration: StyleContainer.style1,
                    child: const Center(child: spinkit));
          }));
}
