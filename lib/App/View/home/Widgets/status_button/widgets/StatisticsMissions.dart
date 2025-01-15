
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../Controller/home/mission/missions_controller.dart';
import '../../../../../Util/Route/Go.dart';
import '../../../home_screens/home_mission/mission_by_reasonId/mission_list_screen_by_reasonId.dart';

Row StatisticsMissions(BuildContext context, MissionsController missionsController) {
  return Row(
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
                        );
}
