import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/Style/style_text.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/image/svg_image.dart';

import '../../Controller/auth/auth_controller.dart';
import '../../Service/Location/get_location.dart';
import '../../Util/Route/Go.dart';
import '../auth/screen_auth.dart';
import '../home/Settings/language_screen.dart';

class SpalshScreen extends StatefulWidget {
  const SpalshScreen({super.key});

  @override
  State<SpalshScreen> createState() => _SpalshScreenState();
}

GetStorage spalshscreenfirst = GetStorage();

class _SpalshScreenState extends State<SpalshScreen> {
  AppUpdateInfo? _updateInfo;
  bool _isUpdateAvailable = false;
  @override
  void initState() {
    _checkForUpdate().then((onValue) {});

    super.initState();
    Timer(const Duration(seconds: 10), () {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const SpalshScreen(),
            transitionDuration: Duration.zero, // No animation transition
            reverseTransitionDuration: Duration.zero, // No reverse animation
          ),
          (route) => false, // Remove all previous routes
        );
      }
    });
  }

  Future<void> _checkForUpdate() async {
    try {
      final AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();
      setState(() {
        _updateInfo = updateInfo;
        _isUpdateAvailable =
            updateInfo.updateAvailability == UpdateAvailability.updateAvailable;
      });
    } catch (e) {
      print("Error checking for update: $e");
    } finally {
      if (_isUpdateAvailable == true) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showUpdateDialog();
        });
      } else {
        if (_isUpdateAvailable == false) {
          if (spalshscreenfirst.read('key') == true) {
            Get.put(AuthController()).getme(Get.context);
          }
        }
      }
    }
  }

  void _showUpdateDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(Icons.update, color: Colors.blueAccent),
            SizedBox(width: 10),
            Text(
              "Update Available",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "A new version of the app is available. Update now to enjoy the latest features and improvements."
                  .tr,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Icon(
              Icons.new_releases,
              color: Colors.blueAccent,
              size: 60,
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        actions: [
          TextButton(
            onPressed: () {
              if (spalshscreenfirst.read('key') == true) {
                Get.put(AuthController()).getme(Get.context);
              }
              Navigator.of(context).pop();
            }, // غلق الـ Dialog
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey,
              textStyle: const TextStyle(fontSize: 16),
            ),
            child: Text("Later".tr),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _startFlexibleUpdate(); // بدء عملية التحديث
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              textStyle: const TextStyle(fontSize: 16),
            ),
            child: Text(
              "Update Now".tr,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _startFlexibleUpdate() async {
    if (_updateInfo?.updateAvailability == UpdateAvailability.updateAvailable) {
      try {
        await InAppUpdate.startFlexibleUpdate();
        // Optionally, complete the update once download finishes
        await InAppUpdate.completeFlexibleUpdate();
      } catch (e) {
        print("Error starting update: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
                child:
                    SvgImageWidget(assetName: "assets/icons/background.svg")),
            Padding(
              padding: const EdgeInsets.all(16.0),
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
                    "Report".tr,
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
        ),
      ),
    );
  }
}
