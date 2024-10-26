import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controller/auth/auth_controller.dart';
import '../../../Controller/home/home_controller.dart';

AppBar appbarHome(
  BuildContext context,
) {
  return AppBar(
    centerTitle: true,
    backgroundColor: Colors.white,
    actions: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            Get.put(HomeController()).upadteshowcontaner();
          },
          child: Image.asset(
            "assets/icons/filter.png",
            height: 25,
            width: 32,
          ),
        ),
      ),
    ],
    title: GetBuilder<AuthController>(
        init: AuthController(),
        builder: (usercontroller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              usercontroller.user!.username == null
                  ? Text(
                      "Loading name...",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColor),
                    )
                  : Text(
                      usercontroller.user!.username.toString(),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColor),
                    ),
            ],
          );
        }),
    leading: Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          // Go.to(context, ScreenSetting());
        },
        child: Image.asset(
          "assets/icons/darhboard.png",
          height: 32,
          width: 32,
        ),
      ),
    ),
  );
}
