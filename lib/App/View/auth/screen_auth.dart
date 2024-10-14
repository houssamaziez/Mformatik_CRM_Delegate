import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/Style/style_text.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/extension_padding.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/Buttons/buttonall.dart';

import '../../Controller/auth/auth_controller.dart';
import '../../Util/Theme/colors.dart';

import '../home/language_screen.dart';
import '../widgets/TextField.dart';

// ignore: must_be_immutable
class ScreenAuth extends StatelessWidget {
  ScreenAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Go.to(context, LanguageScreen());
                },
                icon: Icon(Icons.language))
          ],
          title: "Login Screen".tr.style(
                color: ColorsApp.white,
                fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
              )),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                fit: BoxFit.cover,
                "assets/icons/logo.png",
                height: 180,
              ),
            ),
            GetBuilder<AuthController>(
                init: AuthController(),
                builder: (_controller) {
                  return MyTextfield(
                    controller: _controller.namecontroller,
                    label: 'Username'.tr,
                    hint: 'Write Username'.tr,
                  );
                }),
            const SizedBox(
              height: 10,
            ),
            GetBuilder<AuthController>(
                init: AuthController(),
                builder: (_controller) {
                  return MyTextfield(
                    controller: _controller.passwordcontroller,
                    label: 'Password'.tr,
                    hint: 'Write Password'.tr,
                    isPassword: true,
                    isPasswordVisible: _controller.isPasswordVisible,
                    passwordVisibleupdate: _controller.passwordVisibleupdate,
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
                      _controller.login(context,
                          username: _controller.namecontroller.text.toString(),
                          password:
                              _controller.passwordcontroller.text.toString());
                    },
                    title: "Login".tr,
                    islogin: _controller.isLoading,
                  );
                }).paddingAll()
          ],
        ),
      ),
    );
  }
}
