import 'package:get/get.dart';

String getStatusLabel(int statusId) {
  switch (statusId) {
    case 1:
      return 'New'.tr; // Translates to "Created"
    case 2:
      return 'In Progress'.tr; // Translates to "In Progress"
    case 3:
      return 'Completed'.tr; // Translates to "Completed"
    case 4:
      return 'Canceled'.tr; // Translates to "Canceled"
    default:
      return 'Unknown Status'.tr; // Fallback for unknown status
  }
}
