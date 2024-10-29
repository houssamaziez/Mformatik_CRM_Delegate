import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/feedback_controller.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/Style/style_text.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';

import '../../../Controller/home/missions_controller.dart';
import '../../../Util/Style/stylecontainer.dart';
import '../../widgets/Containers/container_blue.dart';
import '../../widgets/flutter_slider.dart';

Expanded statuseAndLatenessButton(
    BuildContext context, Color Function(int value) getSliderColor) {
  return Expanded(
      flex: 3,
      child: GetBuilder<MissionsController>(
          init: MissionsController(),
          builder: (missionsController) {
            return InkWell(
              onTap: () {
                // Go.to(context, const ScreenAbsencrAndLateness());
              },
              child: missionsController.isLoading == false
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
                                const Text(
                                  "Statistics Missions",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12),
                                ),
                                Spacer(),
                                Text(
                                  "(" +
                                      missionsController.missions!.length
                                          .toString() +
                                      ")",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      color: Theme.of(context).primaryColor),
                                ),
                                SizedBox(
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
                                  color:
                                      const Color.fromARGB(255, 199, 199, 199),
                                  widget: Row(
                                    children: [
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 4,
                                            backgroundColor: Color(0XffD12525),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "Canceled ${missionsController.canceled}",
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 4,
                                            backgroundColor: Color(0XffE3A105),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "In Progress ${missionsController.inProgress}",
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 5,
                                            backgroundColor: Color(0Xff26931D),
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            "Completed ${missionsController.completed} ",
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                )),
                            const SizedBox(
                              height: 8,
                            ),
                            const Text(
                              "Percentage ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 12),
                            ),
                            SizedBox(
                              height: 24,
                              child: Row(
                                children: [
                                  flutterSlider(
                                      getSliderColor,
                                      missionsController.missions!.length
                                          .toDouble(),
                                      missionsController.completed.toDouble(),
                                      Colors.green),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  missionsController.completed == 0
                                      ? 0.toString().style()
                                      : ((missionsController.completed * 100) /
                                              missionsController
                                                  .missions!.length)
                                          .toStringAsFixed(2)
                                          .style(),
                                  "%".style(),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 24,
                              child: Row(
                                children: [
                                  flutterSlider(
                                      getSliderColor,
                                      missionsController.missions!.length
                                          .toDouble(),
                                      missionsController.inProgress.toDouble(),
                                      Colors.orange),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  missionsController.inProgress == 0
                                      ? 0.toString().style()
                                      : ((missionsController.inProgress * 100) /
                                              missionsController
                                                  .missions!.length)
                                          .toStringAsFixed(2)
                                          .style(),
                                  "%".style(),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 24,
                              child: Row(
                                children: [
                                  flutterSlider(
                                      getSliderColor,
                                      missionsController.missions!.length
                                          .toDouble(),
                                      missionsController.canceled.toDouble(),
                                      Colors.red),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  missionsController.canceled == 0
                                      ? 0.toString().style()
                                      : ((missionsController.canceled * 100) /
                                              missionsController
                                                  .missions!.length)
                                          .toStringAsFixed(2)
                                          .style(),
                                  "%".style(),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : Container(
                      decoration: StyleContainer.style1,
                      child: Center(child: spinkit)),
            );
          }));
}

Expanded statuseFeddbackAndLatenessButton(
    BuildContext context, Color Function(int value) getSliderColor) {
  return Expanded(
      flex: 3,
      child: GetBuilder<FeedbackController>(
          init: FeedbackController(),
          builder: (missionsController) {
            return InkWell(
              onTap: () {
                // Go.to(context, const ScreenAbsencrAndLateness());
              },
              child: missionsController.isLoading == false
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
                                const Text(
                                  "Statistics Feddback",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12),
                                ),
                                Spacer(),
                                Text(
                                  "All " +
                                      "(" +
                                      missionsController.feedbackslength
                                          .toString() +
                                      ")",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      color: Theme.of(context).primaryColor),
                                ),
                                SizedBox(
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
                                  color:
                                      const Color.fromARGB(255, 199, 199, 199),
                                  widget: Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 4,
                                            backgroundColor: Color(0XffD12525),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "With Out Mission ${missionsController.feedbacksWithOutMission}",
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 5,
                                            backgroundColor: Color(0Xff26931D),
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            "With Mission   ${missionsController.feedbacksWithMission}",
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                )),
                            const SizedBox(
                              height: 8,
                            ),
                            const Text(
                              "Percentage ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 12),
                            ),
                            SizedBox(
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
                            SizedBox(
                              height: 24,
                              child: Row(
                                children: [
                                  flutterSlider(
                                      getSliderColor,
                                      missionsController.feedbackslength
                                          .toDouble(),
                                      missionsController.feedbacksWithOutMission
                                          .toDouble(),
                                      Colors.orange),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  missionsController.feedbacksWithOutMission ==
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
                            Spacer()
                          ],
                        ),
                      ),
                    )
                  : Container(
                      decoration: StyleContainer.style1,
                      child: Center(child: spinkit)),
            );
          }));
}
