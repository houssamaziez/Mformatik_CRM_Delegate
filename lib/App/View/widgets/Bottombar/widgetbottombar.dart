import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/home_controller.dart';

buttonnavigationbar(context) {
  return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return Container(
          height: 75,
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(context, 0, Icons.home, 'Home', controller),
              _buildNavItem(
                  context, 1, Icons.assessment, 'Missions', controller),
              _buildNavItem(
                  context, 2, Icons.assignment_add, "Add Mission", controller),
              _buildNavItem(context, 3, Icons.person, 'Profile', controller),
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
