import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/auth/auth_controller.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/company_controller.dart';

import '../../../../Util/Style/stylecontainer.dart';

List<Map<String, String>> listt = [
  {
    "title": "الاصدار".tr,
    "suptitle": "1.0",
    "Image": "assets/icons/load.png",
  },
  {
    "title": "المدارس",
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
        GetBuilder<CompanyController>(
            init: CompanyController(),
            builder: (cont) {
              return cardstate(
                  title: "Company".tr.toString(),
                  // ignore: unnecessary_null_comparison
                  suptitle: cont.companies == null
                      ? '0'
                      : cont.companies!.length.toString(),
                  image: listt[1]["Image"].toString());
            }),
        cardstate(
            title: "Version.".tr.toString(),
            suptitle: listt[0]["suptitle"].toString(),
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
                      ? " in English is \"Verifying ..."
                      : (controller.user!.isActive == true
                          ? "Active".tr.toString()
                          : "Inactive"),
                  image: listt[2]["Image"].toString());
            }),
      ],
    ),
  );
}
