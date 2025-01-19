import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/extension_widgets.dart';

import '../../../../../../Controller/home/Task/task_controller.dart';

Padding filterlistSelectDetails(BuildContext context) {
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
                    teskController.onIndexChangedSelect(0);
                  },
                  child: Container(

                    
                    decoration: BoxDecoration(

                      
                        color: teskController.detailsSelect != 0
                            ? Colors.white
                            : Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Text(
                      "Information".tr,
                      style: TextStyle(
                          fontSize: 12,
                          color: teskController.detailsSelect == 0
                              ? Colors.white
                              : Colors.black),
                    ).center(),
                  ),
                )),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    teskController.onIndexChangedSelect(1);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: teskController.detailsSelect != 1
                            ? Colors.white
                            : Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Text(
                      "Discussion".tr,
                      style: TextStyle(
                          fontSize: 12,
                          color: teskController.detailsSelect == 1
                              ? Colors.white
                              : Colors.black),
                    ).center(),
                  ),
                )),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    teskController.onIndexChangedSelect(2);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: teskController.detailsSelect != 2
                            ? Colors.white
                            : Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Text(
                      "Histories".tr,
                      style: TextStyle(
                          fontSize: 12,
                          color: teskController.detailsSelect == 2
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
