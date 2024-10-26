import 'package:flutter/material.dart';

Color getSliderColor(int value) {
  if (value < 5) {
    return Colors.green; // Color for value < 5
  } else if (value < 13) {
    return Colors.orange; // Color for value < 13
  } else {
    return Colors.red; // Color for value >= 13
  }
}
