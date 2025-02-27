import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controller/auth/auth_controller.dart';
import '../../../Controller/home/home_controller.dart';
import '../../../Util/Route/Go.dart';
import '../Settings/screenSetting.dart';

AppBar appbarHome(
  BuildContext context,
) {
  return AppBar(
    centerTitle: true,
    backgroundColor: Colors.white,
    actions: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: GetBuilder<HomeController>(
            init: HomeController(),
            builder: (homeController) {
              return homeController.indexBottomBar == 3 ||
                      homeController.indexBottomBar == 2 ||
                      homeController.indexBottomBar == 4
                  ? Container()
                  : InkWell(
                      onTap: () {
                        homeController.upadteshowcontaner();
                      },
                      child: Image.asset(
                        "assets/icons/filter.png",
                        width: 25,
                      ),
                    );
            }),
      ),
      SizedBox(
        width: 5,
      )
    ],
    title: GetBuilder<AuthController>(
        init: AuthController(),
        builder: (usercontroller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              usercontroller.user!.username == null
                  ? Text(
                      "Loading name...".tr,
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
          Go.to(context, ScreenSetting());
        },
        child: SizedBox(
          child: Image.asset(
            "assets/icons/darhboard.png",
          ),
        ),
      ),
    ),
  );
}
