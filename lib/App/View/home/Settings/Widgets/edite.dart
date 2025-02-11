import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/auth/auth_controller.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/Style/style_text.dart';

import '../../../../Util/Route/Go.dart';
import '../../../widgets/flutter_spinkit.dart';
import '../EditeProfile/screenEditeProfile.dart';

editeProfile(context) {
  return GetBuilder<AuthController>(
      init: AuthController(),
      builder: (authController) {
        final user = authController.user!;
        final person = authController.person!;
        return Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(180),
                child: CachedNetworkImage(
                  imageUrl: person.img == null
                      ? 'https://img.freepik.com/premium-photo/stylish-man-flat-vector-profile-picture-ai-generated_606187-310.jpg'
                      : '${dotenv.get('urlHost')}/api/uploads/' + person.img!,
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => spinkit,
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),

            Expanded(
              child: GetBuilder<AuthController>(
                  init: AuthController(),
                  builder: (controller) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              controller.person!.firstName == null
                                  ? 'Fetching data...'.tr
                                  : controller.person!.firstName!.toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            " ".style(),
                            Text(
                              controller.person!.lastName == null
                                  ? 'Fetching data...'.tr
                                  : controller.person!.lastName.toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        Text(
                          controller.user!.username == null
                              ? 'Fetching data...'.tr
                              : '@' + controller.user!.username!.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                      ],
                    );
                  }),
            ),

            // }
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  onTap: () {
                    Go.to(context, ScreenEditeProfile());
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.edit,
                      color: Theme.of(context).primaryColor,
                    ),
                  )),
            ),
          ],
        );
      });
}
