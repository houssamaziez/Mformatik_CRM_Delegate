import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/profile_user_controller.dart';
import 'package:mformatic_crm_delegate/App/View/home/Widgets/textfild.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/showsnack.dart';

import '../../../widgets/Buttons/buttonall.dart';
import '../../../widgets/TextField.dart';
import '../../../widgets/app_bar.dart';

// ignore: must_be_immutable
class ModifyPassword extends StatefulWidget {
  ModifyPassword({super.key});

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
      appBar: myappbar(context, title: "Change Password"),
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
                    label: "Current Password",
                    hint: "Enter Current Password",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Current Password';
                      }
                      return null;
                    },
                    isPassword: false),
                MyTextfield(
                    controller: newpaswwordController,
                    label: "New Password",
                    hint: "Enter New Password",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a New Password';
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
                    label: "Confirm Password",
                    isPasswordVisible: confirmySee,
                    hint: "Enter the New Password",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Confirm Password';
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
                                title: "Make sure the password matches.");
                          }
                        },
                        title: "Save",
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
