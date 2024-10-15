import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';

import '../../Controller/auth/auth_controller.dart';

class SpalshScreen extends StatefulWidget {
  const SpalshScreen({super.key});

  @override
  State<SpalshScreen> createState() => _SpalshScreenState();
}

class _SpalshScreenState extends State<SpalshScreen> {
  @override
  void initState() {
    super.initState();

    // Use Get's context safely with mounted check
    Get.put(AuthController()).getme(Get.context);

    // Set a Timer to navigate after 10 seconds
    Timer(Duration(seconds: 10), () {
      if (mounted) {
        // Check if the widget is still mounted
        Go.clearAndTo(context, SpalshScreen()); // Navigate safely
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/icons/logo.png",
          fit: BoxFit.cover,
          height: 200,
        ),
      ),
    );
  }
}
