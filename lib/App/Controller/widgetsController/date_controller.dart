import 'package:get/get.dart';
import 'package:flutter/material.dart';

class DateController extends GetxController {
  Rx<DateTime> selectedDate;

  DateController({DateTime? initialDate})
      : selectedDate = (initialDate ?? DateTime.now()).obs;

  void pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != selectedDate.value) {
      selectedDate.value = pickedDate;
    }
  }
}
