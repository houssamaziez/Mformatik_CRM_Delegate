import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controller/home/home_controller.dart';
import '../../../Controller/home/notification/notification_controller.dart';

Widget buildNavItem(context, int index, IconData icon, String label,
    HomeController controller) {
  return InkWell(
    onTap: () {
      if (index == 3) {
        Get.put(NotificationController()).clhNotificationsCount();
      }
      controller.updateindexBottomBar(index);
    },
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GetBuilder<NotificationController>(
            init: NotificationController(),
            builder: (notification) {
              return Stack(
                children: [
                  Icon(
                    icon,
                    color: controller.indexBottomBar == index
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                    size: 24,
                  ),
                  Icons.notifications == icon
                      ? notification.notificationcount == 0
                          ? const SizedBox()
                          : Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 12,
                                  minHeight: 12,
                                ),
                                child: Text(
                                  '${notification.notificationcount}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ))
                      : SizedBox.shrink(),
                ],
              );
            }),
        Text(
          label,
          style: TextStyle(
              fontSize: 9,
              color: controller.indexBottomBar == index
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
              fontWeight: FontWeight.w400),
        ),
      ],
    ),
  );
}
