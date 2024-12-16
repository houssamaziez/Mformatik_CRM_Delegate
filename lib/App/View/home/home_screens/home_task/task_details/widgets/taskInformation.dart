import 'package:flutter/material.dart';

import '../../../../../../Controller/home/Task/task_controller.dart';
import '../../../../../../Util/Date/formatDate.dart';
import '../../../home_mission/widgets/getStatusLabel.dart';
import '../../widgets/getStatusColor.dart';
import '../../widgets/task_card.dart';

Container taskInformation(TaskController controller) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // if (controller.task!.label != null)
        //   itemPerson(controller,
        //       imgPath: "product-development.png",
        //       title: "Label",
        //       name: controller.task!.label!),
        SizedBox(
          height: 10,
        ),
        if (controller.task!.owner != null)
          itemPerson(controller,
              imgPath: "owner (1).png",
              title: "Owner",
              name: controller.task!.owner!.person!.firstName! +
                  " " +
                  controller.task!.owner!.person!.lastName!),
        SizedBox(
          height: 10,
        ),
        if (controller.task!.responsible != null)
          itemPerson(controller,
              imgPath: "manager.png",
              title: "Responsible",
              name: controller.task!.responsible!.person!.firstName! +
                  " " +
                  controller.task!.responsible!.person!.lastName!),
        SizedBox(
          height: 10,
        ),
        if (controller.task!.observer != null)
          itemPerson(controller,
              imgPath: "political-party (1).png",
              title: "Observer",
              name: controller.task!.observer!.person!.firstName! +
                  " " +
                  controller.task!.observer!.person!.lastName!),
        const SizedBox(
          height: 10,
        ),
        itemPerson(controller,
            imgPath: "loading.png",
            title: "Status",
            colorssuptitle2: controller.task!.isStart
                ? const Color.fromARGB(255, 55, 255, 62)
                : Colors.grey,
            name2: controller.task!.isStart ? "Started" : "Not started",
            colorBorder: getStatusColorTask(controller.task!.statusId),
            colorssuptitle: getStatusColorTask(controller.task!.statusId),
            name: getStatusLabelTask(controller.task!.statusId)),
        const SizedBox(
          height: 10,
        ),
        if (controller.task!.deadline != null)
          itemPerson(controller,
              imgPath: "time.png",
              title: "Deadline",
              name2: timeUntilDeadline(controller.task!.deadline!.toLocal()),
              name: formatter.format(controller.task!.deadline!.toLocal())),
        const SizedBox(
          height: 10,
        ),
        itemPerson(controller,
            imgPath: "clipboard.png",
            title: "Create At",
            name2:
                timeDifference(controller.task!.createdAt!.toLocal()) + " ago",
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
