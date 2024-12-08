import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/auth/auth_controller.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/annex_controller.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/feedback/feedback_controller.dart';
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/Style/style_text.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/stylecontainer.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/extension_widgets.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/refresh.dart';
import 'package:mformatic_crm_delegate/App/View/home/home_screens/home_feedback/feedback_filter/feedback_list_screen_filter.dart';
import 'package:mformatic_crm_delegate/App/View/home/home_screens/home_feedback/feedback_details/feedback_profile_screen.dart';
import 'package:mformatic_crm_delegate/App/View/home/home_screens/home_feedback/feedback_list_all/feedback_list_screen.dart';
import 'package:mformatic_crm_delegate/App/View/home/home_screens/home_feedback/validator/homeview_validator.dart';
import 'package:mformatic_crm_delegate/App/View/home/home_screens/home_mission/mission_all/mission_list_screen.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';

import '../../../../Controller/home/company_controller.dart';
import '../../../../Controller/home/home_controller.dart';
import '../../../../Controller/home/reasons_feedback_controller.dart';
import '../../Widgets/status_button.dart';
import '../../Widgets/add_feedback_button.dart';
import '../../Widgets/filter_annex_company.dart';
import '../../Widgets/getSliderColor.dart';
import '../../Widgets/homeMenuSelectScreens.dart';
import '../../Widgets/homeMenu_select.dart';
import '../clientview/client_list_all/client_list_screen.dart';
import '../home_mission/mission_by_me/mission_list_screen_by_me.dart';

class HomeFeedback extends StatefulWidget {
  HomeFeedback({super.key});

  @override
  State<HomeFeedback> createState() => _HomeFeedbackState();
}

class _HomeFeedbackState extends State<HomeFeedback> {
  final FeedbackController feedbackController = Get.put(
    FeedbackController(),
  );

  late ScrollController scrollController;
  var homeController = Get.put(HomeController());

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      homeController.upadteshowcontaneClos();
    }
  }

  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    feedbackController.fetchFeedbacks(
        Get.put(CompanyController()).selectCompany == null
            ? 0.toString()
            : Get.put(CompanyController()).selectCompany!.id.toString(),
        Get.put(AuthController()).user!.id.toString());
    Get.put(ReasonsFeedbackController()).fetchReasons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<HomeMenuSelect> listiconhomemeneu = [
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
          Go.to(
              context,
              FeedbackScreenFilter(
                isItLinkedToAMission: null,
              ));
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
              builder: buildLoadingCompanySection,
            );
          }
          if (companyController.selectCompany == null) {
            return GetBuilder<HomeController>(
              init: HomeController(),
              builder: (controller) => buildNoCompanyFoundSection(
                  context,
                  controller,
                  companyController,
                  "No company found, please select another annex.".tr),
            );
          }
          return Scaffold(
            body: GetBuilder<HomeController>(
                init: HomeController(),
                builder: (controller) {
                  return SingleChildScrollView(
                    controller:
                        scrollController, // Attach the scrollController here
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
                            height: 145,
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
                                    child: "Last Feedbacks".tr.style(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                        fontSize: 14),
                                  ),
                                  Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Flexible(
                                            child: Icon(
                                              Icons.feed,
                                              color: Colors.transparent,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 1,
                                          ),
                                          Expanded(
                                              flex: 4,
                                              child: "Label".tr.style(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14)),
                                          Flexible(
                                              flex: 2,
                                              child: "Client"
                                                  .tr
                                                  .style(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14)
                                                  .center()),
                                          const Flexible(
                                            child: Icon(
                                              Icons.feed,
                                              color: Colors.transparent,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: GetBuilder<FeedbackController>(
                                        init: FeedbackController(),
                                        builder: (missionsController) {
                                          return missionsController.isLoading ==
                                                  false
                                              ? missionsController
                                                          .feedbacks!.length ==
                                                      0
                                                  ? Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Center(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child: Text(
                                                            "No feedbacks found"
                                                                .tr,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: ListView.builder(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          shrinkWrap: true,
                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
                                                          itemCount: missionsController
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
                                                            return Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: 8,
                                                                ),
                                                                InkWell(
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
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            16),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Flexible(
                                                                          child:
                                                                              Icon(
                                                                            Icons.feed_outlined,
                                                                            color:
                                                                                Theme.of(context).primaryColor,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              1,
                                                                        ),
                                                                        Expanded(
                                                                            flex:
                                                                                5,
                                                                            child:
                                                                                feedback.label!.style(textAlign: TextAlign.start)),
                                                                        Flexible(
                                                                            flex:
                                                                                2,
                                                                            child:
                                                                                feedback.client!.fullName!.toString().style(textAlign: TextAlign.center).center()),
                                                                        Flexible(
                                                                          flex:
                                                                              1,
                                                                          child:
                                                                              Icon(
                                                                            Icons.arrow_circle_right_outlined,
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                86,
                                                                                209,
                                                                                90),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                if (missionsController
                                                                        .feedbacks!
                                                                        .length >
                                                                    1)
                                                                  Container(
                                                                    height: 1,
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.2),
                                                                    width: double
                                                                        .maxFinite,
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
                                          Go.to(context, FeedbackScreen());
                                        },
                                        child: Container(
                                          decoration:
                                              StyleContainer.stylecontainer(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 20.0,
                                                right: 20,
                                                top: 5,
                                                bottom: 5),
                                            child: Text(
                                              "View All Feedback".tr,
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
                        SizedBox(
                          height: 15,
                        )
                      ],
                    ),
                  ).addRefreshIndicator(onRefresh: () {
                    homeController.upadteshowcontanerOpen();

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
