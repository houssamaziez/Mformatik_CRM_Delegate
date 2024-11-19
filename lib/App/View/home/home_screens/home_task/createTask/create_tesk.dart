import 'dart:io';

import 'package:image/image.dart' as img; // For image compression
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';
import 'package:mformatic_crm_delegate/App/View/home/home_screens/persons/screen_list_persons.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/Buttons/buttonall.dart';
import 'package:vibration/vibration.dart';
import 'package:voice_message_package/voice_message_package.dart';

import '../../../../../Controller/RecordController.dart';
import '../../../../../Controller/home/Person/controller_person.dart';
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
  int reasonId = 0;
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  double? lat;
  double? lng;
  DateTime? requestDate;
  double _compressionProgress = 0.0;
  List<File>? _compressedImages = [];
  bool isCompressImage = false;
  Future<File> _compressImage(XFile file) async {
    setState(() {
      isCompressImage = true;
    });
    final bytes = await file.readAsBytes();
    final img.Image? image = img.decodeImage(bytes);

    final img.Image resized = img.copyResize(image!, width: 500);
    final compressedBytes = img.encodeJpg(resized, quality: 85);

    final compressedImageFile = File('${file.path}_compressed.jpg');
    await compressedImageFile.writeAsBytes(compressedBytes);

    setState(() {
      isCompressImage = false;
    });
    return compressedImageFile;
  }

  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      File compressedImage = await _compressImage(photo);
      setState(() {
        _compressedImages!.add(compressedImage);
      });
    }
  }

  Future<void> _selectImagesFromGallery() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      for (int i = 0; i < pickedFiles.length; i++) {
        File compressedImage = await _compressImage(pickedFiles[i]);
        _compressedImages!.add(compressedImage);

        setState(() {
          _compressionProgress = ((i + 1) / pickedFiles.length) * 100;
        });
      }
      setState(() {
        _compressedImages = _compressedImages;
        _compressionProgress = 0.0;
      });
    }
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: requestDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        requestDate = pickedDate;
      });
    }
  }

  bool _animate = false;
  bool _iShowVocal = false;

  @override
  void dispose() {
    Get.delete<ControllerPerson>();
    super.dispose();
  }

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
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Select Responsable",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    Go.to(
                        context,
                        const ScreenListPersons(
                          tag: "Responsable",
                        ));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
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
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: GetBuilder<ControllerPerson>(
                                  init: ControllerPerson(),
                                  builder: (personController) {
                                    return Text(
                                      personController.responsable == null
                                          ? "Select Responsable"
                                          : personController
                                                  .responsable!.firstName +
                                              " " +
                                              personController
                                                  .responsable!.firstName,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: personController.responsable ==
                                                null
                                            ? Colors.grey
                                            : Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                      ),
                                    );
                                  }),
                            ),
                            Spacer(),
                            GetBuilder<ControllerPerson>(
                                init: ControllerPerson(),
                                builder: (personController) {
                                  return personController.responsable != null
                                      ? IconButton(
                                          onPressed: () {
                                            personController
                                                .closePerson("Responsable");
                                          },
                                          icon: Icon(
                                            Icons.close,
                                            size: 14,
                                          ))
                                      : SizedBox.shrink();
                                })
                          ],
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
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    Go.to(
                        context,
                        const ScreenListPersons(
                          tag: "Observator",
                        ));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
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
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: GetBuilder<ControllerPerson>(
                                  init: ControllerPerson(),
                                  builder: (personController) {
                                    return Text(
                                      personController.observator == null
                                          ? "Select Observator"
                                          : personController
                                                  .observator!.firstName +
                                              " " +
                                              personController
                                                  .observator!.lastName,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: personController.observator ==
                                                null
                                            ? Colors.grey
                                            : Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                      ),
                                    );
                                  }),
                            ),
                            Spacer(),
                            GetBuilder<ControllerPerson>(
                                init: ControllerPerson(),
                                builder: (personController) {
                                  return personController.observator != null
                                      ? IconButton(
                                          onPressed: () {
                                            personController
                                                .closePerson("Observator");
                                          },
                                          icon: Icon(
                                            Icons.close,
                                            size: 14,
                                          ))
                                      : SizedBox.shrink();
                                })
                          ],
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
                  height: 10,
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
                  height: 10,
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
                  onTap: _selectImagesFromGallery,
                  child: const Row(
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
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: _takePhoto,
                  child: const Row(
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
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () async {
                    setState(() {
                      _iShowVocal = !_iShowVocal;

                      // showContainers = !showContainers; // Toggle animation
                    });
                    if (_iShowVocal) {
                      bool isGranted = await isMicrophonePermissionGranted();
                      if (isGranted) {
                        setState(() => _animate = true);
                        controllerVoice.toggleRecording();
                        if (await Vibration.hasVibrator() ?? false) {
                          Vibration.vibrate(duration: 100);
                        }
                      } else {
                        setState(() => _animate = false);
                        await requestMicrophonePermission(context);
                      }
                    }
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.mic,
                        color: Colors.red,
                      ),
                      SizedBox(width: 10),
                      Text("Vocal")
                    ],
                  ),
                ), // ___________________________________________________vocal____________________________________________________
                SizedBox(
                  height: 10,
                ),
                if (_iShowVocal == true)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut, // Smooth transition curve
                    height: 110, // Adjust height based on toggle
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white, // Background color
                          border: Border.all(
                            color:
                                Theme.of(context).primaryColor, // Border color
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
                                activeSliderColor:
                                    Theme.of(context).primaryColor,
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
                                                controllerVoice
                                                    .toggleRecording();
                                                if (await Vibration
                                                        .hasVibrator() ??
                                                    false) {
                                                  Vibration.vibrate(
                                                      duration: 100);
                                                }
                                              } else {
                                                setState(
                                                    () => _animate = false);
                                                await requestMicrophonePermission(
                                                    context);
                                              }
                                            },
                                            child: Icon(controllerVoice
                                                        .isRecording !=
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
                                      onPressed: controllerVoice
                                              .audioPath.isEmpty
                                          ? null
                                          : () async {
                                              setState(() {
                                                _iShowVocal =
                                                    !_iShowVocal; // Toggle animation
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

                const SizedBox(
                  height: 10,
                ),
                if (_compressionProgress > 0 && _compressionProgress < 100) ...[
                  const SizedBox(height: 16),
                  Text(
                      'Loading images: ${_compressionProgress.toStringAsFixed(0)}%'),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: _compressionProgress / 100,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
                if (_compressedImages != null &&
                    _compressedImages!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: _compressedImages!.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Image.file(
                            _compressedImages![index],
                            fit: BoxFit.cover,
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  _compressedImages!
                                      .remove(_compressedImages![index]);
                                });
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ))
                        ],
                      );
                    },
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
                SizedBox(
                  height: 20,
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
