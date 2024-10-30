import 'package:flutter/material.dart';

Future<bool> showExitConfirmationDialog(
  context, {
  required void Function()? onPressed,
  required String title,
  required String details,
}) async {
  return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(details),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Stay in the app
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: onPressed,
              child: const Text('OK'),
            ),
          ],
        ),
      ) ??
      false; // Return false if the dialog is dismissed
}
