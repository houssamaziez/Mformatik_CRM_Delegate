import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/profile_user_controller.dart';

import '../../../../Controller/auth/auth_controller.dart';
import '../../../../Service/AppValidator/AppValidator.dart';
import '../../../../Util/Route/Go.dart';
import '../../../widgets/Buttons/buttonall.dart';
import '../../../widgets/TextField.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/flutter_spinkit.dart';
import '../Widgets/buttons.dart';
import 'modifypassword.dart';

class ScreenEditeProfile extends StatefulWidget {
  const ScreenEditeProfile({super.key});

  @override
  State<ScreenEditeProfile> createState() => _ScreenEditeProfileState();
}

class _ScreenEditeProfileState extends State<ScreenEditeProfile> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final AuthController userController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    firstNameController.text = userController.person?.firstName ?? '';
    lastNameController.text = userController.person?.lastName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myappbar(context, title: "User Information".tr),
      body: GetBuilder<AuthController>(
          init: AuthController(),
          builder: (authController) {
            final user = authController.user;
            final person = authController.person;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      _buildProfileImage(person?.img),
                      const SizedBox(height: 10),
                      _buildUserInfo(person, user),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Edit Information".tr,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildTextFields(),
                      const SizedBox(height: 20),
                      _buildUpdateButton(),
                      _buildChangePasswordButton(),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget _buildProfileImage(String? imgUrl) {
    final defaultImage =
        'https://img.freepik.com/premium-photo/stylish-man-flat-vector-profile-picture-ai-generated_606187-310.jpg';
    final imageUrl = imgUrl != null
        ? '${dotenv.get('urlHost')}/uploads/$imgUrl'
        : defaultImage;

    return ClipRRect(
      borderRadius: BorderRadius.circular(180),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: 90,
        width: 90,
        fit: BoxFit.cover,
        placeholder: (context, url) => spinkit,
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }

  Widget _buildUserInfo(person, user) {
    return Column(
      children: [
        Text(
          '${person?.firstName ?? ''} ${person?.lastName ?? ''}',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        Text(
          person?.firstName == null
              ? 'Fetching data...'.tr
              : '@${user?.username ?? ''}',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildTextFields() {
    return Column(
      children: [
        MyTextfield(
          controller: firstNameController,
          label: "First Name".tr,
          hint: "First Name".tr,
          isPassword: false,
          validator: (value) => AppValidator.validate(value, [
            (v) => AppValidator.validateRequired(v, fieldName: 'First Name'),
            (v) => AppValidator.validateLength(v, minLength: 3, maxLength: 15),
          ]),
        ),
        MyTextfield(
          controller: lastNameController,
          label: "Last Name".tr,
          hint: "Last Name".tr,
          isPassword: false,
          validator: (value) => AppValidator.validate(value, [
            (v) => AppValidator.validateRequired(v, fieldName: 'Last Name'),
            (v) => AppValidator.validateLength(v, minLength: 3, maxLength: 15),
          ]),
        ),
      ],
    );
  }

  Widget _buildUpdateButton() {
    return GetBuilder<ProfileUserController>(
      init: ProfileUserController(),
      builder: (updateController) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ButtonAll(
            isloading: updateController.isloading,
            function: () {
              if (_formKey.currentState!.validate()) {
                updateController.updateProfile(
                  firstName: firstNameController.text,
                  lastName: lastNameController.text,
                );
              }
            },
            title: "Edit Basic Information".tr,
          ),
        );
      },
    );
  }

  Widget _buildChangePasswordButton() {
    return buttonsetting(
      function: () {
        Go.to(context, ModifyPassword());
      },
      title: "Change Password".tr,
      image: 'assets/icons/padlock_67326471.png',
      colortext: Colors.black,
      color: Theme.of(context).cardColor,
    );
  }
}
