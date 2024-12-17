import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/company_controller.dart';
import 'package:mformatic_crm_delegate/App/Util/Theme/colors.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/refresh.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';

import '../../../../../Controller/auth/auth_controller.dart';
import '../../../../../Controller/home/annex_controller.dart';
import '../../../../../Controller/home/mission/missions_controllerAll.dart';
import '../../../../widgets/bolck_screen.dart';
import '../widgets/mission_card.dart';
import 'Widgets/show_date_range_dialog_reason.dart';

DateTime? startDateMissionByReason;
DateTime? endDateMissionByReason;
String startDateTextMissionByReason = '';
String endDateTextMissionByReason = '';

class MissionListScreenByReason extends StatefulWidget {
  const MissionListScreenByReason({Key? key, required this.statusId})
      : super(key: key);

  final String statusId;

  @override
  State<MissionListScreenByReason> createState() =>
      _MissionListScreenByReasonState();
}

class _MissionListScreenByReasonState extends State<MissionListScreenByReason> {
  // Initialize the MissionsController
  final MissionsControllerAll controller1 = Get.put(MissionsControllerAll());

  late ScrollController scrollController;
  @override
  void initState() {
    controller1.getAllMission(
      context,
      Get.put(CompanyController()).selectCompany == null
          ? 0
          : Get.put(CompanyController()).selectCompany!.id,
      endingDate: endDateTextMissionByReason,
      startingDate: startDateTextMissionByReason,
      statusId: widget.statusId,
    );
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (controller1.offset <= controller1.missionslength) {
        print("object");
        controller1.loadingMoreMission(
          context,
          endingDate: endDateTextMissionByReason,
          startingDate: startDateTextMissionByReason,
          statusId: widget.statusId,
        );
      }
    }
  }

  AuthController controllers = Get.put(AuthController());
  final AnnexController annexController =
      Get.put(AnnexController(), permanent: true);
  final CompanyController companyController =
      Get.put(CompanyController(), permanent: true);
  @override
  void dispose() {
    startDateMissionByReason = null;
    endDateMissionByReason = null;
    endDateTextMissionByReason = "";
    startDateTextMissionByReason = "";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isactive = controllers.user!.isActive!;
    return isactive == true
        ? Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    showDateRangeDialogReason(
                      context,
                      statusId: widget.statusId,
                    );
                  },
                ),
              ],
              title: Text("${getStatusLabel(int.parse(widget.statusId))}".tr),
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
                        return const Center(
                          child: spinkit,
                        );
                      } else if (controller.missions == null ||
                          controller.missions!.isEmpty) {
                        return Column(
                          children: [
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
                            onRefresh: () =>
                                Get.put(MissionsControllerAll()).getAllMission(
                                  context,
                                  Get.put(CompanyController()).selectCompany ==
                                          null
                                      ? 0
                                      : Get.put(CompanyController())
                                          .selectCompany!
                                          .id,
                                  endingDate: endDateTextMissionByReason,
                                  statusId: widget.statusId,
                                  startingDate: startDateTextMissionByReason,
                                ));
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
