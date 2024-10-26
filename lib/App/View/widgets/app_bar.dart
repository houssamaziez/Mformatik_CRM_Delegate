import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Util/Route/Go.dart';

AppBar myappbar(BuildContext context, {String title = ""}) {
  return AppBar(
    leading: IconButton(
        onPressed: () {
          Go.back(context);
        },
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: Colors.white,
        )),
    title: Text(title),
  );
}

appbarblue(BuildContext context,
    {required String title,
    bool isback = true,
    Widget leading = const SizedBox()}) {
  return AppBar(
    leading: leading,
    actions: [
      if (isback)
        IconButton(
          onPressed: () {
            Go.back(context);
          },
          icon: Image.asset(
            Get.locale?.languageCode != 'ar'
                ? "assets/icons/Arrowlight_rtl.png" // سهم باتجاه اليمين
                : "assets/icons/Arrowlight.png", // سهم باتجاه اليسار
            height: 24,
          ),
        )
    ],
    backgroundColor: Theme.of(context).primaryColor,
    centerTitle: true,
    title: Text(
      title,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
    ),
  );
}
