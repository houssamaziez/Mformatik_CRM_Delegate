import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/auth/auth_controller.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/task_controller.dart';
import 'package:mformatic_crm_delegate/App/Util/Date/formatDate.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/refresh.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';

import '../../../../../Model/mission.dart';
import '../../../../../Model/task.dart';
import '../../../../widgets/Containers/container_blue.dart';
import '../../../../widgets/Dialog/showExitConfirmationDialog.dart';
import '../widgets/getStatusColor.dart';
import '../widgets/mission_card.dart';
import 'widgets/item_message.dart';

class TaskProfileScreen extends StatefulWidget {
  final int taskId;

  TaskProfileScreen({Key? key, required this.taskId}) : super(key: key);

  @override
  State<TaskProfileScreen> createState() => _TaskProfileScreenState();
}

class _TaskProfileScreenState extends State<TaskProfileScreen> {
  TaskController taskController = Get.put(TaskController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      taskController.getTaskById(context, widget.taskId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Mission Details'.tr),
        centerTitle: true,
        backgroundColor: theme.primaryColor,
      ),
      body: GetBuilder<TaskController>(
        init: TaskController(),
        builder: (controller) {
          if (controller.isLoadingProfile) {
            return const Center(child: spinkit);
          }
          if (controller.task == null) {
            return Center(child: Text('Mission not found'.tr));
          }
          final task = controller.task!;

          return Scaffold(
            floatingActionButton: Column(
              children: [
                const Spacer(),
                if (task.statusId == 1)
                  FloatingActionButton.extended(
                      heroTag: "IN_PROGRESS", // Unique tag for the first button
                      backgroundColor: Colors.green,
                      onPressed: () async {
                        showExitConfirmationDialog(context,
                            onPressed: () async {
                          Get.back();

                          await controller.changeStatuseMission(
                              2, widget.taskId);
                        },
                            details: 'Are you sure to Start the Mission?'.tr,
                            title: 'Cnfirmation'.tr);
                      },
                      label: Text(
                        "Start Mission".tr,
                        style: const TextStyle(color: Colors.white),
                      )),
                const SizedBox(
                  height: 20,
                ),
                if (task.statusId == 2)
                  FloatingActionButton.extended(
                      heroTag:
                          "addFeedback2", // Unique tag for the first button

                      backgroundColor: Theme.of(context).primaryColor,
                      onPressed: () {},
                      label: Text(
                        "Add Feedback".tr,
                        style: const TextStyle(color: Colors.white),
                      )),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                shrinkWrap: true,
                children: [
                  _buildMissionHeader(context, task),
                  const SizedBox(height: 16),
                  _taskInformation(controller),
                  const SizedBox(height: 16),
                  Text(
                    "commenter",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 1,
                    width: double.maxFinite,
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  listItems(
                    controller: controller,
                  )
                ],
              ).addRefreshIndicator(
                  onRefresh: () =>
                      taskController.getTaskById(context, widget.taskId)),
            ),
          );
        },
      ),
    );
  }

  Container _taskInformation(TaskController controller) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Task Information",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 1,
              width: double.maxFinite,
              color: Colors.grey.withOpacity(0.2),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Text(
                  "Owner: ",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
                Text(
                  controller.task!.ownerUsername!,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w500),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Text(
                  "Responsible: ",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
                Text(
                  controller.task!.responsibleUsername!,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w500),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Text(
                  "Oobserver: ",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
                Text(
                  controller.task!.observerUsername!,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w500),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 1,
              width: double.maxFinite,
              color: Colors.grey.withOpacity(0.2),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Text(
                  "Status: ",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
                Text(
                  getStatusLabel(controller.task!.statusId),
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: getStatusColortask(controller.task!.statusId)),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionHeader(BuildContext context, Task task) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.label!,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildMissionStatusSection(
      ThemeData theme, int statusId, TaskController controller) {
    String statusLabel = getStatusLabel(statusId);
    Color statusColor = getStatusColortask(statusId);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Icon(
            Icons.circle,
            color: statusColor,
          ),
          title: Text(
            'Status'.tr,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
            ),
          ),
          subtitle: Text(
            statusLabel,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: statusId == 2
              ? IconButton(
                  onPressed: () {
                    showExitConfirmationDialog(context, onPressed: () async {
                      Get.back();

                      await controller.changeStatuseMission(1, widget.taskId);
                    },
                        details: 'Are you sure to Stop the Mission?'.tr,
                        title: 'Cnfirmation'.tr);
                  },
                  icon: const Icon(
                    Icons.stop_circle_outlined,
                    color: Colors.red,
                  ))
              : statusId == 1
                  ? IconButton(
                      onPressed: () {
                        showExitConfirmationDialog(context,
                            onPressed: () async {
                          Get.back();

                          await controller
                              .changeStatuseMission(2, widget.taskId)
                              .then((onValue) {});
                        },
                            details: 'Are you sure to Start the Mission?'.tr,
                            title: 'Cnfirmation'.tr);
                      },
                      icon: const Icon(
                        Icons.play_circle_outline_outlined,
                        color: Colors.green,
                      ))
                  : Container(
                      height: 4,
                      width: 4,
                    ),
        ),
      ),
    );
  }
}

class listItems extends StatelessWidget {
  final TaskController controller;
  const listItems({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: controller.task!.items.length,
        itemBuilder: (context, indext) {
          final comment = controller.task!.items[indext];
          return itemMessage(
            comment: comment,
            attachmentId: controller.task!.items[indext].attachments.first["id"]
                .toString(),
            taskId: controller.task!.id.toString(),
            taskItemId: controller.task!.items[indext].id.toString(),
          );
        });
  }
}
