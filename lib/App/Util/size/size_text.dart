import 'package:flutter/material.dart';

class FontSize {
  FontSize._(); // Prevent instantiation

  static const double extraSmall = 10.0;
  static const double small = 12.0;
  static const double medium = 14.0;
  static const double regular = 16.0;
  static const double large = 18.0;
  static const double extraLarge = 22.0;
  static const double title = 28.0;
  static const double appBarTitle = 20.0;
  static const double buttonText = 16.0;
}

final TextTheme customTextTheme = TextTheme(
  displayLarge:
      TextStyle(fontSize: FontSize.title, fontWeight: FontWeight.bold),
  displayMedium: TextStyle(fontSize: FontSize.extraLarge),
  bodyLarge: TextStyle(fontSize: FontSize.medium),
  bodyMedium: TextStyle(fontSize: FontSize.regular),
  labelSmall: TextStyle(fontSize: FontSize.small),
  labelLarge: TextStyle(fontSize: FontSize.buttonText),
);
