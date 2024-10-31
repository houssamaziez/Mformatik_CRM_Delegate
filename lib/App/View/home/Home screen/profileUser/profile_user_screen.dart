import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/auth/auth_controller.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/Containers/container_blue.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/Dialog/showExitConfirmationDialog.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';

import '../../../../Util/Route/Go.dart';
import '../../../auth/screen_auth.dart';
import '../../../splashScreen/splash_screen.dart';
import '../../Settings/EditeProfile/screenEditeProfile.dart';
import '../../Settings/Widgets/buttons.dart';
import '../../Settings/Widgets/cardstate.dart';

class ProfileUserScreen extends StatelessWidget {
  const ProfileUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<AuthController>(
          init: AuthController(),
          builder: (authController) {
            final user = authController.user!;
            final person = authController.person!;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(180),
                        child: CachedNetworkImage(
                          imageUrl: person.img == null
                              ? 'https://img.freepik.com/premium-photo/stylish-man-flat-vector-profile-picture-ai-generated_606187-310.jpg'
                              : '${dotenv.get('urlHost')}/uploads/' +
                                  person.img!,
                          height: 90,
                          width: 90,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => spinkit,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ],
                  ),
                  Text(person.firstName + " " + person.lastName,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(
                    height: 16,
                  ),
                  liststateprofile(),
                  const SizedBox(
                    height: 16,
                  ),
                  buttonsetting(
                      function: () => Go.to(context, ScreenEditeProfile()),
                      title: "Edite Profile",
                      image: 'assets/icons/edit-info.png',
                      colortext: Colors.black,
                      color: Theme.of(context).cardColor),
                  buttonsetting(
                      function: () {
                        showExitConfirmationDialog(context, onPressed: () {
                          token.write("token", null);
                          spalshscreenfirst.write('key', false);
                          Go.clearAndTo(context, ScreenAuth());
                        },
                            details:
                                'Do you really want to log out of the account?',
                            title: 'Log out');
                      },
                      title: "Log Out       ".tr,
                      image: 'assets/icons/log-out1.png'),
                  const Spacer(),
                ],
              ),
            );
          }),
    );
  }
}
