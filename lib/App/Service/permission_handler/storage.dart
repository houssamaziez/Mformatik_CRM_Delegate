import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

Future<void> requestStoragePermissions() async {
  // Requesting the necessary permission for Android
  if (Platform.isAndroid) {
    PermissionStatus status = await Permission.storage.request();
    if (!status.isGranted) {
      // If permission is not granted, you can show a message or handle it
      print("Storage permission not granted.");
    }
  }
}
