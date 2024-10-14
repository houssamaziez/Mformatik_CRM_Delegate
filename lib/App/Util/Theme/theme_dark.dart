import 'package:flutter/material.dart';

ThemeData darktheme = ThemeData(
  primarySwatch: Colors.blue,
  fontFamily: 'Tajawal',
  primaryColor: const Color(0xff1073BA),
  scaffoldBackgroundColor: Colors.white,
  cardColor: const Color(0xffF5F6FA),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
        fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.blue),
    bodyLarge: TextStyle(fontSize: 16.0, color: Colors.black),
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.blue, // Custom button color
    textTheme: ButtonTextTheme.primary,
  ),
);
