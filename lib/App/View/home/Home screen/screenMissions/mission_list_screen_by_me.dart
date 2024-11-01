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

class MissionListScreenByMe extends StatefulWidget {
  const MissionListScreenByMe({Key? key}) : super(key: key);

  @override
  State<MissionListScreenByMe> createState() => _MissionListScreenByMeState();
}

class _MissionListScreenByMeState extends State<MissionListScreenByMe> {
  // Initialize the MissionsController
  final MissionsControllerAll controller1 = Get.put(MissionsControllerAll());
  final ScrollController _scrollController = ScrollController();

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
            creatorId: Get.put(AuthController()).user!.id.toString());
      }

      // if (Get.put(MissionsController()).offset <=
      //     Get.put(MissionsController()).missionslength) {

      // }
    }
  }

  AuthController controllers = Get.put(AuthController());
  bool _showContainers = false;
  final AnnexController annexController =
      Get.put(AnnexController(), permanent: true);
  final CompanyController companyController =
      Get.put(CompanyController(), permanent: true);
  @override
  void dispose() {
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
                    showDateRangeDialog(context);
                  },
                ),
              ],
              title: Text("My Missions"),
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
                            onRefresh: () => controller.getAllMission(
                                context,
                                Get.put(CompanyController())
                                    .selectCompany!
                                    .id));
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

void showDateRangeDialog(context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: const Text('Select Date Range'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Start Date:'),
                TextButton(
                  onPressed: () async {
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
                  child: Text(
                    startDateMission != null
                        ? startDateMission!.toLocal().toString().split(' ')[0]
                        : 'Select Start Date',
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('End Date:'),
                TextButton(
                  onPressed: () async {
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
                        endDateTextMission =
                            endDateMission!.toLocal().toString().split(' ')[0];
                      });
                    }
                  },
                  child: Text(
                    endDateMission != null
                        ? endDateMission!.toLocal().toString().split(' ')[0]
                        : 'Select End Date',
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                Get.put(MissionsControllerAll()).getAllMission(
                    endingDate: endDateTextMission,
                    startingDate: startDateTextMission,
                    context,
                    Get.put(CompanyController()).selectCompany!.id);

                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      });
    },
  );
}
