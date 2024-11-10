import 'package:flutter/material.dart';

class HomeMenuSelect {
  final String title, icon;
  final Function(BuildContext context) function;

  HomeMenuSelect({
    required this.title,
    required this.icon,
    required this.function,
  });
}
