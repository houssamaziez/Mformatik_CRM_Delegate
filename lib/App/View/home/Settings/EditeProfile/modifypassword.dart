import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/profile_user_controller.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/showsnack.dart';

import '../../../widgets/Buttons/buttonall.dart';
import '../../../widgets/TextField.dart';
import '../../../widgets/app_bar.dart';

// ignore: must_be_immutable
class ModifyPassword extends StatefulWidget {
  const ModifyPassword({super.key});

  @override
  State<ModifyPassword> createState() => _ModifyPasswordState();
}

class _ModifyPasswordState extends State<ModifyPassword> {
  TextEditingController passwordController = TextEditingController();

  TextEditingController newpaswwordController = TextEditingController();

  TextEditingController confirmypasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool confirmySee = false;
  bool newSee = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myappbar(context, title: "Change Password".tr),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MyTextfield(
                    controller: passwordController,
                    label: "Current Password".tr,
                    hint: "Enter Current Password".tr,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Current Password'.tr;
                      }
                      return null;
                    },
                    isPassword: false),
                MyTextfield(
                    controller: newpaswwordController,
                    label: "New Password".tr,
                    hint: "Enter New Password".tr,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a New Password'.tr;
                      }
                      return null;
                    },
                    passwordVisibleupdate: () {
                      newSee = !newSee;
                      setState(() {});
                    },
                    isPasswordVisible: newSee,
                    isPassword: true),
                MyTextfield(
                    controller: confirmypasswordController,
                    passwordVisibleupdate: () {
                      confirmySee = !confirmySee;
                      setState(() {});
                    },
                    label: "Confirm Password".tr,
                    isPasswordVisible: confirmySee,
                    hint: "Enter the New Password".tr,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Confirm Password'.tr;
                      }
                      return null;
                    },
                    isPassword: true),
                const SizedBox(
                  height: 20,
                ),
                GetBuilder<ProfileUserController>(
                    init: ProfileUserController(),
                    builder: (passwordUpdateController) {
                      return ButtonAll(
                        function: () {
                          if (confirmypasswordController.text ==
                              newpaswwordController.text) {
                            if (_formKey.currentState!.validate())
                              passwordUpdateController.updatePassword(
                                  oldPassword: passwordController.text,
                                  newPassword: newpaswwordController.text);
                          } else {
                            showMessage(context,
                                title: "Make sure the password matches.".tr);
                          }
                        },
                        title: "Save".tr,
                        isloading: passwordUpdateController.isloading,
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
