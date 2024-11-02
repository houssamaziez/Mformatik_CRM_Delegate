import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controller/auth/auth_controller.dart';
import '../../../Util/Route/Go.dart';
import '../../auth/screen_auth.dart';
import '../../splashScreen/splash_screen.dart';
import '../../widgets/Dialog/showExitConfirmationDialog.dart';
import '../../widgets/app_bar.dart';
import 'Widgets/buttons.dart';
import 'Widgets/cardstate.dart';
import 'Widgets/edite.dart';
import 'Widgets/itemsetting.dart';

class ScreenSetting extends StatelessWidget {
  ScreenSetting({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myappbar(context, title: "Settings and Preferences".tr),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Directionality(
                textDirection: TextDirection.ltr, // Set text direction to RTL
                child: editeProfile(context)),
            liststate(),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Quick Actions".tr,
                textAlign: TextAlign.start,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            carditemsetting(context),
            buttonsetting(
                function: () {
                  showExitConfirmationDialog(context, onPressed: () {
                    token.write("token", null);
                    spalshscreenfirst.write('key', false);
                    Go.clearAndTo(context, ScreenAuth());
                  },
                      details:
                          'Do you really want to log out of the account?'.tr,
                      title: "Log Out".tr);
                },
                title: "Log Out".tr,
                image: 'assets/icons/log-out1.png'),
          ],
        ),
      ),
    );
  }
}

void cleanAllControllers() {
  Get.deleteAll(force: true);
}
