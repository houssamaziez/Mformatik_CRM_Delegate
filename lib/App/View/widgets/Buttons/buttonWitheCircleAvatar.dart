import 'package:flutter/material.dart';

import '../../../Util/Style/Style/container/stylecontainer.dart';


Widget buttonWitheCircleAvatar(
    {required String title,
    required Color colorbackground,
    required Color colorCircleAvatar,
    double height = 24,
    void Function()? onTap}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: height,
      decoration:
          StyleContainer.stylecontainer(color: colorbackground, raduis: 8),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: colorCircleAvatar,
              radius: 4,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
            ),
          ],
        ),
      ),
    ),
  );
}
