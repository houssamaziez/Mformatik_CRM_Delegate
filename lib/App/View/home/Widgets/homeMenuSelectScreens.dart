import 'package:flutter/material.dart';

import 'homeMenu_select.dart';
import 'itemcircl.dart';

Row homeMenuSelectScreens(BuildContext context,
    {required List<HomeMenuSelect> data}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: data.map((item) {
      return itemcircl(
        context,
        icon: item.icon,
        numnotification: 0,
        title: item.title,
        function: item.function,
      );
    }).toList(),
  );
}
