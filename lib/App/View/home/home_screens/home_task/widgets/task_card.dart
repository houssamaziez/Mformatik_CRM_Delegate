import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:mformatic_crm_delegate/App/Model/task_models/task.dart';
import 'package:mformatic_crm_delegate/App/Util/Date/formatDate.dart';
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/stylecontainer.dart';

import '../task_details/details_task.dart';
import 'getStatusColor.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  const TaskCard({Key? key, required this.task, required this.index})
      : super(key: key);
  final int index;

  @override
  Widget build(BuildContext context) {
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

    return InkWell(
      onTap: () {
        Go.to(
          context,
          TaskProfileScreen(taskId: task.id),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 10),
        child: Container(
          decoration: StyleContainer.style1,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "${(index + 1)}- " + task.label!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          if (task.isStart == true)
                            Icon(
                              Icons.flag_circle_outlined,
                              size: 18,
                              color: const Color.fromARGB(255, 22, 255, 29),
                            ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),

                          Row(
                            children: [
                              Icon(Icons.person,
                                  color: Color.fromARGB(255, 37, 37, 37),
                                  size: 18),
                              const SizedBox(width: 4),
                              Text(
                                'Created by:'.tr + " ${task.ownerUsername}",
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 37, 37, 37),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          // Display status with updated design
                          Row(
                            children: [
                              Icon(Icons.circle,
                                  color: getStatusColorTask(task.statusId!),
                                  size: 14),
                              const SizedBox(width: 4),
                              Text(
                                'Status'.tr +
                                    " : ${getStatusLabelTask(task.statusId!)}",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: getStatusColorTask(task.statusId!),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),

                          Row(
                            children: [
                              Icon(Icons.person_pin,
                                  color: Colors.black, size: 18),
                              const SizedBox(width: 4),
                              Text(
                                "Responsible:".tr +
                                    " ${task.responsibleUsername}",
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 37, 37, 37),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),

                          Row(
                            children: [
                              Icon(Icons.date_range,
                                  color: Color.fromARGB(255, 37, 37, 37),
                                  size: 18),
                              const SizedBox(width: 4),
                              Text(
                                "Date".tr +
                                    ": ${formatDate(task.createdAt.toString())}",
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 37, 37, 37),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),

                          Row(
                            children: [
                              Icon(Icons.date_range,
                                  color: Colors.black, size: 18),
                              const SizedBox(width: 4),
                              Text(
                                "Updated Date :".tr +
                                    "${formatDate(task.updatedAt.toString())}",
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 37, 37, 37),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Enum-like map for task statuses

