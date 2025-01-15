
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../Controller/home/mission/missions_controller.dart';
import '../../../../../Util/Route/Go.dart';
import '../../../../widgets/Containers/container_blue.dart';
import '../../../home_screens/home_mission/mission_by_reasonId/mission_list_screen_by_reasonId.dart';

SizedBox statMissionbutton(BuildContext context, MissionsController missionsController) {
  return SizedBox(
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
                            ));
}
