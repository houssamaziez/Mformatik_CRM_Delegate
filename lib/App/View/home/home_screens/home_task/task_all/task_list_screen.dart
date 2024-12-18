import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/company_controller.dart';
import 'package:mformatic_crm_delegate/App/Util/Theme/colors.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/refresh.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';

import '../../../../../Controller/auth/auth_controller.dart';
import '../../../../../Controller/home/annex_controller.dart';
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
    scrollController = ScrollController();

    super.initState();
  }

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
    bool isactive = controllers.user!.isActive!;
    return isactive == true
        ? Scaffold(
            appBar: AppBar(
              title: Text("All Task".tr),
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
                        return const Center(
                          child: spinkit,
                        );
                      } else if (controller.tasks == null ||
                          controller.tasks!.isEmpty) {
                        return Column(
                          children: [
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
                        return ListView.builder(
                          controller: scrollController,
                          shrinkWrap: true,
                          itemCount: controller.tasks!.length,
                          itemBuilder: (context, index) {
                            print(index);
                            if (index == controller.tasks!.length - 1 &&
                                controller.isLoadingMore) {
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
