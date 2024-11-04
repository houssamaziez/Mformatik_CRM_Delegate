import 'package:flutter/material.dart';
import 'package:get/get.dart';

showMessage(context, {required String title, Color color = Colors.red}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(title.tr),
      backgroundColor: color,
      duration: Duration(milliseconds: 1000), // تعيين المدة بـ 200 ميلي ثانية
    ),
  );
}

showMessagetop(context, {required String title, Color color = Colors.red}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(title.tr),
      backgroundColor: color,
    ),
  );
}

void showMessageDialog(BuildContext context,
    {required String title, required String message}) {
  Get.dialog(
    AlertDialog(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text('OK'.tr),
        ),
      ],
    ),
  );
}
