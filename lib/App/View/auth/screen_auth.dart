import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/Style/style_text.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/extension_padding.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/Buttons/buttonall.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';
import '../../Controller/auth/auth_controller.dart';
import '../../Util/Theme/colors.dart';
import '../home/Settings/language_screen.dart';
import '../widgets/TextField.dart';
import '../widgets/image/svg_image.dart';

class ScreenAuth extends StatelessWidget {
  ScreenAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
              child: SvgImageWidget(assetName: "assets/icons/Background2.svg")),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2.6,
                ),
                // Hero(
                //   tag: 'logo',
                //   child: Center(
                //     child: Image.asset(
                //       fit: BoxFit.cover,
                //       "assets/icons/logo.png",
                //       height: 180,
                //     ),
                //   ),
                // ),
                Hero(
                  tag: "logo",
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/icons/logo.png",
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.height / 10,
                    ),
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
                        passwordVisibleupdate:
                            _controller.passwordVisibleupdate,
                      );
                    }),
                const SizedBox(
                  height: 10,
                ),
                // GetBuilder<AuthController>(
                //     init: AuthController(),
                //     builder: (_controller) {
                //       return ButtonAll(
                //         function: () {
                //           _controller.login(context,
                //               username:
                //                   _controller.namecontroller.text.toString(),
                //               password: _controller.passwordcontroller.text
                //                   .toString());
                //         },
                //         title: "Logind".tr,
                //         islogin: _controller.isLoading,
                //       );
                //     }).paddingAll(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.13,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 150,
              child: Row(
                children: [
                  Spacer(),
                  GetBuilder<AuthController>(
                      init: AuthController(),
                      builder: (_controller) {
                        return SizedBox(
                          width: 200,
                          child: _controller.isLoading
                              ? spinkitwhite
                              : Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: InkWell(
                                    onTap: () {
                                      _controller.login(context,
                                          username: _controller
                                              .namecontroller.text
                                              .toString(),
                                          password: _controller
                                              .passwordcontroller.text
                                              .toString());
                                    },
                                    child: Container(
                                      height: 50, // Specify height
                                      decoration: BoxDecoration(
                                        color: Colors
                                            .transparent, // Transparent background
                                        border: Border.all(
                                          color: Colors.white, // Border color
                                          width: 1.0, // Border width
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            10), // Rounded corners
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Login".tr,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    55), // Text color
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        );
                      }),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
