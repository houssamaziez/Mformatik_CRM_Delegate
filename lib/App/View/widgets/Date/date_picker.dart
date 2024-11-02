import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controller/widgetsController/date_controller.dart';

class DatePickerWidget extends StatelessWidget {
  final DateTime? date;

  DatePickerWidget({Key? key, this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize DateController with the provided date or null
    final DateController dateController =
        Get.put(DateController(initialDate: date));

    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Date'.tr,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => dateController.pickDate(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${dateController.selectedDate.value.toLocal()}'
                          .split(' ')[0],
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Icon(Icons.calendar_today, color: Colors.blue),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
