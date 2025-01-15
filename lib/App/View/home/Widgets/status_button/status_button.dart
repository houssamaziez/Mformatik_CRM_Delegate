import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/Style/style_text.dart';
import 'package:mformatic_crm_delegate/App/View/home/home_screens/home_mission/mission_by_reasonId/mission_list_screen_by_reasonId.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';
import '../../../../Controller/home/mission/missions_controller.dart';
import '../../../../Util/Style/stylecontainer.dart';
import '../../../widgets/flutter_slider.dart';
import 'widgets/StatisticsMissions.dart';
import 'widgets/statMissionbutton.dart';
 
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
                          StatisticsMissions(context, missionsController),
                          const SizedBox(
                            height: 8,
                          ),
                          statMissionbutton(context, missionsController),
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
