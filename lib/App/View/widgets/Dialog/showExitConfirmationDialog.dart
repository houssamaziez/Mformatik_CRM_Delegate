import 'package:flutter/material.dart';
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';

import '../../../Controller/auth/auth_controller.dart';
import '../../auth/screen_auth.dart';
import '../../home/splashScreen/splash_screen.dart';

Future<bool> showExitConfirmationDialog(BuildContext context) async {
  return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Log out'),
          content: const Text('Do you really want to log out of the account?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Stay in the app
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                token.write("token", null);
                spalshscreenfirst.write('key', false);
                Go.clearAndTo(context, ScreenAuth());
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ) ??
      false; // Return false if the dialog is dismissed
}
