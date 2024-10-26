import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/extension_widgets.dart';

Expanded flutterSlider(Color Function(int value) getSliderColor, double max,
    double index, Color colorstatus) {
  return IgnorePointer(
    child: FlutterSlider(
      handlerHeight: 5,
      values: [index],
      max: max == 0 ? 1 : max,
      min: 0,
      decoration: const BoxDecoration(),
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      trackBar: FlutterSliderTrackBar(
          inactiveTrackBarHeight: 6,
          activeTrackBarHeight: 6,
          inactiveTrackBar:
              BoxDecoration(borderRadius: BorderRadius.circular(16)),
          activeTrackBar: BoxDecoration(
              color: colorstatus, borderRadius: BorderRadius.circular(16))),
      rightHandler: FlutterSliderHandler(
          foregroundDecoration: BoxDecoration(
              color: Colors.amber, borderRadius: BorderRadius.circular(16))),
      handler: FlutterSliderHandler(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromARGB(0, 140, 35, 35),
        ),
        child: Container(),
      ),
      onDragging: (handlerIndex, lowerValue, upperValue) {
        if (kDebugMode) {
          print('Dragging: $lowerValue');
        }
      },
    ),
  ).expand();
}
