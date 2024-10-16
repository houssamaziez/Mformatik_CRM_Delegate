//
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Model/reason.dart';

class ExpandableController extends GetxController {
  Rx<Reason?> selectedItem = Rx<Reason?>(null);
  var isExpanded = false.obs;
  TextEditingController? controllerTextEditingController =
      TextEditingController();
  void toggleExpanded() {
    isExpanded.value = !isExpanded.value;
  }

  void selectItem(Reason item) {
    selectedItem.value = item;
    isExpanded.value = false; // Close the expansion when an item is selected
  }
}
