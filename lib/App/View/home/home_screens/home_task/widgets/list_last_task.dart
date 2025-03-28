import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/Task/task_controller.dart';
import 'package:mformatic_crm_delegate/App/Util/Date/formatDate.dart';
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/Style/style_text.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/stylecontainer.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/extension_widgets.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';

import '../task_all/task_list_screen.dart';
import '../task_details/details_task.dart';
import 'getStatusColor.dart';

Padding listLastTasks(BuildContext context) {
  Map<int, String> taskStatusEnumString = {
    1: 'New'.tr,
    2: 'Start'.tr,
    3: 'Owner Respond'.tr,
    4: 'Responsible Respond'.tr,
    5: 'Responsible close'.tr,
    6: 'Close'.tr,
    7: 'Canceled'.tr,
  };
  String getStatusLabelTask(int statusId) {
    return taskStatusEnumString[statusId] ?? 'Unknown Status'.tr;
  }

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      width: double.infinity,
      decoration: StyleContainer.style1,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: "Last Tasks".tr.style(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  fontSize: 12),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.assignment,
                        size: 15,
                        color: Colors.transparent,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                          flex: 2,
                          child: "Label".tr.style(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12)),
                      GetBuilder<TaskController>(
                        init: TaskController(),
                        builder: (taskController) {
                          return Flexible(
                              flex: 2,
                              child: ( taskController.isAssigned==0? "Owner"   :"Responsible"
                                  ).tr
                                  .style(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12)
                                  .center());
                        }
                      ),
                      Flexible(
                          flex: 2,
                          child: "Status"
                              .tr
                              .style(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12)
                              .center()),
                      Container(
                          width: 60,
                          child: "Since"
                              .tr
                              .style(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12)
                              .center()),
                    ],
                  ),
                ),
                GetBuilder<TaskController>(
                    init: TaskController(),
                    builder: (Controller) {
                      return Controller.isLoading == false
                          ? Controller.tasks!.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "No Task found".tr,
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount:
                                          Controller.tasks!.length > 7
                                              ? 6
                                              : Controller
                                                  .tasks!.length,
                                      itemBuilder: (context, index) {
                                        final task =
                                            Controller.tasks![index];
                                        return Column(
                                          children: [
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Go.to(
                                                    context,
                                                    TaskProfileScreen(
                                                      taskId: task.id,
                                                    ));
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Icon(
                                                      Icons.assignment,
                                                      color: task.isStart ==
                                                              true
                                                          ? const Color
                                                              .fromARGB(
                                                              255, 10, 255, 19)
                                                          : Theme.of(context)
                                                              .primaryColor,
                                                      size: 15,
                                                    ),
                                                    const SizedBox(
                                                      width: 8,
                                                    ),
                                                    Expanded(
                                                        flex: 2,
                                                        child: Text(
                                                          task.label!,
                                                          textAlign:
                                                              TextAlign.start,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: const TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        )),
                                                    Flexible(
                                                        flex: 2,
                                                        child:(Controller.isAssigned!=0? task
                                                            .responsibleUsername!: task
                                                            .ownerUsername)
                                                            .style(
                                                                textAlign:
                                                                    TextAlign
                                                                        .center)
                                                            .center()),
                                                    Flexible(
                                                        flex: 2,
                                                        child: Column(
                                                          children: [
                                                            SizedBox(
                                                              height: 9,
                                                            ),
                                                            getStatusLabelTask(task
                                                                    .statusId!)
                                                                .toString()
                                                                .style(
                                                                    fontSize:
                                                                        11,
                                                                    color: getStatusColorTask(task
                                                                        .statusId!),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center)
                                                                .center(),
                                                            Text(
                                                              timeDifference(task
                                                                  .updatedAt),
                                                              style: TextStyle(
                                                                  color: getStatusColorTask(
                                                                      task.statusId!),
                                                                  fontSize: 7),
                                                            )
                                                          ],
                                                        )),
                                                    Container(
                                                      width: 60,
                                                      child: Center(
                                                        child: Text(
                                                          timeDifference(
                                                              task.createdAt),
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 10),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            if (Controller
                                                    .tasks!.length >
                                                1)
                                              Container(
                                                height: 1,
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                width: double.maxFinite,
                                              )
                                          ],
                                        );
                                      }),
                                )
                          : spinkit.center();
                    }),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Spacer(),
                InkWell(
                  onTap: () {
                    Go.to(context, const TaskListScreen());
                  },
                  child: Container(
                    decoration: StyleContainer.stylecontainer(
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20, top: 5, bottom: 5),
                      child: Text(
                        "View All Task".tr,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                )
              ],
            )
          ],
        ),
      ),
    ),
  );
}
