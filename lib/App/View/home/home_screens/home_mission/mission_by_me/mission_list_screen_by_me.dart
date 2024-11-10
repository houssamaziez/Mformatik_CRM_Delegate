import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/company_controller.dart';
import 'package:mformatic_crm_delegate/App/Util/Theme/colors.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/refresh.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';

import '../../../../../Controller/auth/auth_controller.dart';
import '../../../../../Controller/home/annex_controller.dart';
import '../../../../../Controller/home/missions_controllerAll.dart';
import '../../../../widgets/bolck_screen.dart';
import '../widgets/mission_card.dart';
import 'widgets/show_date_range_dialog_by_me.dart';

DateTime? startDateMissionMe;
DateTime? endDateMissionMe;
String startDateTextMissionMe = '';
String endDateTextMissionMe = '';

class MissionListScreenByMe extends StatefulWidget {
  const MissionListScreenByMe({Key? key}) : super(key: key);

  @override
  State<MissionListScreenByMe> createState() => _MissionListScreenByMeState();
}

class _MissionListScreenByMeState extends State<MissionListScreenByMe> {
  // Initialize the MissionsController
  final MissionsControllerAll controller1 = Get.put(MissionsControllerAll());

  late ScrollController scrollController;
  @override
  void initState() {
    // controller.getAllMission(context);
    controller1.getAllMission(
        context,
        Get.put(CompanyController()).selectCompany == null
            ? 0
            : Get.put(CompanyController()).selectCompany!.id,
        endingDate: endDateTextMissionMe,
        startingDate: startDateTextMissionMe,
        creatorId: Get.put(AuthController()).user!.id.toString());
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (controller1.offset <= controller1.missionslength) {
        print("object");
        controller1.loadingMoreMission(context,
            endingDate: endDateTextMissionMe,
            startingDate: startDateTextMissionMe,
            creatorId: Get.put(AuthController()).user!.id.toString());
      }

      // if (Get.put(MissionsController()).offset <=
      //     Get.put(MissionsController()).missionslength) {

      // }
    }
  }

  AuthController controllers = Get.put(AuthController());
  final AnnexController annexController =
      Get.put(AnnexController(), permanent: true);
  final CompanyController companyController =
      Get.put(CompanyController(), permanent: true);
  @override
  void dispose() {
    startDateMissionMe = null;
    endDateMissionMe = null;
    endDateTextMissionMe = "";
    startDateTextMissionMe = "";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isactive = controllers.user!.isActive;
    return isactive == true
        ? Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    showDateRangeDialogByMe(context);
                  },
                ),
              ],
              title: Text("My Missions".tr),
              centerTitle: true,
            ),
            backgroundColor: ColorsApp.white,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: GetBuilder<MissionsControllerAll>(
                    builder: (controller) {
                      if (controller.isLoading) {
                        // Show a loading indicator while fetching data
                        return const Center(
                          child: spinkit,
                        );
                      } else if (controller.missions == null ||
                          controller.missions!.isEmpty) {
                        // Show a message when there are no missions
                        return Column(
                          children: [
                            // SizedBox(
                            //     child: meneuSelectTow(context,
                            //         indexchos: controller.indexminu,
                            //         onIndexChanged: (p0) {
                            //   controller.onIndexChanged(p0);
                            // }, titles: ["From Platform", "By me"])),
                            const Spacer(),
                            Center(
                              child: Text(
                                'No missions available'.tr,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                            const Spacer(),
                          ],
                        );
                      } else {
                        // Display the list of missions
                        return ListView.builder(
                          controller:
                              scrollController, // Attach the scrollController here

                          shrinkWrap: true,
                          itemCount: controller.missions!.length,
                          itemBuilder: (context, index) {
                            print(index);
                            if (index == controller.missions!.length - 1 &&
                                controller.isLoadingMore) {
                              // Show circular indicator at the bottom when loading more
                              return Center(child: spinkit);
                            } else {
                              final mission = controller.missions![index];
                              return MissionCard(
                                mission: mission,
                                index: index,
                              );
                            }
                          },
                        ).addRefreshIndicator(
                            onRefresh: () => Get.put(MissionsControllerAll())
                                .getAllMission(
                                    context,
                                    Get.put(CompanyController())
                                                .selectCompany ==
                                            null
                                        ? 0
                                        : Get.put(CompanyController())
                                            .selectCompany!
                                            .id,
                                    endingDate: endDateTextMissionMe,
                                    startingDate: startDateTextMissionMe,
                                    creatorId: Get.put(AuthController())
                                        .user!
                                        .id
                                        .toString()));
                      }
                    },
                  ),
                ),
              ],
            ),
          )
        : const screenBlock();
  }
}
