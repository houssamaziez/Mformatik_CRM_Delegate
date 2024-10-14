import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/Style/style_text.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/Buttons/buttonall.dart';

import '../../Controller/auth/auth_controller.dart';
import '../../Util/Theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/TextField.dart';

class ScreenAuth extends StatelessWidget {
  ScreenAuth({super.key});
  TextEditingController namecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Login Screen".tr.style(color: ColorsApp.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyTextfield(
              controller: namecontroller,
              label: 'Username',
              hint: '',
              isPassword: false,
            ),
            const SizedBox(
              height: 10,
            ),
            GetBuilder<AuthController>(
                init: AuthController(),
                builder: (_controller) {
                  return MyTextfield(
                    controller: passwordcontroller,
                    label: 'Password',
                    hint: '******',
                    isPassword: true,
                  );
                }),
            const SizedBox(
              height: 10,
            ),
            GetBuilder<AuthController>(
                init: AuthController(),
                builder: (_controller) {
                  return ButtonAll(
                    function: () {
                      _controller.login(username: "admin", password: "123456");
                    },
                    title: "Login",
                    islogin: _controller.isLoading,
                  );
                }),
          ],
        ).paddingAll(10),
      ),
    );
  }
}
