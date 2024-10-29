import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/auth/auth_controller.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/annex_controller.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/feedback_controller.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/missions_controller.dart';
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/Style/style_text.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/stylecontainer.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/extension_padding.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/extension_widgets.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/refresh.dart';
import 'package:mformatic_crm_delegate/App/View/home/Home%20screen/feedback/feedback_profile_screen.dart';
import 'package:mformatic_crm_delegate/App/View/home/Home%20screen/feedback/feedback_list_screen.dart';
import 'package:mformatic_crm_delegate/App/View/home/Home%20screen/screenMissions/mission_list_screen.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';

import '../../../Controller/home/company_controller.dart';
import '../../../Controller/home/home_controller.dart';
import 'screenMissions/profile_mission.dart';
import '../Widgets/absence_and_lateness_button.dart';
import '../Widgets/add_feedback_button.dart';
import '../Widgets/add_mission_button.dart';
import '../Widgets/filter_annex_company.dart';
import '../Widgets/getSliderColor.dart';
import '../Widgets/homeMenuSelectScreens.dart';
import '../Widgets/homeMenu_select.dart';

class HomeFeedback extends StatefulWidget {
  HomeFeedback({super.key});

  @override
  State<HomeFeedback> createState() => _HomeFeedbackState();
}

class _HomeFeedbackState extends State<HomeFeedback> {
  final FeedbackController feedbackController = Get.put(
    FeedbackController(),
  );
  @override
  void initState() {
    feedbackController.fetchFeedbacks(
        Get.put(CompanyController()).selectCompany!.id.toString(),
        Get.put(AuthController()).user!.id.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          if (companyController.companies == null) {
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
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "No company found, please select another annex.",
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
                          data: listiconhomemeneu,
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        SizedBox(
                            height: 140,
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 8,
                                ),
                                statuseFeddbackAndLatenessButton(
                                    context, getSliderColor),
                                const SizedBox(
                                  width: 10,
                                ),
                                const AddMissionbuttonFeddback(),
                                const SizedBox(
                                  width: 8,
                                ),
                              ],
                            )),
                        const SizedBox(
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
                                            child: "Label".style(
                                                color: Theme.of(context)
                                                    .primaryColor,
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
                                            child: "Clients"
                                                .style(
                                                    color: Theme.of(context)
                                                        .primaryColor,
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
                                  GetBuilder<FeedbackController>(
                                      init: FeedbackController(),
                                      builder: (missionsController) {
                                        return missionsController.isLoading ==
                                                false
                                            ? missionsController
                                                        .feedbacks!.length ==
                                                    0
                                                ? const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Center(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: Text(
                                                          "No Missions found",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : ListView.builder(
                                                    padding: EdgeInsets.zero,
                                                    shrinkWrap: true,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    itemCount:
                                                        missionsController
                                                                    .feedbacks!
                                                                    .length >
                                                                7
                                                            ? 6
                                                            : missionsController
                                                                .feedbacks!
                                                                .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final feedback =
                                                          missionsController
                                                                  .feedbacks![
                                                              index];
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Flexible(
                                                              child: Icon(
                                                                Icons
                                                                    .ads_click_sharp,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 1,
                                                            ),
                                                            Expanded(
                                                                flex: 2,
                                                                child: feedback
                                                                    .label!
                                                                    .style(
                                                                        textAlign:
                                                                            TextAlign.start)),
                                                            Flexible(
                                                                flex: 2,
                                                                child: feedback
                                                                    .creatorUsername!
                                                                    .style(
                                                                        textAlign:
                                                                            TextAlign.center)
                                                                    .center()),
                                                            Flexible(
                                                                flex: 2,
                                                                child: feedback
                                                                    .clientFullName
                                                                    .toString()
                                                                    .style(
                                                                        textAlign:
                                                                            TextAlign.center)
                                                                    .center()),
                                                            Flexible(
                                                              flex: 1,
                                                              child: InkWell(
                                                                onTap: () {
                                                                  Go.to(
                                                                      context,
                                                                      FeedbackDetailScreen(
                                                                        feedbackId: feedback
                                                                            .id
                                                                            .toString(),
                                                                      ));
                                                                },
                                                                child:
                                                                    const Icon(
                                                                  Icons
                                                                      .arrow_circle_right_outlined,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          86,
                                                                          209,
                                                                          90),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    })
                                            : spinkit.paddingAll().center();
                                      }),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      const Spacer(),
                                      InkWell(
                                        onTap: () {
                                          Go.to(context, FeedbackScreen());
                                        },
                                        child: Container(
                                          decoration:
                                              StyleContainer.stylecontainer(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.only(
                                                left: 20.0,
                                                right: 20,
                                                top: 5,
                                                bottom: 5),
                                            child: Text(
                                              "View All Feedback",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13),
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
                        ),
                        const SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  ).addRefreshIndicator(
                      onRefresh: () => companyController.updateannex(
                          Get.put(CompanyController()).selectCompany));
                }),
          );
        });
  }
}
