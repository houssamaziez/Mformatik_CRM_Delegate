import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/profile_user_controller.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/showsnack.dart';
import '../../../widgets/Buttons/buttonall.dart';
import '../../../widgets/TextField.dart';
import '../../../widgets/app_bar.dart';
import '../../../../Service/AppValidator/AppValidator.dart'; // Adjust the import path accordingly

// ignore: must_be_immutable
class ModifyPassword extends StatefulWidget {
  const ModifyPassword({super.key});

  @override
  State<ModifyPassword> createState() => _ModifyPasswordState();
}

class _ModifyPasswordState extends State<ModifyPassword> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isCurrentPasswordVisible = false;
  bool isNewPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myappbar(context, title: "Change Password".tr),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MyTextfield(
                controller: passwordController,
                label: "Current Password".tr,
                hint: "Enter Current Password".tr,
                validator: (value) => AppValidator.validate(value, [
                  (val) => AppValidator.validateRequired(val,
                      fieldName: "Current Password"),
                  (val) => AppValidator.validatePassword(val,
                      minLength: 4), // Set minLength to 4 for Current Password
                ]),
                isPassword: true,
                isPasswordVisible: isCurrentPasswordVisible,
                passwordVisibleupdate: () {
                  setState(() {
                    isCurrentPasswordVisible = !isCurrentPasswordVisible;
                  });
                },
              ),
              MyTextfield(
                controller: newPasswordController,
                label: "New Password".tr,
                hint: "Enter New Password".tr,
                validator: (value) => AppValidator.validate(value, [
                  (val) => AppValidator.validateRequired(val,
                      fieldName: "New Password"),
                  (val) => AppValidator.validatePassword(val, minLength: 4),
                ]),
                isPassword: true,
                isPasswordVisible: isNewPasswordVisible,
                passwordVisibleupdate: () {
                  setState(() {
                    isNewPasswordVisible = !isNewPasswordVisible;
                  });
                },
              ),
              MyTextfield(
                controller: confirmPasswordController,
                label: "Confirm Password".tr,
                hint: "Re-enter New Password".tr,
                validator: (value) => AppValidator.validate(value, [
                  (val) => AppValidator.validateRequired(val,
                      fieldName: "Confirm Password"),
                  (val) => AppValidator.validatePassword(val, minLength: 4),
                  (val) => newPasswordController.text == val
                      ? null
                      : 'Passwords do not match'.tr,
                ]),
                isPassword: true,
                isPasswordVisible: isConfirmPasswordVisible,
                passwordVisibleupdate: () {
                  setState(() {
                    isConfirmPasswordVisible = !isConfirmPasswordVisible;
                  });
                },
              ),
              const SizedBox(height: 20),
              GetBuilder<ProfileUserController>(
                init: ProfileUserController(),
                builder: (passwordUpdateController) {
                  return ButtonAll(
                    color: Theme.of(context).primaryColor,
                    function: () {
                      if (_formKey.currentState!.validate()) {
                        passwordUpdateController.updatePassword(
                          oldPassword: passwordController.text,
                          newPassword: newPasswordController.text,
                        );
                      }
                    },
                    title: "Save".tr,
                    isloading: passwordUpdateController.isloading,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
