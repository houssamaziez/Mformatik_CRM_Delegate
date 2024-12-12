import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../Controller/auth/auth_controller.dart';
import '../../../../../../Controller/home/company_controller.dart';
import '../../../../../../Controller/home/mission/missions_controllerAll.dart';
import '../mission_list_screen_by_me.dart';

void showDateRangeDialogByMe(BuildContext context) {
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
                    startDateMissionMe,
                    () async {
                      DateTime? pickedStartDate = await showDatePicker(
                        context: context,
                        initialDate: startDateMissionMe ?? DateTime.now(),
                        firstDate: DateTime(2024),
                        lastDate: DateTime.now(),
                      );
                      if (pickedStartDate != null &&
                          pickedStartDate != startDateMissionMe) {
                        setState(() {
                          startDateMissionMe = pickedStartDate;
                          startDateTextMissionMe = startDateMissionMe!
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
                    endDateMissionMe,
                    () async {
                      DateTime? pickedEndDate = await showDatePicker(
                        context: context,
                        initialDate: endDateMissionMe ?? DateTime.now(),
                        firstDate: DateTime(2024),
                        lastDate: DateTime.now(),
                      );
                      if (pickedEndDate != null &&
                          pickedEndDate != endDateMissionMe) {
                        setState(() {
                          endDateMissionMe = pickedEndDate;
                          endDateTextMissionMe = endDateMissionMe!
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
                          startDateMissionMe = null;
                          endDateMissionMe = null;
                          endDateTextMissionMe = "";
                          startDateTextMissionMe = "";
                        });

                        Get.put(MissionsControllerAll()).getAllMission(
                            context,
                            Get.put(CompanyController()).selectCompany == null
                                ? 0
                                : Get.put(CompanyController())
                                    .selectCompany!
                                    .id,
                            endingDate: endDateTextMissionMe,
                            startingDate: startDateTextMissionMe,
                            creatorId:
                                Get.put(AuthController()).user!.id.toString());

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
                    context,
                    Get.put(CompanyController()).selectCompany == null
                        ? 0
                        : Get.put(CompanyController()).selectCompany!.id,
                    endingDate: endDateTextMissionMe,
                    startingDate: startDateTextMissionMe,
                    creatorId: Get.put(AuthController()).user!.id.toString());

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
