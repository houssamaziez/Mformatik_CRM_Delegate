import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';

Future<LocationDataModel> getCurrentLocation() async {
  try {
    // Check for location permissions
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
      return LocationDataModel(
        isPermissionGranted: false,
        message: 'Location services are disabled.',
      );
    }

    if (permission == LocationPermission.deniedForever) {
      // Permission is denied forever, direct the user to the settings
      bool opened = await Geolocator.openAppSettings();
      if (!opened) {
        return LocationDataModel(
          isPermissionGranted: false,
          message:
              'Unable to open settings. Please enable location permissions manually.',
        );
      }
      return LocationDataModel(
        isPermissionGranted: false,
        message:
            'Location permissions are permanently denied. Please enable permissions in settings.',
      );
    }

    // Get the current position (latitude and longitude)
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Return location and permission status in the model
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
