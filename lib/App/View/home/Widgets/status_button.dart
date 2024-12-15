import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/Task/task_controller.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/feedback/feedback_controller.dart';
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/Style/style_text.dart';
import 'package:mformatic_crm_delegate/App/View/home/home_screens/home_feedback/feedback_filter/feedback_list_screen_filter.dart';
import 'package:mformatic_crm_delegate/App/View/home/home_screens/home_mission/mission_by_reasonId/mission_list_screen_by_reasonId.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';

import '../../../Controller/home/mission/missions_controller.dart';
import '../../../Util/Style/stylecontainer.dart';
import '../../widgets/Containers/container_blue.dart';
import '../../widgets/flutter_slider.dart';

/// A widget to display the percentage of completed, in progress and canceled missions in a given list of missions.
///
/// This widget is a child of [GetBuilder] and is initialized with a [MissionsController].
/// It displays a card with two sections: A header with the title "Statistics Missions" and a row with the number of missions,
/// and a body with a column of four rows:
/// - The first row displays the number of completed missions and the percentage of completed missions.
/// - The second row displays the number of in progress missions and the percentage of in progress missions.
/// - The third row displays the number of canceled missions and the percentage of canceled missions.
/// - The fourth row displays the number of created missions and the percentage of created missions.
///
/// The percentages are displayed as a slider with a color that changes based on the percentage.
/// The color of the slider is defined by the [getSliderColor] function.
///
/// This widget is used in the [HomeScreen] to display the statistics of the missions.
///
Expanded statuseMissionButton(
    BuildContext context, Color Function(int value) getSliderColor) {
  return Expanded(
      flex: 3,
      child: GetBuilder<MissionsController>(
          init: MissionsController(),
          builder: (missionsController) {
            return missionsController.isLoading == false
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
                                "Statistics Missions".tr,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                    fontSize: 12),
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  Go.to(
                                      context,
                                      MissionListScreenByReason(
                                          statusId: 1.toString()));
                                },
                                child: Text(
                                  "New".tr +
                                      "(" +
                                      missionsController.created.toString() +
                                      ")",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                              height: 24,
                              width: double.infinity,
                              child: containerwithblue(
                                context,
                                color: const Color.fromARGB(255, 199, 199, 199),
                                widget: Row(
                                  children: [
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Go.to(
                                            context,
                                            MissionListScreenByReason(
                                                statusId: 4.toString()));
                                      },
                                      child: Row(
                                        children: [
                                          const CircleAvatar(
                                            radius: 4,
                                            backgroundColor: Color(0XffD12525),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "Canceled".tr +
                                                " ${missionsController.canceled}",
                                            style:
                                                const TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    InkWell(
                                      onTap: () {
                                        Go.to(
                                            context,
                                            MissionListScreenByReason(
                                                statusId: 2.toString()));
                                      },
                                      child: Row(
                                        children: [
                                          const CircleAvatar(
                                            radius: 4,
                                            backgroundColor: Color(0XffE3A105),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "In Progress".tr +
                                                " ${missionsController.inProgress}",
                                            style:
                                                const TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    InkWell(
                                      onTap: () {
                                        Go.to(
                                            context,
                                            MissionListScreenByReason(
                                                statusId: 3.toString()));
                                      },
                                      child: Row(
                                        children: [
                                          const CircleAvatar(
                                            radius: 5,
                                            backgroundColor: Color(0Xff26931D),
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            "Completed".tr +
                                                " ${missionsController.completed} ",
                                            style:
                                                const TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              )),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            "Percentage".tr,
                            style: const TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 12),
                          ),
                          InkWell(
                            onTap: () {
                              Go.to(
                                  context,
                                  MissionListScreenByReason(
                                      statusId: 3.toString()));
                            },
                            child: SizedBox(
                              height: 24,
                              child: Row(
                                children: [
                                  flutterSlider(
                                      getSliderColor,
                                      missionsController.missionslength
                                          .toDouble(),
                                      missionsController.completed.toDouble(),
                                      Colors.green),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  missionsController.completed == 0
                                      ? 0.toString().style()
                                      : ((missionsController.completed * 100) /
                                              missionsController.missionslength)
                                          .toStringAsFixed(2)
                                          .style(),
                                  "%".style(),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Go.to(
                                  context,
                                  MissionListScreenByReason(
                                      statusId: 2.toString()));
                            },
                            child: SizedBox(
                              height: 24,
                              child: Row(
                                children: [
                                  flutterSlider(
                                      getSliderColor,
                                      missionsController.missionslength
                                          .toDouble(),
                                      missionsController.inProgress.toDouble(),
                                      Colors.orange),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  missionsController.inProgress == 0
                                      ? 0.toString().style()
                                      : ((missionsController.inProgress * 100) /
                                              missionsController.missionslength)
                                          .toStringAsFixed(2)
                                          .style(),
                                  "%".style(),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Go.to(
                                  context,
                                  MissionListScreenByReason(
                                      statusId: 4.toString()));
                            },
                            child: SizedBox(
                              height: 24,
                              child: Row(
                                children: [
                                  flutterSlider(
                                      getSliderColor,
                                      missionsController.missionslength
                                          .toDouble(),
                                      missionsController.canceled.toDouble(),
                                      Colors.red),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  missionsController.canceled == 0
                                      ? 0.toString().style()
                                      : ((missionsController.canceled * 100) /
                                              missionsController.missionslength)
                                          .toStringAsFixed(2)
                                          .style(),
                                  "%".style(),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Go.to(
                                  context,
                                  MissionListScreenByReason(
                                      statusId: 1.toString()));
                            },
                            child: SizedBox(
                              height: 24,
                              child: Row(
                                children: [
                                  flutterSlider(
                                      getSliderColor,
                                      missionsController.missionslength
                                          .toDouble(),
                                      missionsController.created.toDouble(),
                                      Theme.of(context).primaryColor),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  missionsController.created == 0
                                      ? 0.toString().style()
                                      : ((missionsController.created * 100) /
                                              missionsController.missionslength)
                                          .toStringAsFixed(2)
                                          .style(),
                                  "%".style(),
                                  // " ".style(),
                                  // "New".tr.style(
                                  //     fontSize: 10,
                                  //     color: Theme.of(context).primaryColor),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : Container(
                    decoration: StyleContainer.style1,
                    child: const Center(child: spinkit));
          }));
}

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

InkWell newStatus(BuildContext context, TaskController taskController,
    Color getSliderColor(int value)) {
  return InkWell(
    onTap: () {
      Go.to(context, MissionListScreenByReason(statusId: 1.toString()));
    },
    child: Column(
      children: [
        Row(
          children: [
            Text(
              "New".tr + " ( ${taskController.news} )",
              style: const TextStyle(fontSize: 10),
            ),
            Spacer(),
            taskController.news == 0
                ? 0.toString().style()
                : ((taskController.news * 100) / taskController.tasklength)
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
                  taskController.news.toDouble(),
                  Theme.of(context).primaryColor),
              const SizedBox(
                width: 5,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

InkWell canceledStatus(BuildContext context, TaskController taskController,
    Color getSliderColor(int value)) {
  return InkWell(
    onTap: () {
      Go.to(context, MissionListScreenByReason(statusId: 4.toString()));
    },
    child: Column(
      children: [
        Row(
          children: [
            Text(
              "Canceled".tr + " ( ${taskController.canceled} )",
              style: const TextStyle(fontSize: 10),
            ),
            Spacer(),
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

InkWell startStatus(BuildContext context, TaskController taskController,
    Color getSliderColor(int value)) {
  return InkWell(
    onTap: () {
      Go.to(context, MissionListScreenByReason(statusId: 2.toString()));
    },
    child: Column(
      children: [
        Row(
          children: [
            Text(
              "Start".tr + " ( ${taskController.start} )",
              style: const TextStyle(fontSize: 10),
            ),
            Spacer(),
            taskController.start == 0
                ? 0.toString().style()
                : ((taskController.start * 100) / taskController.tasklength)
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
                  taskController.start.toDouble(),
                  Colors.orange),
            ],
          ),
        ),
      ],
    ),
  );
}

InkWell closeStatus(BuildContext context, TaskController taskController,
    Color getSliderColor(int value)) {
  return InkWell(
    onTap: () {
      Go.to(context, MissionListScreenByReason(statusId: 3.toString()));
    },
    child: Column(
      children: [
        Row(
          children: [
            Text(
              "Closed".tr + " (  ${taskController.closed} )",
              style: const TextStyle(fontSize: 10),
            ),
            Spacer(),
            taskController.closed == 0
                ? 0.toString().style()
                : ((taskController.closed * 100) / taskController.tasklength)
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
                  taskController.closed.toDouble(),
                  Colors.greenAccent),
            ],
          ),
        ),
      ],
    ),
  );
}

InkWell responsibleColsedStatus(BuildContext context,
    TaskController taskController, Color getSliderColor(int value)) {
  return InkWell(
    onTap: () {
      Go.to(context, MissionListScreenByReason(statusId: 3.toString()));
    },
    child: Column(
      children: [
        Row(
          children: [
            Text(
              "Responsible Closed".tr +
                  " ( ${taskController.responsibleColsed} )",
              style: const TextStyle(fontSize: 10),
            ),
            Spacer(),
            taskController.responsibleColsed == 0
                ? 0.toString().style()
                : ((taskController.responsibleColsed * 100) /
                        taskController.tasklength)
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
                  taskController.responsibleColsed.toDouble(),
                  Colors.lightGreen),
            ],
          ),
        ),
      ],
    ),
  );
}

InkWell responsipleRespondStatus(BuildContext context,
    TaskController taskController, Color getSliderColor(int value)) {
  return InkWell(
    onTap: () {
      Go.to(context, MissionListScreenByReason(statusId: 3.toString()));
    },
    child: Column(
      children: [
        Row(
          children: [
            Text(
              "Responsible Respond".tr +
                  " ( ${taskController.responsipleRespond} )",
              style: const TextStyle(fontSize: 10),
            ),
            Spacer(),
            taskController.responsipleRespond == 0
                ? 0.toString().style()
                : ((taskController.responsipleRespond * 100) /
                        taskController.tasklength)
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
                  taskController.responsipleRespond.toDouble(),
                  Colors.amber),
            ],
          ),
        ),
      ],
    ),
  );
}

InkWell ownerRespondeStatus(BuildContext context, TaskController taskController,
    Color getSliderColor(int value)) {
  return InkWell(
    onTap: () {
      Go.to(context, MissionListScreenByReason(statusId: 3.toString()));
    },
    child: Column(
      children: [
        Row(
          children: [
            Text(
              "Owner Respond".tr + " ( ${taskController.ownerRespond} )",
              style: const TextStyle(fontSize: 10),
            ),
            Spacer(),
            taskController.ownerRespond == 0
                ? 0.toString().style()
                : ((taskController.ownerRespond * 100) /
                        taskController.tasklength)
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
                  taskController.ownerRespond.toDouble(),
                  Colors.green),
            ],
          ),
        ),
      ],
    ),
  );
}

Expanded statuseFeddbackAndLatenessButton(
    BuildContext context, Color Function(int value) getSliderColor) {
  return Expanded(
      flex: 3,
      child: GetBuilder<FeedbackController>(
          init: FeedbackController(),
          builder: (missionsController) {
            return missionsController.isLoading == false
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
                                "Statistics Feedback".tr,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                    fontSize: 12),
                              ),
                              const Spacer(),
                              // Text(
                              //   "All".tr +
                              //       "(" +
                              //       missionsController.feedbackslength
                              //           .toString() +
                              //       ")",
                              //   style: TextStyle(
                              //       fontWeight: FontWeight.w500,
                              //       fontSize: 12,
                              //       color: Theme.of(context).primaryColor),
                              // ),
                              const SizedBox(
                                width: 10,
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                              height: 24,
                              width: double.infinity,
                              child: containerwithblue(
                                context,
                                color: const Color.fromARGB(255, 199, 199, 199),
                                widget: Row(
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Go.to(
                                            context,
                                            FeedbackScreenFilter(
                                              isItLinkedToAMission: false,
                                            ));
                                      },
                                      child: Row(
                                        children: [
                                          const CircleAvatar(
                                            radius: 4,
                                            backgroundColor: Color(0XffD12525),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "With Out Mission".tr +
                                                " ${missionsController.feedbacksWithOutMission}",
                                            style:
                                                const TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    InkWell(
                                      onTap: () {
                                        Go.to(
                                            context,
                                            FeedbackScreenFilter(
                                              isItLinkedToAMission: true,
                                            ));
                                      },
                                      child: Row(
                                        children: [
                                          const CircleAvatar(
                                            radius: 5,
                                            backgroundColor: Color(0Xff26931D),
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            "With Mission".tr +
                                                " ${missionsController.feedbacksWithMission}",
                                            style:
                                                const TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              )),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            "Percentage".tr,
                            style: const TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 12),
                          ),
                          InkWell(
                            onTap: () {
                              Go.to(
                                  context,
                                  FeedbackScreenFilter(
                                    isItLinkedToAMission: true,
                                  ));
                            },
                            child: SizedBox(
                              height: 24,
                              child: Row(
                                children: [
                                  flutterSlider(
                                      getSliderColor,
                                      missionsController.feedbackslength
                                          .toDouble(),
                                      missionsController.feedbacksWithMission
                                          .toDouble(),
                                      Colors.green),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  missionsController.feedbacksWithMission == 0
                                      ? 0.toString().style()
                                      : ((missionsController
                                                      .feedbacksWithMission *
                                                  100) /
                                              missionsController
                                                  .feedbackslength)
                                          .toStringAsFixed(2)
                                          .style(),
                                  "%".style(),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Go.to(
                                  context,
                                  FeedbackScreenFilter(
                                    isItLinkedToAMission: true,
                                  ));
                            },
                            child: InkWell(
                              onTap: () {
                                Go.to(
                                    context,
                                    FeedbackScreenFilter(
                                      isItLinkedToAMission: false,
                                    ));
                              },
                              child: SizedBox(
                                height: 24,
                                child: Row(
                                  children: [
                                    flutterSlider(
                                        getSliderColor,
                                        missionsController.feedbackslength
                                            .toDouble(),
                                        missionsController
                                            .feedbacksWithOutMission
                                            .toDouble(),
                                        Colors.red),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    missionsController
                                                .feedbacksWithOutMission ==
                                            0
                                        ? 0.toString().style()
                                        : ((missionsController
                                                        .feedbacksWithOutMission *
                                                    100) /
                                                missionsController
                                                    .feedbackslength)
                                            .toStringAsFixed(2)
                                            .style(),
                                    "%".style(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const Spacer()
                        ],
                      ),
                    ),
                  )
                : Container(
                    decoration: StyleContainer.style1,
                    child: const Center(child: spinkit));
          }));
}
