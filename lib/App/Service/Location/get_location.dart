import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocationService {
  static Future<LocationDataModel> getCurrentLocation(context) async {
    try {
      // Check and request location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return LocationDataModel(
            isPermissionGranted: false,
            message: 'Location permissions are denied.',
          );
        }
      }

      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showEnableLocationDialog(context);
        return LocationDataModel(
          isPermissionGranted: false,
          message: 'Location services are disabled.',
        );
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions denied permanently, show dialog to guide user
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Location Services Disabled'.tr),
              content: Text(
                  'Location services are required for this feature. Please enable them in settings.'
                      .tr),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'.tr),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await Geolocator.openAppSettings();
                  },
                  child: Text('Open Settings'.tr),
                ),
              ],
            );
          },
        );
        return LocationDataModel(
          isPermissionGranted: false,
          message: false
              ? 'Please enable location permissions in settings.'
              : 'Unable to open settings. Enable permissions manually.',
        );
      }

      // Fetch current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return LocationDataModel(
        isPermissionGranted: true,
        latitude: position.latitude,
        longitude: position.longitude,
        message: 'Location fetched successfully.',
      );
    } catch (e) {
      return LocationDataModel(
        isPermissionGranted: false,
        message: 'Failed to get location: $e',
      );
    }
  }

  // Show dialog prompting the user to enable location services
  static void _showEnableLocationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location Services Disabled'.tr),
          content: Text(
              'Location services are required for this feature. Please enable them in settings.'
                  .tr),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await Geolocator.openLocationSettings();
              },
              child: Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }
}

// LocationDataModel to store location and permission data
class LocationDataModel {
  final bool isPermissionGranted;
  final double? latitude;
  final double? longitude;
  final String message;

  LocationDataModel({
    required this.isPermissionGranted,
    this.latitude,
    this.longitude,
    required this.message,
  });
}
