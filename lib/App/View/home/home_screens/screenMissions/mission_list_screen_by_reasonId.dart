import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/company_controller.dart';
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/Style/style_text.dart';
import 'package:mformatic_crm_delegate/App/Util/Theme/colors.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/refresh.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';

import '../../../../Controller/auth/auth_controller.dart';
import '../../../../Controller/home/annex_controller.dart';
import '../../../../Controller/home/missions_controller.dart';
import '../../../../Controller/home/missions_controllerAll.dart';
import '../../../widgets/Buttons/meneuSelectTow.dart';
import '../../../widgets/Containers/container_blue.dart';
import '../../../widgets/bolck_screen.dart';
import '../clientview/client_list_screen.dart';
import 'widgets/mission_card.dart';

DateTime? startDateMission;
DateTime? endDateMission;
String startDateTextMission = '';
String endDateTextMission = '';

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
    // controller.getAllMission(context);
    controller1.getAllMission(
        context,
        Get.put(CompanyController()).selectCompany == null
            ? 0
            : Get.put(CompanyController()).selectCompany!.id,
        endingDate: endDateTextMission,
        startingDate: startDateTextMission,
        statusId: widget.statusId,
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
            endingDate: endDateTextMission,
            startingDate: startDateTextMission,
            statusId: widget.statusId,
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
    startDateMission = null;
    endDateMission = null;
    endDateTextMission = "";
    startDateTextMission = "";
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
                    showDateRangeDialog(
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
                              return MissionCard(mission: mission);
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
                                    endingDate: endDateTextMission,
                                    startingDate: startDateTextMission,
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

void showDateRangeDialog(BuildContext context, {required String statusId}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Text(
                'Select Date Range'.tr,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              Spacer(),
            ],
          ),
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDateSelection(
                    context,
                    'Start Date'.tr,
                    startDateMission,
                    () async {
                      DateTime? pickedStartDate = await showDatePicker(
                        context: context,
                        initialDate: startDateMission ?? DateTime.now(),
                        firstDate: DateTime(2024),
                        lastDate: DateTime.now(),
                      );
                      if (pickedStartDate != null &&
                          pickedStartDate != startDateMission) {
                        setState(() {
                          startDateMission = pickedStartDate;
                          startDateTextMission = startDateMission!
                              .toLocal()
                              .toString()
                              .split(' ')[0];
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildDateSelection(
                    context,
                    'End Date'.tr,
                    endDateMission,
                    () async {
                      DateTime? pickedEndDate = await showDatePicker(
                        context: context,
                        initialDate: endDateMission ?? DateTime.now(),
                        firstDate: DateTime(2024),
                        lastDate: DateTime.now(),
                      );
                      if (pickedEndDate != null &&
                          pickedEndDate != endDateMission) {
                        setState(() {
                          endDateMission = pickedEndDate;
                          endDateTextMission = endDateMission!
                              .toLocal()
                              .toString()
                              .split(' ')[0];
                        });
                      }
                    },
                  ),
                  Tooltip(
                    message: 'Reset Dates',
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          startDateMission = null;
                          endDateMission = null;
                          endDateTextMission = "";
                          startDateTextMission = "";
                        });

                        Get.put(MissionsControllerAll()).getAllMission(
                            context,
                            Get.put(CompanyController()).selectCompany == null
                                ? 0
                                : Get.put(CompanyController())
                                    .selectCompany!
                                    .id,
                            endingDate: endDateTextMission,
                            startingDate: startDateTextMission,
                            statusId: statusId,
                            creatorId:
                                Get.put(AuthController()).user!.id.toString());

                        Navigator.of(context).pop(); // Close the dialog
                      },
                      icon: Icon(
                        Icons.restore_outlined,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel'.tr,
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: Text(
                  'OK'.tr,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              onPressed: () {
                Get.put(MissionsControllerAll()).getAllMission(
                    context,
                    Get.put(CompanyController()).selectCompany == null
                        ? 0
                        : Get.put(CompanyController()).selectCompany!.id,
                    endingDate: endDateTextMission,
                    statusId: statusId,
                    startingDate: startDateTextMission,
                    creatorId: Get.put(AuthController()).user!.id.toString());

                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      });
    },
  );
}

Widget _buildDateSelection(
    BuildContext context, String label, DateTime? date, Function onPressed) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      const SizedBox(height: 8),
      TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.grey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () => onPressed(),
        child: Center(
          child: Text(
            date != null
                ? date.toLocal().toString().split(' ')[0]
                : 'Select $label'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 14,
            ),
          ),
        ),
      ),
    ],
  );
}
