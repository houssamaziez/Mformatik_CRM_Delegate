import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../Controller/home/Task/task_controller.dart';
import '../../../../../../Util/Date/formatDate.dart';
import '../../widgets/getStatusColor.dart';
import '../../widgets/task_card.dart';

Container taskInformation(TaskController controller) {
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

  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        if (controller.task!.owner != null)
          itemPerson(controller,
              imgPath: "owner (1).png",
              title: "Owner".tr,
              name: controller.task!.owner!.person!.firstName! +
                  " " +
                  controller.task!.owner!.person!.lastName!),
        SizedBox(
          height: 10,
        ),
        if (controller.task!.responsible != null)
          itemPerson(controller,
              imgPath: "manager.png",
              title: "Responsible".tr,
              name: controller.task!.responsible!.person!.firstName! +
                  " " +
                  controller.task!.responsible!.person!.lastName!),
        SizedBox(
          height: 10,
        ),
        if (controller.task!.observer != null)
          itemPerson(controller,
              imgPath: "political-party (1).png",
              title: "Observer".tr,
              name: controller.task!.observer!.person!.firstName! +
                  " " +
                  controller.task!.observer!.person!.lastName!),
        const SizedBox(
          height: 10,
        ),
        itemPerson(controller,
            imgPath: "loading.png",
            title: "Status".tr,
            colorssuptitle2: controller.task!.isStart
                ? const Color.fromARGB(255, 55, 255, 62)
                : Colors.grey,
            name2: controller.task!.isStart ? "Started".tr : "Not started".tr,
            colorBorder: getStatusColorTask(controller.task!.statusId),
            colorssuptitle: getStatusColorTask(controller.task!.statusId),
            name: getStatusLabelTask(controller.task!.statusId)),
        const SizedBox(
          height: 10,
        ),
        if (controller.task!.deadline != null)
          itemPerson(controller,
              imgPath: "time.png",
              title: "Deadline".tr,
              name2: timeUntilDeadline(controller.task!.deadline!.toLocal()),
              name: formatter.format(controller.task!.deadline!.toLocal())),
        const SizedBox(
          height: 10,
        ),
        itemPerson(controller,
            imgPath: "clipboard.png",
            title: "Create At".tr,
            name2: (Get.locale?.languageCode == 'en' ? '' : "ago".tr) +
                " " +
                timeDifference(controller.task!.createdAt!.toLocal()) +
                (Get.locale?.languageCode != 'en' ? '' : " " + "ago".tr) +
                " ",
            name: formatter.format(controller.task!.createdAt!.toLocal())),
      ],
    ),
  );
}

Container itemPerson(
  TaskController controller, {
  required String imgPath,
  required String title,
  required String name,
  String name2 = "",
  Color colorBorder = Colors.grey,
  Color colorssuptitle = Colors.grey,
  Color colorssuptitle2 = Colors.grey,
}) {
  return Container(
    width: double.maxFinite,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: colorBorder),
    ),
    child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                "assets/icons/$imgPath",
                height: 35,
              )),
        ),
        title == 'Label'
            ? Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      name,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: colorssuptitle),
                    )
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    name,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: colorssuptitle),
                  )
                ],
              ),
        if (name2.isNotEmpty) Spacer(),
        if (name2.isNotEmpty)
          Text(
            name2,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: colorssuptitle2),
          ),
        SizedBox(
          width: 10,
        )
      ],
    ),
  );
}
