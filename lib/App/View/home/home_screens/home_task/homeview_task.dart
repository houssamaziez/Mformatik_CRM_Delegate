import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/refresh.dart';
import 'package:mformatic_crm_delegate/App/View/home/home_screens/home_task/widgets/getStatusColor.dart';
import '../../../../Controller/auth/auth_controller.dart';
import '../../../../Controller/home/company_controller.dart';
import '../../../../Controller/home/home_controller.dart';
import '../../../../Controller/home/Task/task_controller.dart';
import '../../../widgets/add_task_button.dart';
import '../../Widgets/status_button.dart';
import '../../Widgets/getSliderColor.dart';
import 'widgets/filter_list.dart';
import 'widgets/list_last_task.dart';

class HomeViewTask extends StatefulWidget {
  const HomeViewTask({super.key});

  @override
  State<HomeViewTask> createState() => _HomeViewTaskState();
}

class _HomeViewTaskState extends State<HomeViewTask> {
  TaskController taskController = Get.put(TaskController());
  String _userId = Get.put(AuthController()).user!.id.toString();
  @override
  void initState() {
    taskController.getAllTask(Get.context,
        observerId: taskController.isAssigned == 2 ? _userId : "",
        responsibleId: taskController.isAssigned == 0 ? _userId : "",
        ownerId: taskController.isAssigned == 1 ? _userId : "");
    taskController.onIndexChanged(taskController.isAssigned);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CompanyController>(
        init: CompanyController(),
        builder: (companyController) {
          return Scaffold(
            body: GetBuilder<HomeController>(
                init: HomeController(),
                builder: (controller) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 14,
                        ),
                        SizedBox(
                            height: 260,
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 8,
                                ),
                                statuseTaskButton(context, getStatusColorTask),
                                const SizedBox(
                                  width: 10,
                                ),
                                const AddTaskbutton(),
                                const SizedBox(
                                  width: 8,
                                ),
                              ],
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        filterlist(context),
                        listLastTasks(context),
                      ],
                    ),
                  ).addRefreshIndicator(onRefresh: () {
                    taskController.onIndexChanged(taskController.isAssigned);
                    return taskController.getAllTask(Get.context,
                        observerId:
                            taskController.isAssigned == 2 ? _userId : "",
                        responsibleId:
                            taskController.isAssigned == 0 ? _userId : "",
                        ownerId: taskController.isAssigned == 1 ? _userId : "");
                  });
                }),
          );
        });
  }
}
