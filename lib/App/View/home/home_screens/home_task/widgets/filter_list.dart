import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/extension_widgets.dart';

import '../../../../../Controller/home/Task/task_controller.dart';

Padding filterlist(BuildContext context) {
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
                      "My Supervised".tr,
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
                      "My Created".tr,
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
                      "My Assigned".tr,
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
