import 'package:flutter/material.dart';

extension PaddingExtension on Widget {
  /// Adds padding around all sides
  Padding paddingAll({double value = 8}) {
    return Padding(
      padding: EdgeInsets.all(value),
      child: this,
    );
  }

  /// Adds padding only to specific sides
  Padding paddingOnly({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) {
    return Padding(
      padding:
          EdgeInsets.only(left: left, top: top, right: right, bottom: bottom),
      child: this,
    );
  }

  /// Adds symmetric padding (horizontal and vertical)
  Padding paddingSymmetric({
    double vertical = 0.0,
    double horizontal = 0.0,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
      child: this,
    );
  }
}
