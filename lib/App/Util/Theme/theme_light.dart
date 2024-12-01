import 'package:flutter/material.dart';

import '../size/size_text.dart';

const int _primaryValue = 0xff1657E3; // Your color in ARGB

ThemeData themeLight = ThemeData(
  primarySwatch: MaterialColor(
    _primaryValue,
    <int, Color>{
      50: Color(0xFFE1F5FE), // 10% shade
      100: Color(0xFFB3E5FC), // 20% shade
      200: Color(0xFF81D4FA), // 30% shade
      300: Color(0xFF4FC3F7), // 40% shade
      400: Color(0xFF29B6F6), // 50% shade
      500: Color(_primaryValue), // 60% shade (base color)
      600: Color(0xFF0288D1), // 70% shade
      700: Color(0xFF0277BD), // 80% shade
      800: Color(0xFF01579B), // 90% shade
      900: Color(_primaryValue), // 100% shade
    },
  ),
  fontFamily: 'Tajawal',
  primaryColor: MaterialColor(
    _primaryValue,
    <int, Color>{
      50: Color(0xFFE1F5FE), // 10% shade
      100: Color(0xFFB3E5FC), // 20% shade
      200: Color(0xFF81D4FA), // 30% shade
      300: Color(0xFF4FC3F7), // 40% shade
      400: Color(0xFF29B6F6), // 50% shade
      500: Color(_primaryValue), // 60% shade (base color)
      600: Color(0xFF0288D1), // 70% shade
      700: Color(0xFF0277BD), // 80% shade
      800: Color(0xFF01579B), // 90% shade
      900: Color(_primaryValue), // 100% shade
    },
  ),
  scaffoldBackgroundColor: Colors.white,
  cardColor: const Color(0xffF5F6FA),
  textTheme: customTextTheme,
  appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(color: Colors.white),
    backgroundColor: MaterialColor(
      _primaryValue,
      <int, Color>{
        50: Color(0xFFE1F5FE), // 10% shade
        100: Color(0xFFB3E5FC), // 20% shade
        200: Color(0xFF81D4FA), // 30% shade
        300: Color(0xFF4FC3F7), // 40% shade
        400: Color(0xFF29B6F6), // 50% shade
        500: Color(_primaryValue), // 60% shade (base color)
        600: Color(0xFF0288D1), // 70% shade
        700: Color(0xFF0277BD), // 80% shade
        800: Color(0xFF01579B), // 90% shade
        900: Color(_primaryValue), // 100% shade
      },
    ),
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
    buttonColor: MaterialColor(
      _primaryValue,
      <int, Color>{
        50: Color(0xFFE1F5FE), // 10% shade
        100: Color(0xFFB3E5FC), // 20% shade
        200: Color(0xFF81D4FA), // 30% shade
        300: Color(0xFF4FC3F7), // 40% shade
        400: Color(0xFF29B6F6), // 50% shade
        500: Color(_primaryValue), // 60% shade (base color)
        600: Color(0xFF0288D1), // 70% shade
        700: Color(0xFF0277BD), // 80% shade
        800: Color(0xFF01579B), // 90% shade
        900: Color(_primaryValue), // 100% shade
      },
    ), // Custom button color
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
    fillColor: Color.fromARGB(255, 255, 255, 255),
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
          color: MaterialColor(
        _primaryValue,
        <int, Color>{
          50: Color(0xFFE1F5FE), // 10% shade
          100: Color(0xFFB3E5FC), // 20% shade
          200: Color(0xFF81D4FA), // 30% shade
          300: Color(0xFF4FC3F7), // 40% shade
          400: Color(0xFF29B6F6), // 50% shade
          500: Color(_primaryValue), // 60% shade (base color)
          600: Color(0xFF0288D1), // 70% shade
          700: Color(0xFF0277BD), // 80% shade
          800: Color(0xFF01579B), // 90% shade
          900: Color(_primaryValue), // 100% shade
        },
      )),
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
    labelStyle: TextStyle(
        color: MaterialColor(
      _primaryValue,
      <int, Color>{
        50: Color(0xFFE1F5FE), // 10% shade
        100: Color(0xFFB3E5FC), // 20% shade
        200: Color(0xFF81D4FA), // 30% shade
        300: Color(0xFF4FC3F7), // 40% shade
        400: Color(0xFF29B6F6), // 50% shade
        500: Color(_primaryValue), // 60% shade (base color)
        600: Color(0xFF0288D1), // 70% shade
        700: Color(0xFF0277BD), // 80% shade
        800: Color(0xFF01579B), // 90% shade
        900: Color(_primaryValue), // 100% shade
      },
    )),
    hintStyle: TextStyle(color: Color(0xffA0A0A0)),
  ),
);
