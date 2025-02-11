import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/home_controller.dart';

import '../../../Controller/home/notification/notification_controller.dart';
import 'buildNavItem.dart';

buttonnavigationbar(context) {
  return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey, width: 0.5),
              )),
          height: 65,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: buildNavItem(context, 0, Icons.ads_click_rounded,
                    'Missions'.tr, controller),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: buildNavItem(context, 1, Icons.feed_outlined,
                      'Feedbacks'.tr, controller),
                ),
              ),
              Expanded(
                child: buildNavItem(
                    context, 2, Icons.assignment, 'Task'.tr, controller),
              ),
              // GetBuilder<NotificationController>(
              //     init: NotificationController(),
              //     builder: (notification) {
              //       return Expanded(
              //           child: buildNavItem(context, 3, Icons.notifications,
              //               'Notifications'.tr, controller));
              //     }),
              Expanded(
                  child: buildNavItem(
                      context, 4, Icons.person, 'Profile'.tr, controller)),
            ],
          ),
        );
      });
}
