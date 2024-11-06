import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/annex_controller.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/missions_controller.dart';
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/Style/style_text.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/stylecontainer.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/extension_widgets.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/refresh.dart';
import 'package:mformatic_crm_delegate/App/View/home/home_screens/screenMissions/mission_all/mission_list_screen.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';

import '../../../../Controller/home/company_controller.dart';
import '../../../../Controller/home/home_controller.dart';
import '../clientview/client_list_screen.dart';
import '../feedback/feedback_list_screen.dart';
import 'mission_by_me/mission_list_screen_by_me.dart';
import 'mission_details/profile_mission.dart';
import '../../Widgets/status_button.dart';
import '../../Widgets/add_mission_button.dart';
import '../../Widgets/filter_annex_company.dart';
import '../../Widgets/getSliderColor.dart';
import '../../Widgets/homeMenuSelectScreens.dart';
import '../../Widgets/homeMenu_select.dart';
import 'widgets/getStatusColor.dart';
import 'widgets/getStatusLabel.dart';
import 'widgets/list_last_mission.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    List<HomeMenuSelect> _listiconhomemeneu = [
      HomeMenuSelect(
          title: "My Mission".tr,
          icon: "job-description.png",
          function: (context) {
            // Go.to(context, CourseGridScreen(role: 'تنبيهات الحضور'));
            Go.to(context, const MissionListScreenByMe());
          }),
      HomeMenuSelect(
        title: "All Missions".tr,
        icon: 'daily-task.png',
        function: (context) {
          Go.to(context, MissionListScreen());
          // Go.to(context, const RequestForPermission());
        },
      ),
      HomeMenuSelect(
        title: "All Clients".tr,
        icon: 'item3.png',
        function: (context) {
          Go.to(
              context,
              GetBuilder<CompanyController>(
                  init: CompanyController(),
                  builder: (companyController) {
                    return ClientListScreen(
                      isback: true,
                      companyid:
                          Get.put(CompanyController()).selectCompany == null
                              ? 0.toString()
                              : companyController.selectCompany!.id.toString(),
                    );
                  }));
        },
      ),
      HomeMenuSelect(
        title: "My FeedBack".tr,
        icon: 'Messages, Chat.png',
        function: (context) {
          Go.to(context, FeedbackScreen());
          // Go.to(context, const ScreeenFollowUpTeachers());
        },
      ),
    ];

    return GetBuilder<CompanyController>(
        init: CompanyController(),
        builder: (companyController) {
          if (companyController.selectCompany == null &&
              companyController.isLoading.value == true) {
            return GetBuilder<HomeController>(
                init: HomeController(),
                builder: (controller) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        FilterCompany(
                          controller: controller,
                        ),
                        const SizedBox(
                          height: 150,
                        ),
                        const Center(child: spinkit),
                      ],
                    ),
                  );
                });
          }
          if (companyController.selectCompany == null) {
            return GetBuilder<HomeController>(
                init: HomeController(),
                builder: (controller) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        FilterCompany(
                          controller: controller,
                        ),
                        const SizedBox(
                          height: 200,
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "No company found, please select another annex.".tr,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GetBuilder<HomeController>(
                            init: HomeController(),
                            builder: (controllerHome) {
                              return controllerHome.showContainers == false
                                  ? InkWell(
                                      onTap: () {
                                        Get.put(HomeController())
                                            .upadteshowcontaner();
                                      },
                                      child: Container(
                                        decoration:
                                            StyleContainer.stylecontainer(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: "Select another annex"
                                              .tr
                                              .style(color: Colors.white),
                                        ),
                                      ),
                                    )
                                  : Container();
                            }),
                        const SizedBox(
                          height: 200,
                        )
                      ],
                    ),
                  ).addRefreshIndicator(
                    onRefresh: () => Get.put(AnnexController())
                        .fetchAnnexes()
                        .then((onValue) {
                      companyController.updateannex(
                          Get.put(CompanyController()).selectCompany);
                    }),
                  );
                });
          }

          return Scaffold(
            body: GetBuilder<HomeController>(
                init: HomeController(),
                builder: (controller) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        FilterCompany(
                          controller: controller,
                        ),
                        homeMenuSelectScreens(
                          context,
                          data: _listiconhomemeneu,
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        SizedBox(
                            height: 210,
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 8,
                                ),
                                statuseAndLatenessButton(
                                    context, getSliderColor),
                                const SizedBox(
                                  width: 10,
                                ),
                                const AddMissionbutton(),
                                const SizedBox(
                                  width: 8,
                                ),
                              ],
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        listLastMission(context),
                      ],
                    ),
                  ).addRefreshIndicator(onRefresh: () {
                    startDateMissions = null;
                    endDateMissions = null;
                    startDateTextMissions = '';
                    final anex = Get.put(AnnexController()).selectAnnex!;
                    print(anex);
                    endDateTextMissions = '';
                    if (Get.put(CompanyController()).selectCompany == null) {
                      return Get.put(AnnexController()).updateannex(anex);
                    } else {
                      return companyController.updateannex(
                          Get.put(CompanyController()).selectCompany);
                    }
                  });
                }),
          );
        });
  }
}
