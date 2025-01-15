
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/Style/style_text.dart';
import 'package:mformatic_crm_delegate/App/View/splashScreen/splash_screen.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';

import '../../../Util/Route/Go.dart';
import '../../auth/screen_auth.dart';
import '../../home/Settings/language_screen.dart';
import '../../widgets/image/svg_image.dart';

class BodySplash extends StatelessWidget {
  const BodySplash({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            child:
                SvgImageWidget(assetName: "assets/icons/background.svg")),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              IconButton(
                  onPressed: () {
                    Go.to(context, const LanguageScreen());
                  },
                  icon: const Icon(
                    Icons.language,
                    color: Colors.white,
                  )),
              SizedBox(
                height: MediaQuery.of(context).size.height / 2.4,
              ),
              Hero(
                tag: "logo",
                child: Image.asset(
                  "assets/icons/logo.png",
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height / 10,
                ),
              ),
              Text(
                "Reporting".tr,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: MediaQuery.of(context).size.height / 25),
              ),
              'Every thing \nunder controlle'.tr.style(
                  fontWeight: FontWeight?.w300,
                  fontSize: MediaQuery.of(context).size.height / 38,
                  color: Theme.of(context).primaryColor),
              const Spacer(),
              Row(
                children: [
                  const Spacer(),
                  spalshscreenfirst.read('key') == true
                      ? spinkitwhite
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: InkWell(
                            onTap: () {
                              Go.clearAndTo(context, ScreenAuth());
                            },
                            child: Container(
                              height: 50, // Specify height
                              decoration: BoxDecoration(
                                color: Colors
                                    .transparent, // Transparent background
                                border: Border.all(
                                  color: Colors.white, // Border color
                                  width: 1.0, // Border width
                                ),
                                borderRadius: BorderRadius.circular(
                                    10), // Rounded corners
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Get Started'.tr,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: MediaQuery.of(context)
                                                .size
                                                .height /
                                            55), // Text color
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
