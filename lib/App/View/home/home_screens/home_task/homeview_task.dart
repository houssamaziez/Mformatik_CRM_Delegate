import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/extension_widgets.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/refresh.dart';
import '../../../../Controller/auth/auth_controller.dart';
import '../../../../Controller/home/company_controller.dart';
import '../../../../Controller/home/home_controller.dart';
import '../../../../Controller/home/task_controller.dart';
import '../../../widgets/add_task_button.dart';
import '../../Widgets/status_button.dart';
import '../../Widgets/getSliderColor.dart';
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
                            height: 210,
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 8,
                                ),
                                statuseTaskButton(context, getSliderColor),
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
                        _filterlist(context),
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

  Padding _filterlist(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GetBuilder<TaskController>(
          init: TaskController(),
          builder: (teskController) {
            return Container(
              height: 30,
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Row(
                children: [
                  Expanded(
                      child: InkWell(
                    onTap: () {
                      teskController.onIndexChanged(2);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: teskController.isAssigned != 2
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Text(
                        "My Supervised",
                        style: TextStyle(
                            fontSize: 12,
                            color: teskController.isAssigned == 2
                                ? Colors.white
                                : Colors.black),
                      ).center(),
                    ),
                  )),
                  Expanded(
                      child: InkWell(
                    onTap: () {
                      teskController.onIndexChanged(1);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: teskController.isAssigned != 1
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Text(
                        "My Created",
                        style: TextStyle(
                            fontSize: 12,
                            color: teskController.isAssigned == 1
                                ? Colors.white
                                : Colors.black),
                      ).center(),
                    ),
                  )),
                  Expanded(
                      child: InkWell(
                    onTap: () {
                      teskController.onIndexChanged(0);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: teskController.isAssigned != 0
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Text(
                        "My Assigned ",
                        style: TextStyle(
                            fontSize: 12,
                            color: teskController.isAssigned == 0
                                ? Colors.white
                                : Colors.black),
                      ).center(),
                    ),
                  )),
                ],
              ),
            );
          }),
    );
  }
}
