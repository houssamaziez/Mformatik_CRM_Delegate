import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../Controller/widgetsController/date_controller_create.dart';

Column selectDeadline(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      GetBuilder<DateControllerCreate>(
          init: DateControllerCreate(),
          builder: (dateController) {
            return TextField(
              readOnly: true, // Prevent manual typing
              decoration: InputDecoration(
                labelText: 'Selected Date',
                hintText: 'Pick a date',
                suffixIcon: IconButton(
                  icon: Icon(
                    dateController.selectedDate.isEmpty
                        ? Icons.calendar_today
                        : Icons.close,
                  ),
                  onPressed: () {
                    if (dateController.selectedDate.isEmpty) {
                      dateController.pickDate(context);
                    } else {
                      dateController.clearDate();
                    }
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.blue, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.blue, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.blue, width: 3.0),
                ),
              ),
              controller: TextEditingController()
                ..text = dateController.selectedDate,
              onTap: () =>
                  dateController.pickDate(context), // Open date picker on tap
            );
          }),
    ],
  );
}
