import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/company_controller.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/task_controllerAll.dart';
import 'package:mformatic_crm_delegate/App/Util/Theme/colors.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/refresh.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';

import '../../../../../Controller/auth/auth_controller.dart';
import '../../../../../Controller/home/annex_controller.dart';
import '../../../../../Controller/home/mission/missions_controllerAll.dart';
import '../../../../../Controller/home/Task/task_controller.dart';
import '../../../../widgets/bolck_screen.dart';
import '../widgets/task_card.dart';

DateTime? startDateMissions;
DateTime? endDateMissions;
String startDateTextMissions = '';
String endDateTextMissions = '';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String _userId = Get.put(AuthController()).user!.id.toString();

  // Initialize the MissionsController
  final TaskController controller1 = Get.put(TaskController());

  late ScrollController scrollController;
  @override
  void initState() {
    // controller.getAllMission(context);
    // controller1.getAllTask(Get.context,
    //     observerId: controller1.isAssigned == 2 ? _userId : "",
    //     responsibleId: controller1.isAssigned == 0 ? _userId : "",
    //     ownerId: controller1.isAssigned == 1 ? _userId : "");
    scrollController = ScrollController();
    // scrollController.addListener(_scrollListener);
    super.initState();
  }

  // void _scrollListener() {
  //   if (scrollController.position.pixels ==
  //       scrollController.position.maxScrollExtent) {
  //     if (controller1.offset <= controller1.missionslength) {
  //       print("object");
  //       controller1.loadingMoreMission(
  //         context,
  //         endingDate: endDateTextMissions,
  //         startingDate: startDateTextMissions,
  //       );
  //     }

  //     // if (Get.put(MissionsController()).offset <=
  //     //     Get.put(MissionsController()).missionslength) {

  //     // }
  //   }
  // }

  AuthController controllers = Get.put(AuthController());

  final AnnexController annexController =
      Get.put(AnnexController(), permanent: true);
  final CompanyController companyController =
      Get.put(CompanyController(), permanent: true);
  @override
  void dispose() {
    startDateMissions = null;
    endDateMissions = null;
    startDateTextMissions = '';
    endDateTextMissions = '';
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
              title: Text("All Missions".tr),
              centerTitle: true,
            ),
            backgroundColor: ColorsApp.white,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: GetBuilder<TaskController>(
                    builder: (controller) {
                      if (controller.isLoading) {
                        // Show a loading indicator while fetching data
                        return const Center(
                          child: spinkit,
                        );
                      } else if (controller.tasks == null ||
                          controller.tasks!.isEmpty) {
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
                                'No Task available'.tr,
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
                          itemCount: controller.tasks!.length,
                          itemBuilder: (context, index) {
                            print(index);
                            if (index == controller.tasks!.length - 1 &&
                                controller.isLoadingMore) {
                              // Show circular indicator at the bottom when loading more
                              return Center(child: spinkit);
                            } else {
                              final task = controller.tasks![index];
                              return TaskCard(
                                task: task,
                                index: index,
                              );
                            }
                          },
                        ).addRefreshIndicator(
                            onRefresh: () => controller.getAllTask(Get.context,
                                observerId:
                                    controller1.isAssigned == 2 ? _userId : "",
                                responsibleId:
                                    controller1.isAssigned == 0 ? _userId : "",
                                ownerId: controller1.isAssigned == 1
                                    ? _userId
                                    : ""));
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

void showDateRangeDialog(BuildContext context) {
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
                    startDateMissions,
                    () async {
                      DateTime? pickedStartDate = await showDatePicker(
                        context: context,
                        initialDate: startDateMissions ?? DateTime.now(),
                        firstDate: DateTime(2024),
                        lastDate: DateTime.now(),
                      );

                      if (pickedStartDate != null &&
                          pickedStartDate != startDateMissions) {
                        setState(() {
                          startDateMissions = pickedStartDate;
                          startDateTextMissions = startDateMissions!
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
                    endDateMissions,
                    () async {
                      DateTime? pickedEndDate = await showDatePicker(
                        context: context,
                        initialDate: endDateMissions ?? DateTime.now(),
                        firstDate: DateTime(2024),
                        lastDate: DateTime.now(),
                      );

                      if (pickedEndDate != null &&
                          pickedEndDate != endDateMissions) {
                        setState(() {
                          endDateMissions = pickedEndDate;
                          endDateTextMissions = endDateMissions!
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
                          startDateMissions = null;
                          endDateMissions = null;
                          endDateTextMissions = "";
                          startDateTextMissions = "";
                        });

                        Get.put(MissionsControllerAll()).getAllMission(
                            endingDate: endDateTextMissions,
                            startingDate: startDateTextMissions,
                            context,
                            Get.put(CompanyController()).selectCompany!.id);

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
                    endingDate: endDateTextMissions,
                    startingDate: startDateTextMissions,
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
