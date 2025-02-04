import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../Controller/auth/auth_controller.dart';
import '../../../../../Controller/home/company_controller.dart';
import '../../../../../Controller/home/feedback/feedback_controller.dart';
import '../../../../../Util/Date/formatDate.dart';
import '../widgets/_buildDateSelection.dart';

class SupControllerFeedbackListScreen extends GetxController {
  DateTime? startDate;
  DateTime? endDate;
  String startDateText = '';
  String endDateText = '';

  cleanData() {
    startDate = null;
    endDate = null;
    startDateText = '';
    endDateText = '';
    update();
  }

  void showDateRangeDialog(BuildContext context) {
    final CompanyController companyController = Get.put(CompanyController());

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
                    buildDateSelection(
                      context,
                      'Start Date'.tr,
                      startDate,
                      () async {
                        DateTime? pickedStartDate = await showDatePicker(
                          context: context,
                          initialDate: startDate ?? DateTime.now(),
                          firstDate: DateTime(2024),
                          lastDate: DateTime.now(),
                        );

                        if (pickedStartDate != null &&
                            pickedStartDate != startDate) {
                          setState(() {
                            startDate = pickedStartDate;
                            startDateText =
                                startDate!.toLocal().toString().split(' ')[0];
                          });
                          update();
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    buildDateSelection(
                      context,
                      'End Date'.tr,
                      endDate,
                      () async {
                        DateTime? pickedEndDate = await showDatePicker(
                          context: context,
                          initialDate: endDate ?? DateTime.now(),
                          firstDate: DateTime(2024),
                          lastDate: DateTime.now(),
                        );

                        if (pickedEndDate != null && pickedEndDate != endDate) {
                          setState(() {
                            endDate = pickedEndDate;
                            endDateText =
                                endDate!.toLocal().toString().split(' ')[0];
                          });

                          update();
                        }
                      },
                    ),
                    Tooltip(
                      message: 'Reset Dates',
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            startDate = null;
                            endDate = null;
                          });
                          update();
                          Get.put(FeedbackController()).fetchFeedbacks(
                              companyController.selectCompany!.id.toString(),
                              Get.put(AuthController()).user!.id.toString(),
                              endingDate: endDate == null
                                  ? ""
                                  : formatDate(endDate!
                                      .toLocal()
                                      .toString()
                                      .split(' ')[0]),
                              startingDate: startDate == null
                                  ? ""
                                  : formatDate(startDate!
                                      .toLocal()
                                      .toString()
                                      .split(' ')[0]));

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
                  Get.put(FeedbackController()).fetchFeedbacks(
                      companyController.selectCompany!.id.toString(),
                      Get.put(AuthController()).user!.id.toString(),
                      endingDate: endDate == null
                          ? ""
                          : formatDate(
                              endDate!.toLocal().toString().split(' ')[0]),
                      startingDate: startDate == null
                          ? ""
                          : formatDate(
                              startDate!.toLocal().toString().split(' ')[0]));
                  update();
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        });
      },
    );
  }
}
