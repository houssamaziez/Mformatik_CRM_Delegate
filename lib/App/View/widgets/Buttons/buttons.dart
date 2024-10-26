import 'package:flutter/material.dart';

Expanded buttonmenu(BuildContext context,
    {required Function function,
    required String title,
    required bool isselect}) {
  return Expanded(
      child: InkWell(
    onTap: () {
      function();
    },
    child: Container(
      height: 33,
      decoration: isselect
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: Theme.of(context).primaryColor)
          : BoxDecoration(
              borderRadius: BorderRadius.circular(7), color: Colors.white),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isselect == true ? Colors.white : Colors.black),
        ),
      ),
    ),
  ));
}
