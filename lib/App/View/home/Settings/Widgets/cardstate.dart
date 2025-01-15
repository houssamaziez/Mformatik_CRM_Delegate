import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/auth/auth_controller.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/annex_controller.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/company_controller.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/mission/missions_controller.dart';

import '../../../../Controller/home/feedback/feedback_controller.dart';
import '../../../../Util/Style/stylecontainer.dart';
import '../screenSetting.dart';

List<Map<String, String>> listt = [
  {
    "title": "الاصدار".tr,
    "suptitle": "1.0.0",
    "Image": "assets/icons/load.png",
  },
  {
    "title": " ",
    "suptitle": "1",
    "Image": "assets/icons/feedbackIcons.png",
  },
  {
    "title": " ",
    "suptitle": "فعال",
    "Image": "assets/icons/subscribe1.png",
  }
];
List<Map<String, String>> listt2 = [
  {
    "title": " ".tr,
    "suptitle": "",
    "Image": "assets/icons/connecting.png",
  },
  {
    "title": " ",
    "suptitle": "1",
    "Image": "assets/icons/school_82938461.png",
  },
  {
    "title": "حالة الحساب",
    "suptitle": "فعال",
    "Image": "assets/icons/subscribe1.png",
  }
];
Container cardstate(
    {required String title,
    required String suptitle,
    required String image,
    Color colortext = Colors.black}) {
  return Container(
    height: 102,
    width: 110,
    decoration: StyleContainer.style1,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          image,
          height: 32,
        ),
        const SizedBox(
          height: 5,
        ),
        Flexible(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
        ),
        Text(
          suptitle,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, color: colortext),
        ),
      ],
    ),
  );
}

Padding liststate() {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GetBuilder<AnnexController>(
            init: AnnexController(),
            builder: (cont) {
              return cardstate(
                  title: "Annex".tr.toString(),
                  // ignore: unnecessary_null_comparison
                  suptitle: cont.annexList == null
                      ? '0'
                      : cont.annexList.length.toString(),
                  image: "assets/icons/connecting.png".toString());
            }),
        cardstate(
            title: "Version".tr.toString(),
            suptitle: appVersion.toString(),
            image: listt[0]["Image"].toString()),
        GetBuilder<AuthController>(
            init: AuthController(),
            builder: (controller) {
              return cardstate(
                  colortext: controller.user!.isActive == null
                      ? Colors.grey
                      : (controller.user!.isActive == true
                          ? Colors.green
                          : Colors.red),
                  title: "Account".tr.toString(),
                  suptitle: controller.user!.isActive == null
                      ? "in English is \"Verifying...".tr
                      : (controller.user!.isActive == true
                          ? "Active".tr.toString()
                          : "Inactive".tr),
                  image: listt[2]["Image"].toString());
            }),
      ],
    ),
  );
}

Padding liststateprofile() {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GetBuilder<FeedbackController>(
            init: FeedbackController(),
            builder: (cont) {
              return cardstate(
                  title: "Feedback".tr.toString(),
                  // ignore: unnecessary_null_comparison
                  suptitle: cont.feedbackslength == null
                      ? '0'
                      : cont.feedbackslength!.toString(),
                  image:
                      "assets/icons/feedbackIcons.png".toString().toString());
            }),
        GetBuilder<MissionsController>(
            init: MissionsController(),
            builder: (cont) {
              return cardstate(
                  title: "Missions".tr.toString(),
                  suptitle: cont.missionslength == null
                      ? '0'
                      : cont.missionslength!.toString(),
                  image: "assets/icons/target.png".toString());
            }),
        GetBuilder<AuthController>(
            init: AuthController(),
            builder: (controller) {
              return cardstate(
                  colortext: controller.user!.isActive == null
                      ? Colors.grey
                      : (controller.user!.isActive == true
                          ? Colors.green
                          : Colors.red),
                  title: "Account".tr.toString(),
                  suptitle: controller.user!.isActive == null
                      ? "in English is \"Verifying...".tr
                      : (controller.user!.isActive == true
                          ? "Active".tr.toString()
                          : "Inactive".tr),
                  image: listt2[2]["Image"].toString());
            }),
      ],
    ),
  );
}
