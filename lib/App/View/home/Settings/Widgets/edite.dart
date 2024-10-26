import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/auth/auth_controller.dart';

import '../../../../Util/Route/Go.dart';
import '../EditeProfile/screenEditeProfile.dart';

Row editeProfile(context) {
  return Row(
    children: [
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Image.asset(
          "assets/icons/user1.png",
          height: 50,
          width: 50,
        ),
      ),

      Expanded(
        child: GetBuilder<AuthController>(
            init: AuthController(),
            builder: (controller) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.user!.username == null
                        ? '...جاري جلب البيانات'
                        : controller.user!.username!.toString(),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  // Text(
                  //   controller.user!. == null
                  //       ? "'جاري جلب البيانات'"
                  //       : controller.student!.email.toString(),
                  //   style: const TextStyle(fontWeight: FontWeight.w400),
                  // ),
                ],
              );
            }),
      ),
      //     if (storageteatcher.read(
      //         "typeUser",
      //       ) ==
      //       "parent") {

      //   }
      //   if (storageteatcher.read(
      //         "typeUser",
      //       ) ==
      //       "teatcher") {
      //   }
      //   if (storageteatcher.read(
      //         "typeUser",
      //       ) ==
      //       "studnet") {
      //   }
      // }
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          onTap: () {
            Go.to(context, ScreenEditeProfile());
          },
          child: Image.asset(
            "assets/icons/Frame62101.png",
            height: 32,
            width: 32,
          ),
        ),
      ),
    ],
  );
}
