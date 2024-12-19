import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DateControllerCreate extends GetxController {
  var selectedDate = ""; // Observable string for the selected date

  void pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      selectedDate = picked.toLocal().toString().split(' ')[0];
      update();
    }
  }

  initDate(DateTime? initialDate) {
    selectedDate = initialDate!.toLocal().toString().split(' ')[0];
    print(selectedDate);
    update();
  }

  void clearDate() {
    selectedDate = "";
    update();
  }
}
