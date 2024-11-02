import 'package:flutter/material.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/Buttons/buttonall.dart';

Future<bool> showExitConfirmationDialog(
  context, {
  required void Function()? onPressed,
  required String title,
  required String details,
}) async {
  return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Center(
            child: Text(
              title,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
          content: SizedBox(
            height: 150,
            child: Column(
              children: [
                Spacer(),
                Text(
                  details,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Image.asset(
                  "assets/icons/warning.png",
                  height: 40,
                ),
                Spacer(),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Stay in the app
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
            Container(
              width: 50,
              child: ButtonAll(
                  function: () {
                    onPressed!;
                  },
                  title: 'OK'),
            )
            // TextButton(
            //   onPressed: onPressed,
            //   child: Text(
            //     'OK',
            //     style: TextStyle(color: Theme.of(context).primaryColor),
            //   ),
            // ),
          ],
        ),
      ) ??
      false; // Return false if the dialog is dismissed
}
