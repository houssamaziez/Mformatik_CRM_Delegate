import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/Buttons/buttonall.dart';
import 'package:vibration/vibration.dart';
import 'package:voice_message_package/voice_message_package.dart';

import '../../../../../Controller/RecordController.dart';
import '../../../../../Service/permission_handler/mic_handler.dart';
import '../../../../Voice/screen_voice.dart';

// ignore: must_be_immutable
class ScreenCreateTask extends StatefulWidget {
  ScreenCreateTask({super.key});

  @override
  State<ScreenCreateTask> createState() => _ScreenCreateTaskState();
}

class _ScreenCreateTaskState extends State<ScreenCreateTask> {
  TextEditingController controller = TextEditingController();
  final RecordController recordController = Get.put(RecordController());

  bool _animate = false;
  bool showContainers = false;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecordController>(builder: (controllerVoice) {
      final controlledVoiceMessageViewMy = VoiceController(
        audioSrc: controllerVoice.audioPath,
        maxDuration: Duration(seconds: controllerVoice.audioDuration.inSeconds),
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
          // Handle error
        },
      );

      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Create Task",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select Responsable",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 3,
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color
                      border: Border.all(
                        color: Theme.of(context).primaryColor, // Border color
                        width: 1.0, // Border width
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            "Select Responsable",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Select Observator",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 3,
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color
                      border: Border.all(
                        color: Theme.of(context).primaryColor, // Border color
                        width: 1.0, // Border width
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            "Select Observator",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Label",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 3,
                ),
                TextFormField(
                  controller: controller,
                  cursorColor: Theme.of(context)
                      .primaryColor, // Change the cursor color here
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Label",
                    enabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor)),
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor)),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Label is required'.tr;
                    } else if (value.trim().length < 4) {
                      // Minimum length check
                      return 'Label must be at least 4 characters long'.tr;
                    }
                    return null; // No error
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Description",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 3,
                ),
                TextFormField(
                  minLines: 5, maxLength: 250, maxLines: 6,
                  controller: controller,
                  cursorColor: Theme.of(context)
                      .primaryColor, // Change the cursor color here
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Description",
                    enabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor)),
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor)),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Description is required'.tr;
                    } else if (value.trim().length < 4) {
                      // Minimum length check
                      return 'Description must be at least 4 characters long'
                          .tr;
                    }
                    return null; // No error
                  },
                ),
                InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      Icon(
                        Icons.image_outlined,
                        color: Colors.green,
                      ),
                      SizedBox(width: 10),
                      Text("Photos")
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      Icon(
                        Icons.camera_alt,
                        color: Colors.blue,
                      ),
                      SizedBox(width: 10),
                      Text("Camera")
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      showContainers = !showContainers; // Toggle animation
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.mic,
                        color: Colors.red,
                      ),
                      SizedBox(width: 10),
                      Text("Vocal")
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut, // Smooth transition curve
                  height:
                      showContainers ? 110 : 0, // Adjust height based on toggle
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white, // Background color
                        border: Border.all(
                          color: Theme.of(context).primaryColor, // Border color
                          width: 1.0, // Border width
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          Container(
                            height: 90,
                            child: VoiceMessageViewMy(
                              activeSliderColor: Theme.of(context).primaryColor,
                              circlesColor: Theme.of(context).primaryColor,
                              controller: controlledVoiceMessageViewMy,
                              innerPadding: 12,
                              cornerRadius: 20,
                              size: 50,
                            ),
                          ),
                          const Spacer(),
                          controllerVoice.audioPath.isEmpty ||
                                  controllerVoice.isRecording == true
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: AvatarGlow(
                                    animate: _animate,
                                    glowColor: Theme.of(context).primaryColor,
                                    child: Material(
                                      elevation: 20.0,
                                      shape: const CircleBorder(),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.grey[100],
                                        radius: 30.0,
                                        child: GestureDetector(
                                          onTap: () async {
                                            bool isGranted =
                                                await isMicrophonePermissionGranted();
                                            if (isGranted) {
                                              setState(
                                                  () => _animate = !_animate);
                                              controllerVoice.toggleRecording();
                                              if (await Vibration
                                                      .hasVibrator() ??
                                                  false) {
                                                Vibration.vibrate(
                                                    duration: 100);
                                              }
                                            } else {
                                              setState(() => _animate = false);
                                              await requestMicrophonePermission(
                                                  context);
                                            }
                                          },
                                          child: Icon(
                                              controllerVoice.isRecording !=
                                                      true
                                                  ? Icons.mic
                                                  : Icons.stop_circle_outlined),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                          SizedBox(
                            child: controllerVoice.audioPath.isNotEmpty &&
                                    controllerVoice.isRecording == false
                                ? IconButton(
                                    onPressed: controllerVoice.audioPath.isEmpty
                                        ? null
                                        : () async {
                                            setState(() {
                                              showContainers =
                                                  !showContainers; // Toggle animation
                                            });
                                            await controlledVoiceMessageViewMy
                                                .stopPlaying();
                                            controllerVoice.deleteRecording();
                                          },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ))
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ButtonAll(function: () {}, title: 'add Task'),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
