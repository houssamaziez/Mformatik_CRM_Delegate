//
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Model/reason_feedback.dart';

import '../../Model/reason_mission.dart';

class ExpandableControllerd extends GetxController {
  Rx<ReasonMission?> selectedItem = Rx<ReasonMission?>(null);
  var isExpanded = false.obs;
  TextEditingController? controllerTextEditingController =
      TextEditingController();
  void toggleExpanded() {
    isExpanded.value = !isExpanded.value;
  }

  void selectItem(ReasonMission item) {
    selectedItem.value = item;
    isExpanded.value = false; // Close the expansion when an item is selected
  }
}

class ExpandableControllerFeedback extends GetxController {
  Rx<FeedbackReason?> selectedItem = Rx<FeedbackReason?>(null);
  var isExpanded = false.obs;
  TextEditingController? controllerTextEditingController =
      TextEditingController();
  void toggleExpanded() {
    isExpanded.value = !isExpanded.value;
  }

  void selectItem(FeedbackReason item) {
    selectedItem.value = item;
    isExpanded.value = false; // Close the expansion when an item is selected
  }
}
