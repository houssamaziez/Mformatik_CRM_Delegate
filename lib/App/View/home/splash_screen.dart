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
    Get.put(AuthController()).getme(Get.context);
    Timer(Duration(seconds: 10), () {
      Go.replace(context, SpalshScreen());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          fit: BoxFit.cover,
          "assets/icons/logo.png",
          height: 200,
        ),
      ),
    );
  }
}
