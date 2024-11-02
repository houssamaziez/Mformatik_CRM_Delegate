import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/myapp.dart';

class screenBlock extends StatelessWidget {
  const screenBlock({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Image.asset(
            "assets/icons/expired.png",
            height: 100,
          )),
          SizedBox(
            height: 10,
          ),
          Text(
            "Your account is blocked, please contact our support team.".tr,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
