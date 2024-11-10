import 'package:flutter/material.dart';

Color getStatusColor(int statusId) {
  switch (statusId) {
    case 1: // CREATED
      return Colors.blue; // Color for created status
    case 2: // IN_PROGRESS
      return Colors.orange; // Color for in progress
    case 3: // COMPLETED
      return Colors.green; // Color for completed
    case 4: // CANCELED
      return Colors.red; // Color for canceled
    default:
      return Colors.grey; // Fallback color for unknown status
  }
}
