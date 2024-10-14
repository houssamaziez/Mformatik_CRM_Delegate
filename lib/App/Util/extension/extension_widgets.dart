import 'package:flutter/material.dart';

extension WidgetModifiers on Widget {
  /// Adds padding around the widget

  /// Adds margin around the widget by wrapping it in a `Container`
  Container margin([EdgeInsetsGeometry value = const EdgeInsets.all(8.0)]) {
    return Container(
      margin: value,
      child: this,
    );
  }

  /// Centers the widget inside its parent
  Center center() {
    return Center(
      child: this,
    );
  }

  /// Aligns the widget inside its parent with the given alignment
  Align align(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: this,
    );
  }

  /// Expands the widget to fill available space
  Expanded expand({int flex = 1}) {
    return Expanded(
      flex: flex,
      child: this,
    );
  }

  /// Adds a background color by wrapping it in a `Container`
  Container backgroundColor(Color color) {
    return Container(
      color: color,
      child: this,
    );
  }

  /// Adds a border radius by wrapping it in a `ClipRRect`
  ClipRRect borderRadius(BorderRadiusGeometry radius) {
    return ClipRRect(
      borderRadius: radius,
      child: this,
    );
  }

  /// Adds a decoration by wrapping it in a `Container`
  Container decorated(BoxDecoration decoration) {
    return Container(
      decoration: decoration,
      child: this,
    );
  }

  /// Sets the width and height by wrapping it in a `SizedBox`
  SizedBox sized({double? width, double? height}) {
    return SizedBox(
      width: width,
      height: height,
      child: this,
    );
  }
}
