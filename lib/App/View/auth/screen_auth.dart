import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';
import '../../Controller/auth/auth_controller.dart';
import '../widgets/TextField.dart';
import '../widgets/image/svg_image.dart';

class ScreenAuth extends StatelessWidget {
  ScreenAuth({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var cont = Get.put(AuthController(), permanent: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Container(
                  child: SvgImageWidget(
                      assetName: "assets/icons/Background2.svg")),
              Form(
                key: _formKey, //
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 2.6,
                    ),
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
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Username is required'.tr;
                              } else if (value.trim().length < 4) {
                                // Minimum length check
                                return 'Username must be at least 4 characters long'
                                    .tr;
                              }
                              return null; // No error
                            },
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
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Password is required'.tr;
                              } else if (value.trim().length < 4) {
                                // Minimum length check
                                return 'Password must be at least 4 characters long'
                                    .tr;
                              }
                              return null; // No error
                            },
                            isPasswordVisible: _controller.isPasswordVisible,
                            passwordVisibleupdate:
                                _controller.passwordVisibleupdate,
                          );
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.14,
                    ),
                  ],
                ),
              ),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Positioned(
                  bottom: 20,
                  right: 0,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
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
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: InkWell(
                                          onTap: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              _controller.login(context,
                                                  username: _controller
                                                      .namecontroller.text
                                                      .toString(),
                                                  password: _controller
                                                      .passwordcontroller.text
                                                      .toString());
                                            }
                                          },
                                          child: Container(
                                            height: 50, // Specify height
                                            decoration: BoxDecoration(
                                              color: Colors
                                                  .transparent, // Transparent background
                                              border: Border.all(
                                                color: Colors
                                                    .white, // Border color
                                                width: 1.0, // Border width
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10), // Rounded corners
                                            ),
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Login".tr,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          MediaQuery.of(context)
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
