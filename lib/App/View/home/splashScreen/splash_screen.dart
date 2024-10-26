import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/Style/style_text.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/image/svg_image.dart';

import '../../../Controller/auth/auth_controller.dart';
import '../../../Service/Location/get_location.dart';
import '../../../Util/Route/Go.dart';

class SpalshScreen extends StatefulWidget {
  const SpalshScreen({super.key});

  @override
  State<SpalshScreen> createState() => _SpalshScreenState();
}

GetStorage spalshscreenfirst = GetStorage();

class _SpalshScreenState extends State<SpalshScreen> {
  LocationDataModel? locationData;
  void fetchLocation() async {
    locationData = await getCurrentLocation();
    print(locationData!.isPermissionGranted);

    if (locationData!.isPermissionGranted) {
      print(
          'Latitude: ${locationData!.latitude}, Longitude: ${locationData!.longitude}');

      Get.put(AuthController()).getme(Get.context);
      spalshscreenfirst.write('key', true);
    } else {
      print('Error: ${locationData!.message}');
    }
  }

  @override
  void initState() {
    super.initState();
    print(spalshscreenfirst.read('key'));
    if (spalshscreenfirst.read('key') == true) {
      fetchLocation();
    }
    // fetchLocation();

    Timer(Duration(seconds: 10), () {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                SpalshScreen(),
            transitionDuration: Duration.zero, // No animation transition
            reverseTransitionDuration: Duration.zero, // No reverse animation
          ),
          (route) => false, // Remove all previous routes
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
              child: SvgImageWidget(assetName: "assets/icons/background.svg")),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2.0,
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
                  "Delegate",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: MediaQuery.of(context).size.height / 25),
                ),
                'Every thing \nunder controlle'.style(
                    fontWeight: FontWeight?.w300,
                    fontSize: MediaQuery.of(context).size.height / 38,
                    color: Theme.of(context).primaryColor),
                Spacer(),
                Row(
                  children: [
                    Spacer(),
                    spalshscreenfirst.read('key') == true
                        ? spinkitwhite
                        : Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: InkWell(
                              onTap: () {
                                fetchLocation();
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
                                      'Get Started',
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
    );
  }
}
