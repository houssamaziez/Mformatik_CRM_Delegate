import 'package:flutter/material.dart';

class StyleContainer {
  static BoxDecoration style1 = const BoxDecoration(
      color: Color(0xffF5F6FA),
      borderRadius: BorderRadius.all(Radius.circular(12)));

  static BoxDecoration stylecontainer(
      {Color color = const Color(0xffF5F6FA), double raduis = 12}) {
    return BoxDecoration(
        color: color, borderRadius: BorderRadius.all(Radius.circular(raduis)));
  }
}
