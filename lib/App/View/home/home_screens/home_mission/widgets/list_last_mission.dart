import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/missions_controller.dart';
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/Style/style_text.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/stylecontainer.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/extension_widgets.dart';
import 'package:mformatic_crm_delegate/App/View/home/home_screens/home_mission/mission_all/mission_list_screen.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';

import '../mission_details/profile_mission.dart';
import 'getStatusColor.dart';
import 'mission_card.dart';

Padding listLastMission(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      width: double.infinity,
      decoration: StyleContainer.style1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: "Last Missions".tr.style(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  fontSize: 14),
            ),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Flexible(
                      child: Icon(
                        Icons.ads_click_sharp,
                        color: Colors.transparent,
                      ),
                    ),
                    const SizedBox(
                      width: 1,
                    ),
                    Expanded(
                        flex: 2,
                        child: "Label".tr.style(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14)),
                    Flexible(
                        flex: 2,
                        child: "Creator"
                            .tr
                            .style(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14)
                            .center()),
                    Flexible(
                        flex: 2,
                        child: "Status"
                            .tr
                            .style(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14)
                            .center()),
                    const Flexible(
                      child: Icon(
                        Icons.ads_click_sharp,
                        color: Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Directionality(
              textDirection: TextDirection.ltr,
              child: GetBuilder<MissionsController>(
                  init: MissionsController(),
                  builder: (missionsController) {
                    return missionsController.isLoading == false
                        ? missionsController.missions!.isEmpty
                            ? Padding(
                                padding: EdgeInsets.only(bottom: 8.0),
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "No Missions found".tr,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount:
                                        missionsController.missions!.length > 7
                                            ? 6
                                            : missionsController
                                                .missions!.length,
                                    itemBuilder: (context, index) {
                                      final mission =
                                          missionsController.missions![index];
                                      return Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Go.to(
                                                  context,
                                                  MissionProfileScreen(
                                                    missionId: mission.id,
                                                  ));
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: 8.0, top: 8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Flexible(
                                                    child: Icon(
                                                      Icons.ads_click_sharp,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 1,
                                                  ),
                                                  Expanded(
                                                      flex: 2,
                                                      child: mission.label!
                                                          .style(
                                                              textAlign:
                                                                  TextAlign
                                                                      .start)),
                                                  Flexible(
                                                      flex: 2,
                                                      child: mission
                                                          .creatorUsername!
                                                          .style(
                                                              textAlign:
                                                                  TextAlign
                                                                      .center)
                                                          .center()),
                                                  Flexible(
                                                      flex: 2,
                                                      child: getStatusLabel(
                                                              mission.statusId!)
                                                          .toString()
                                                          .style(
                                                              color: getStatusColor(
                                                                  mission
                                                                      .statusId!),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center)
                                                          .center()),
                                                  Flexible(
                                                    flex: 1,
                                                    child: Icon(
                                                      Icons
                                                          .arrow_circle_right_outlined,
                                                      color: Color.fromARGB(
                                                          255, 86, 209, 90),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          if (missionsController
                                                  .missions!.length >
                                              1)
                                            Container(
                                              height: 1,
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              width: double.maxFinite,
                                            )
                                        ],
                                      );
                                    }),
                              )
                        : spinkit.center();
                  }),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Spacer(),
                InkWell(
                  onTap: () {
                    Go.to(context, const MissionListScreen());
                  },
                  child: Container(
                    decoration: StyleContainer.stylecontainer(
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 20.0, right: 20, top: 5, bottom: 5),
                      child: Text(
                        "View All Missions".tr,
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                )
              ],
            )
          ],
        ),
      ),
    ),
  );
}
