import 'package:flutter/material.dart';

import '../../../../../../Controller/home/task_controller.dart';
import '../../../home_mission/widgets/getStatusLabel.dart';
import '../../widgets/getStatusColor.dart';
import '../../widgets/task_card.dart';

Container taskInformation(TaskController controller) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey)),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Task Information",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 1,
            width: double.maxFinite,
            color: Colors.grey.withOpacity(0.2),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Text(
                "Owner: ",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
              Text(
                controller.task!.ownerUsername!,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Text(
                "Responsible: ",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
              Text(
                controller.task!.responsibleUsername!,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Text(
                "Oobserver: ",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
              Text(
                controller.task!.observerUsername!,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 1,
            width: double.maxFinite,
            color: Colors.grey.withOpacity(0.2),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Text(
                "Status: ",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
              Text(
                getStatusLabelTask(controller.task!.statusId),
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: getStatusColortask(controller.task!.statusId)),
              )
            ],
          ),
        ],
      ),
    ),
  );
}
