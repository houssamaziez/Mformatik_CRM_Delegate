import 'package:flutter/material.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/extension_padding.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/extension_widgets.dart';

import 'buttons.dart';

Padding meneuSelectTow(
  BuildContext context, {
  required int indexchos,
  required List<String> titles, // List of titles
  required Function(int) onIndexChanged,
}) {
  // Use the title corresponding to the selected index

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        height: 33,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: Theme.of(context).primaryColor,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: Colors.white,
          ),
          child: Row(
            children: [
              buttonmenu(
                context,
                function: () {
                  onIndexChanged(0); // Update the index outside the function
                },
                title: titles[0],
                isselect: indexchos == 0,
              ),
              buttonmenu(
                context,
                function: () {
                  onIndexChanged(1); // Update the index outside the function
                },
                title: titles[1],
                isselect: indexchos == 1,
              ),
            ],
          ),
        ).paddingAll(value: 1).center(),
      ),
    ],
  ).paddingAll(value: 10);
}
