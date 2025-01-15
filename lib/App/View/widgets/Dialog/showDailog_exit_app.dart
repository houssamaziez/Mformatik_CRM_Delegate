
  import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<dynamic> showDailog_exit_app(BuildContext context) {
    return showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Exit App'.tr),
                  content: Text('Are you sure you want to exit the app?'.tr),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false); // Do not exit
                      },
                      child: Text('No'.tr),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true); // Exit the app
                      },
                      child: Text('Yes'.tr),
                    ),
                  ],
                );
              },
            );
  }