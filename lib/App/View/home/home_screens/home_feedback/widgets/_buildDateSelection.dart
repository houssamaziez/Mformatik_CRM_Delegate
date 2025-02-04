import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget buildDateSelection(
    BuildContext context, String label, DateTime? date, Function onPressed) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      const SizedBox(height: 8),
      TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.grey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () => onPressed(),
        child: Center(
          child: Text(
            date != null
                ? date.toLocal().toString().split(' ')[0]
                : 'Select'.tr + " $label",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 14,
            ),
          ),
        ),
      ),
    ],
  );
}
