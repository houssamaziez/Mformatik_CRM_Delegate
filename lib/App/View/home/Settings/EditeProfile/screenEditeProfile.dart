import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/profile_user_controller.dart';
import 'package:mformatic_crm_delegate/App/View/home/Widgets/textfild.dart';

import '../../../../Controller/auth/auth_controller.dart';
import '../../../../Util/Route/Go.dart';
import '../../../widgets/Buttons/buttonall.dart';
import '../../../widgets/TextField.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/flutter_spinkit.dart';
import '../Widgets/buttons.dart';
import 'modifypassword.dart';

// ignore: must_be_immutable
class ScreenEditeProfile extends StatefulWidget {
  ScreenEditeProfile({super.key});

  @override
  State<ScreenEditeProfile> createState() => _ScreenEditeProfileState();
}

class _ScreenEditeProfileState extends State<ScreenEditeProfile> {
  TextEditingController firstNameController = TextEditingController();

  TextEditingController lastNameController = TextEditingController();

  AuthController usercontroller = Get.put(AuthController());
  @override
  void initState() {
    firstNameController.text = usercontroller.person!.firstName;
    lastNameController.text = usercontroller.person!.lastName;
    // TODO: implement initState
    super.initState();
  }

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
                      height: 10,
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
                          : '@' + user.username!.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).primaryColor),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Edit Information",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextfield(
                      controller: firstNameController,
                      label: "First Name",
                      hint: "First Name",
                      isPassword: false,
                    ),
                    MyTextfield(
                      controller: lastNameController,
                      label: "last Name",
                      hint: "last Name",
                      isPassword: false,
                    ),
                    // MyTextfield(
                    //     controller: nameController,
                    //     label: "Mobile Number*",
                    //     hint: "102030405060",
                    //     isPassword: false),
                    const SizedBox(
                      height: 20,
                    ),
                    GetBuilder<ProfileUserController>(
                        init: ProfileUserController(),
                        builder: (updateController) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ButtonAll(
                                isloading: updateController.isloading,
                                function: () {
                                  updateController.updateProfile(
                                      firstName: firstNameController.text,
                                      lastName: lastNameController.text);
                                },
                                title: "Edit Basic Information"),
                          );
                        }),
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
