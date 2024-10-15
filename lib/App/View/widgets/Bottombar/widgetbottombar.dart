import 'package:flutter/material.dart';
import 'package:get/get.dart';

buttonnavigationbar(context) {
  return Container(
    height: 90,
    color: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildNavItem(
          context,
          0,
          Icons.home,
          'Missions',
        ),
        _buildNavItem(
          context,
          1,
          Icons.search,
          "Search",
        ),
        _buildNavItem(
          context,
          2,
          Icons.person,
          'Profile',
        ),
        _buildNavItem(
          context,
          3,
          Icons.settings,
          "Setting",
        ),
      ],
    ),
  );
}

Widget _buildNavItem(
  context,
  int index,
  IconData icon,
  String label,
) {
  bool isSelected = true;
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        icon,
        color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
      ),
      Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
        ),
      ),
    ],
  );
}
