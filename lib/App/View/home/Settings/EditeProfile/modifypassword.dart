import 'package:flutter/material.dart';
import 'package:mformatic_crm_delegate/App/View/home/Widgets/textfild.dart';

import '../../../widgets/Buttons/buttonall.dart';
import '../../../widgets/TextField.dart';
import '../../../widgets/app_bar.dart';

// ignore: must_be_immutable
class ModifyPassword extends StatelessWidget {
  ModifyPassword({super.key});
  TextEditingController passwordController = TextEditingController();
  TextEditingController newpaswwordController = TextEditingController();
  TextEditingController confirmypasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myappbar(context, title: "Change Password"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MyTextfield(
                  controller: passwordController,
                  label: "Current Password",
                  hint: "Enter Current Password",
                  isPassword: false),
              MyTextfield(
                  controller: newpaswwordController,
                  label: "New Password",
                  hint: "Enter New Password",
                  isPassword: true),
              MyTextfield(
                  controller: confirmypasswordController,
                  label: "Confirm Password",
                  hint: "Enter the New Password",
                  isPassword: true),
              const SizedBox(
                height: 20,
              ),
              ButtonAll(function: () {}, title: "Save"),
            ],
          ),
        ),
      ),
    );
  }
}
