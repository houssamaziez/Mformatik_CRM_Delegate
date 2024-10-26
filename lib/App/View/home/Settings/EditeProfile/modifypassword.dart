import 'package:flutter/material.dart';
import 'package:mformatic_crm_delegate/App/View/home/Widgets/textfild.dart';

import '../../../widgets/Buttons/buttonall.dart';
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
                  namecontroller: passwordController,
                  title: "Current Password",
                  suptitle: "Enter Current Password",
                  ispassword: false),
              MyTextfield(
                  namecontroller: newpaswwordController,
                  title: "New Password",
                  suptitle: "Enter New Password",
                  ispassword: true),
              MyTextfield(
                  namecontroller: confirmypasswordController,
                  title: "Confirm Password",
                  suptitle: "Enter the New Password",
                  ispassword: true),
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
