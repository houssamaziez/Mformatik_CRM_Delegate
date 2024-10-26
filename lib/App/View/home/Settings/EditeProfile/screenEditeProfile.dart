import 'package:flutter/material.dart';
import 'package:mformatic_crm_delegate/App/View/home/Widgets/textfild.dart';

import '../../../../Util/Route/Go.dart';
import '../../../widgets/Buttons/buttonall.dart';
import '../../../widgets/app_bar.dart';
import '../Widgets/buttons.dart';
import 'modifypassword.dart';

// ignore: must_be_immutable
class ScreenEditeProfile extends StatelessWidget {
  ScreenEditeProfile({super.key});
  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myappbar(context, title: "User Information"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: double.infinity,
              ),
              Image.asset(
                "assets/images/profile.png",
                height: 76,
                width: 76,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "user name",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const Text(
                "nawaf1234@gmail.com",
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
              const SizedBox(
                height: 20,
              ),
              const Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  "Edit Information",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
              ),
              MyTextfield(
                  namecontroller: nameController,
                  title: "Full Name*",
                  suptitle: "full name",
                  ispassword: false),
              MyTextfield(
                  namecontroller: nameController,
                  title: "Email*",
                  suptitle: "some1234@gmail.com",
                  ispassword: false),
              MyTextfield(
                  namecontroller: nameController,
                  title: "Mobile Number*",
                  suptitle: "102030405060",
                  ispassword: false),
              const SizedBox(
                height: 20,
              ),
              ButtonAll(function: () {}, title: "Edit Basic Information"),
              buttonsetting(
                  function: () {
                    Go.to(context, ModifyPassword());
                  },
                  title: "Change Password",
                  image: 'assets/images/padlock_67326471.png',
                  colortext: Colors.black,
                  color: Theme.of(context).cardColor),
            ],
          ),
        ),
      ),
    );
  }
}
