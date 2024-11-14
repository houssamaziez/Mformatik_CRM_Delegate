import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> isMicrophonePermissionGranted() async {
  PermissionStatus status = await Permission.microphone.status;
  return status.isGranted;
}

Future<bool> requestMicrophonePermission(BuildContext context) async {
  PermissionStatus status = await Permission.microphone.request();

  if (status.isGranted) {
    print("Microphone permission granted.");
    return true; // Permission granted
  } else if (status.isDenied || status.isPermanentlyDenied) {
    _showSettingsDialog(context);
    return false; // Permission denied or permanently denied
  } else {
    return false; // Default fallback case, in case status is unknown
  }
}

void _showSettingsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Microphone Permission Required"),
      content: Text(
          "This app needs microphone access to record audio. Please go to settings and enable the microphone permission."),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            openAppSettings(); // This will open the app settings page
          },
          child: Text("Go to Settings"),
        ),
      ],
    ),
  );
}
