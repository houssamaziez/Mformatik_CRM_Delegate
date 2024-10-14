import 'package:flutter/material.dart';

class Go {
  // Navigate to a new screen
  static Future<void> to(BuildContext context, Widget screen) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  // Navigate to a new screen and replace the current one
  static void replace(BuildContext context, Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  // Navigate to a new screen and clear the navigation stack
  static void clearAndTo(BuildContext context, Widget screen) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => screen),
      (route) => false,
    );
  }

  // Go back to the previous screen
  static void back(BuildContext context) {
    Navigator.pop(context);
  }

  // Navigate using named routes
  static void toNamed(BuildContext context, String routeName,
      {Object? arguments}) {
    Navigator.pushNamed(
      context,
      routeName,
      arguments: arguments,
    );
  }

  // Replace current screen with named route
  static void replaceNamed(BuildContext context, String routeName,
      {Object? arguments}) {
    Navigator.pushReplacementNamed(
      context,
      routeName,
      arguments: arguments,
    );
  }

  // Clear the navigation stack and navigate using named route
  static void clearAndToNamed(BuildContext context, String routeName,
      {Object? arguments}) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }
}
