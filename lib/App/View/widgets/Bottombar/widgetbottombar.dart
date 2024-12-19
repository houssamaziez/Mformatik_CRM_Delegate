import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/home_controller.dart';

buttonnavigationbar(context) {
  return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return Container(
          height: 65,
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: _buildNavItem(context, 0, Icons.ads_click_rounded,
                    'Missions'.tr, controller),
              ),
              Expanded(
                child: _buildNavItem(context, 1, Icons.feed_outlined,
                    'Feedbacks'.tr, controller),
              ),
              Expanded(
                child: _buildNavItem(
                    context, 2, Icons.assignment, 'Task'.tr, controller),
              ),
              Expanded(
                  child: _buildNavItem(
                      context, 3, Icons.person, 'Profile'.tr, controller)),
            ],
          ),
        );
      });
}

Widget _buildNavItem(context, int index, IconData icon, String label,
    HomeController controller) {
  return InkWell(
    onTap: () {
      controller.updateindexBottomBar(index);
    },
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: controller.indexBottomBar == index
              ? Theme.of(context).primaryColor
              : Colors.grey,
          size: 19,
        ),
        Text(
          label,
          style: TextStyle(
              fontSize: 12,
              color: controller.indexBottomBar == index
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
              fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}
