import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/refresh.dart';
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
  @override
  void initState() {
    taskController.getAllTask(Get.context);
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
                        listLastTasks(context),
                      ],
                    ),
                  ).addRefreshIndicator(onRefresh: () {
                    return taskController.getAllTask(Get.context);
                  });
                }),
          );
        });
  }
}
