import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/missions_controller.dart';
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/Style/style_text.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/stylecontainer.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/extension_widgets.dart';
import 'package:mformatic_crm_delegate/App/View/home/Home%20screen/supscreen/screenMissions/mission_list_screen.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';

import '../../Controller/home/company_controller.dart';
import '../../Controller/home/home_controller.dart';
import 'Home screen/supscreen/screenMissions/profile_mission.dart';
import 'Widgets/absence_and_lateness_button.dart';
import 'Widgets/add_mission_button.dart';
import 'Widgets/getSliderColor.dart';
import 'Widgets/homeMenuSelectScreens.dart';
import 'Widgets/homeMenu_select.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CompanyController>(
        init: CompanyController(),
        builder: (companyController) {
          if (companyController.selectCompany == null &&
              companyController.isLoading.value == true) {
            return Center(child: spinkit);
          }
          if (companyController.selectCompany == null) {
            return Column(
              children: [
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "No company found, please select another annex.",
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GetBuilder<HomeController>(
                    init: HomeController(),
                    builder: (controllerHome) {
                      return controllerHome.showContainers == false
                          ? InkWell(
                              onTap: () {
                                Get.put(HomeController()).upadteshowcontaner();
                              },
                              child: Container(
                                decoration: StyleContainer.stylecontainer(
                                    color: Theme.of(context).primaryColor),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: "Select another annex"
                                      .style(color: Colors.white),
                                ),
                              ),
                            )
                          : Container();
                    }),
                Spacer(
                  flex: 2,
                ),
              ],
            );
          }

          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  homeMenuSelectScreens(
                    context,
                    data: listiconhomemeneu,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                      height: 180,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 8,
                          ),
                          statuseAndLatenessButton(context, getSliderColor),
                          const SizedBox(
                            width: 10,
                          ),
                          const AddMissionbutton(),
                          const SizedBox(
                            width: 8,
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
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
                              child: "Last Missions".style(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                  fontSize: 16),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Icon(
                                      Icons.ads_click_sharp,
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 1,
                                  ),
                                  Expanded(
                                      flex: 2,
                                      child: "Label".style(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14)),
                                  Flexible(
                                      flex: 2,
                                      child: "Creator"
                                          .style(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14)
                                          .center()),
                                  Flexible(
                                      flex: 2,
                                      child: "Status"
                                          .style(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14)
                                          .center()),
                                  Flexible(
                                    child: Icon(
                                      Icons.ads_click_sharp,
                                      color: Colors.transparent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GetBuilder<MissionsController>(
                                init: MissionsController(),
                                builder: (missionsController) {
                                  return ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: missionsController
                                                  .missions!.length >
                                              7
                                          ? 6
                                          : missionsController.missions!.length,
                                      itemBuilder: (context, index) {
                                        final mission =
                                            missionsController.missions![index];
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Icon(
                                                  Icons.ads_click_sharp,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 1,
                                              ),
                                              Expanded(
                                                  flex: 2,
                                                  child: mission.label.style(
                                                      textAlign:
                                                          TextAlign.start)),
                                              Flexible(
                                                  flex: 2,
                                                  child: mission.creatorUsername
                                                      .style(
                                                          textAlign:
                                                              TextAlign.center)
                                                      .center()),
                                              Flexible(
                                                  flex: 2,
                                                  child: getStatusLabel(
                                                          mission.statusId)
                                                      .toString()
                                                      .style(
                                                          color: getStatusColor(
                                                              mission.statusId),
                                                          textAlign:
                                                              TextAlign.center)
                                                      .center()),
                                              Flexible(
                                                flex: 1,
                                                child: InkWell(
                                                  onTap: () {
                                                    Go.to(
                                                        context,
                                                        MissionProfileScreen(
                                                          mission: mission,
                                                        ));
                                                  },
                                                  child: Icon(
                                                    Icons
                                                        .arrow_circle_right_outlined,
                                                    color: const Color.fromARGB(
                                                        255, 86, 209, 90),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                }),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Spacer(),
                                InkWell(
                                  onTap: () {
                                    Go.to(context, MissionListScreen());
                                  },
                                  child: Container(
                                    decoration: StyleContainer.stylecontainer(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0,
                                          right: 20,
                                          top: 5,
                                          bottom: 5),
                                      child: Text(
                                        "View All Missions",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 13),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
