import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Util/Route/Go.dart';
import '../LanguageChangeScreen.dart';
import '../AboutTheApplication/aboutTheApplication.dart';
import '../Addedaccounts/addedaccounts.dart';
import '../Notification/notificationscreen.dart';
import '../Suggestions/suggestions.dart';

Padding carditemsetting(context) {
  List<Map<String, String>> listtitemsetting = [
    {
      "title": "Added Accounts".tr,
      "Image": "assets/icons/school_82202891.png",
    },
    {
      "title": "Notifications".tr,
      "Image": "assets/icons/bell.png",
    },
    {
      "title": "Send Your Suggestions".tr,
      "Image": "assets/icons/chat1.png",
    },
    {
      "title": "About the Application".tr,
      "Image": "assets/icons/letter-i_111653901.png",
    },
    {
      "title": "Change Language".tr,
      "Image": "assets/icons/letter-i_111653901.png",
    },
  ];

  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
      decoration: const BoxDecoration(
          color: Color(0xffF5F6FA),
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Column(
        children: [
          // itemsetting(
          //     titile: listtitemsetting[0]["title"].toString(),
          //     image: listtitemsetting[0]["Image"].toString(),
          //     function: () {
          //       // Go.to(context, AddedAccounts());
          //     }),
          itemsetting(
              titile: listtitemsetting[1]["title"].toString(),
              image: listtitemsetting[1]["Image"].toString(),
              function: () {
                Go.to(context, const NotificationScreen());
              }),
          itemsetting(
              titile: listtitemsetting[2]["title"].toString(),
              image: listtitemsetting[2]["Image"].toString(),
              function: () {
                Go.to(context, SuggestionsScreen());
              }),
          itemsetting(
              titile: listtitemsetting[3]["title"].toString(),
              image: listtitemsetting[3]["Image"].toString(),
              function: () {
                Go.to(context, AboutTheApplication());
              }),
          itemsetting(
              titile: listtitemsetting[4]["title"].toString(),
              image: listtitemsetting[4]["Image"].toString(),
              function: () {
                Go.to(context, const LanguageChangeScreen());
              }),
        ],
      ),
    ),
  );
}

InkWell itemsetting(
    {required String titile,
    required String image,
    required Function function}) {
  return InkWell(
    onTap: () {
      function();
    },
    child: ListTile(
      leading: Image.asset(
        image,
        height: 24,
        width: 24,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 17,
      ),
      title: Text(titile),
    ),
  );
}
