import 'package:flutter/material.dart';

import '../size/size_text.dart';

ThemeData themeLight = ThemeData(
  primarySwatch: Colors.blue,
  fontFamily: 'Tajawal',
  primaryColor: const Color(0xff1073BA),
  scaffoldBackgroundColor: Colors.white,
  cardColor: const Color(0xffF5F6FA),
  textTheme: customTextTheme,
  appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(color: Colors.white),
    backgroundColor: Color(0xff1073BA),
    elevation: 0,
    centerTitle: true,
    toolbarHeight: 50,
    titleTextStyle: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Color(0xff1073BA), // Custom button color
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: const Color(0xff1073BA),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Color(0xffF5F6FA),
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xff1073BA)),
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
    labelStyle: TextStyle(color: Color(0xff1073BA)),
    hintStyle: TextStyle(color: Color(0xffA0A0A0)),
  ),
);
