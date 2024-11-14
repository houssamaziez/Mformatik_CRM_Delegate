import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:vibration/vibration.dart';
import 'package:voice_message_package/voice_message_package.dart';
import 'App/Controller/RecordController.dart';
import 'App/Service/permission_handler/mic_handler.dart';
import 'App/View/Voice/screen_voice.dart';
import 'App/View/splashScreen/splash_screen.dart';
import 'App/myapp.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await GetStorage.init();
  print(spalshscreenfirst.read('key'));
  runApp(const MyApp());
}

class Voice extends StatefulWidget {
  Voice({Key? key}) : super(key: key);

  @override
  State<Voice> createState() => _VoiceState();
}

class _VoiceState extends State<Voice> {
  final RecordController recordController = Get.put(RecordController());

  bool _animate = false;

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (_, __, ___) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.grey.shade200,
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [],
              ),
            ),
          ),
          bottomSheet: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Container(
                  height: 90,
                  child: GetBuilder<RecordController>(
                    builder: (controller) {
                      return VoiceMessageViewMy(
                        activeSliderColor: Theme.of(context).primaryColor,
                        circlesColor: Theme.of(context).primaryColor,
                        controller: VoiceController(
                          audioSrc: controller.audioPath,
                          maxDuration: Duration(
                              seconds: controller.audioDuration.inSeconds),
                          isFile: true,
                          onComplete: () {
                            // Do something on complete
                          },
                          onPause: () {
                            // Do something on pause
                          },
                          onPlaying: () {
                            // Do something on playing
                          },
                          onError: (err) {
                            // Do something on error
                          },
                        ),
                        innerPadding: 12,
                        cornerRadius: 20,
                      );
                    },
                  ),
                ),
                Spacer(),
                GetBuilder<RecordController>(builder: (controller) {
                  return controller.audioPath.isEmpty ||
                          controller.isRecording == true
                      ? AvatarGlow(
                          animate: _animate,
                          glowColor: Theme.of(context).primaryColor,
                          child: Material(
                            elevation: 20.0,
                            shape: const CircleBorder(),
                            child: CircleAvatar(
                              backgroundColor: Colors.grey[100],
                              radius: 30.0,
                              child: GetBuilder<RecordController>(
                                builder: (controller) {
                                  return GestureDetector(
                                    onTap: () async {
                                      bool isGranted =
                                          await isMicrophonePermissionGranted();
                                      if (isGranted) {
                                        // Permission is already granted, you can start recording
                                        setState(() => _animate = !_animate);

                                        controller.toggleRecording();
                                        if (await Vibration.hasVibrator() ??
                                            false) {
                                          Vibration.vibrate(
                                              duration:
                                                  100); // Vibrates for 100ms
                                        }
                                        // Start recording logic here
                                      } else {
                                        // Permission is not granted, request it
                                        setState(() => _animate = false);

                                        await requestMicrophonePermission(
                                            context);
                                      }
                                    },
                                    // onLongPress: () async {
                                    //   bool isGranted =
                                    //       await isMicrophonePermissionGranted();
                                    //   if (isGranted) {
                                    //     // Permission is already granted, you can start recording
                                    //     setState(() => _animate = true);

                                    //     controller.toggleRecording();
                                    //     if (await Vibration.hasVibrator() ??
                                    //         false) {
                                    //       Vibration.vibrate(
                                    //           duration:
                                    //               100); // Vibrates for 100ms
                                    //     }
                                    //     // Start recording logic here
                                    //   } else {
                                    //     // Permission is not granted, request it
                                    //     setState(() => _animate = false);

                                    //     await requestMicrophonePermission(
                                    //         context);
                                    //   }
                                    // },
                                    // onLongPressEnd: (details) async {
                                    //   bool isGranted =
                                    //       await isMicrophonePermissionGranted();
                                    //   if (isGranted) {
                                    //     // Permission is already granted, you can start recording
                                    //     setState(() => _animate = false);

                                    //     controller.toggleRecording();
                                    //     // Start recording logic here
                                    //   } else {
                                    //     // Permission is not granted, request it
                                    //     setState(() => _animate = false);
                                    //     await requestMicrophonePermission(
                                    //         context);
                                    //   }
                                    // },
                                    child: Icon(controller.isRecording != true
                                        ? Icons.mic
                                        : Icons.stop_circle_outlined),
                                  );
                                },
                              ),
                            ),
                          ),
                        )
                      : SizedBox.shrink();
                }),
                GetBuilder<RecordController>(
                  builder: (controller) {
                    return controller.audioPath.isNotEmpty &&
                            controller.isRecording == false
                        ? IconButton(
                            onPressed: controller.audioPath.isEmpty
                                ? null
                                : controller.deleteRecording,
                            icon: Icon(Icons.delete))
                        : SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
