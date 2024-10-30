import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/View/home/Widgets/textfild.dart';

import '../../../../Controller/auth/auth_controller.dart';
import '../../../../Util/Route/Go.dart';
import '../../../widgets/Buttons/buttonall.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/flutter_spinkit.dart';
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
      body: GetBuilder<AuthController>(
          init: AuthController(),
          builder: (authController) {
            final user = authController.user!;
            final person = authController.person!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: double.infinity,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(180),
                      child: CachedNetworkImage(
                        imageUrl: person.img == null
                            ? 'https://img.freepik.com/premium-photo/stylish-man-flat-vector-profile-picture-ai-generated_606187-310.jpg'
                            : '${dotenv.get('urlHost')}/uploads/' + person.img!,
                        height: 90,
                        width: 90,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => spinkit,
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      person.firstName + " " + person.lastName,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      person.firstName == null
                          ? '...جاري جلب البيانات'
                          : 'id: ' + person.id!.toString(),
                      style: const TextStyle(fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        "Edit Information",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
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
                        image: 'assets/icons/padlock_67326471.png',
                        colortext: Colors.black,
                        color: Theme.of(context).cardColor),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
