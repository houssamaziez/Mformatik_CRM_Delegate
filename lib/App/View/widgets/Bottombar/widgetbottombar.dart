import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/come_controller.dart';

buttonnavigationbar(context) {
  return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return Container(
          height: 90,
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(context, 0, Icons.home, 'Missions', controller),
              _buildNavItem(context, 1, Icons.search, "Search", controller),
              _buildNavItem(context, 2, Icons.person, 'Profile', controller),
              _buildNavItem(context, 3, Icons.settings, "Setting", controller),
            ],
          ),
        );
      });
}

Widget _buildNavItem(context, int index, IconData icon, String label,
    HomeController controller) {
  bool isSelected = true;
  return InkWell(
    onTap: () {
      controller.updateindexBottomBar(index);
    },
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: controller.indexBottomBar == index
              ? Theme.of(context).primaryColor
              : Colors.grey,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: controller.indexBottomBar == index
                ? Theme.of(context).primaryColor
                : Colors.grey,
          ),
        ),
      ],
    ),
  );
}
