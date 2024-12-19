import 'package:flutter/material.dart';

Color getStatusColorTask(int statusId) {
  switch (statusId) {
    case 1:
      return Colors.blue; // Color for NEW
    case 2:
      return Colors.orange; // Color for START
    case 3:
      return Colors.green; // Color for OWNER_RESPOND
    case 4:
      return Colors.amber; // Color for RESPONSIBLE_RESPOND
    case 5:
      return Colors.lightGreen; // Color for RESPONSIBLE_CLOSE
    case 6:
      return Colors.greenAccent; // Color for CLOSE
    case 7:
      return Colors.red; // Color for CANCELED
    default:
      return Colors.grey; // Color for Unknown status
  }
}
