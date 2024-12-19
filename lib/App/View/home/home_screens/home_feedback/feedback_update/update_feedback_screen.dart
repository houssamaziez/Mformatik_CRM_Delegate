import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/Style/style_text.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/Buttons/buttonall.dart';
import 'package:vibration/vibration.dart';
// import 'package:voice_message_package/voice_message_package.dart';
import '../../../../../Controller/RecordController.dart';
import '../../../../../Controller/home/feedback/feedback_controller.dart';
import '../../../../../Controller/home/reasons_feedback_controller.dart';
import '../../../../../Controller/widgetsController/date_controller.dart';
import '../../../../../Controller/widgetsController/expandable_controller.dart';
import '../../../../../Model/feedback.dart';
import '../../../../../Model/reason_feedback.dart';
import '../../../../../Service/AppValidator/AppValidator.dart';
import '../../../../../Service/Location/get_location.dart';
import '../../../../../Service/permission_handler/mic_handler.dart';
import '../../../../../Util/Date/formatDate.dart';
import '../../../../../Util/Style/stylecontainer.dart';
import '../../../../Voice/screen_voice.dart';
import '../../../../widgets/Date/date_picker.dart';
import '../../../../widgets/flutter_spinkit.dart';
import '../../../../widgets/showsnack.dart';
import '../../../../widgets/voice_vocal_view/voice_play.dart';
import '../feedback_details/feedback_profile_screen.dart';
import 'package:image/image.dart' as img;

import 'widgets/select_reasonupdate.dart'; // For image compression

class UpdateFeedbackScreen extends StatefulWidget {
  final FeedbackMission feedback;

  final String? pathVoice;

  UpdateFeedbackScreen({required this.feedback, this.pathVoice});

  @override
  _UpdateFeedbackScreenState createState() => _UpdateFeedbackScreenState();
}

class _UpdateFeedbackScreenState extends State<UpdateFeedbackScreen> {
  final FeedbackController feedbackController = Get.put(FeedbackController());
  final TextEditingController labelController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController latController = TextEditingController();
  final TextEditingController lngController = TextEditingController();
  final TextEditingController requestDateController = TextEditingController();
  final TextEditingController clientIdController = TextEditingController();
  final TextEditingController feedbackModelIdController =
      TextEditingController();
  final ExpandableControllerFeedback expandableController =
      Get.put(ExpandableControllerFeedback());
  final _formKey = GlobalKey<FormState>();
  List<dynamic> images = [];
  FeedbackMission? feedbacklocal;

  String? feedbackVoicepathB;
//  to do fix le mam list send

  int feedbackinitlanght = 0;
  @override
  void initState() {
    feedbackVoicepathB = widget.feedback.voice;
    feedbackinitlanght = widget.feedback.gallery.length;
    feedbacklocal = widget.feedback;
    print(feedbacklocal!.feedbackModelId.toString());
    super.initState();
    expandableController.controllerTextEditingController!.text =
        feedbacklocal!.label.toString();
    labelController.text = feedbacklocal!.label ?? '';
    descController.text = feedbacklocal!.desc ?? '';
    latController.text = feedbacklocal!.lat ?? '';
    lngController.text = feedbacklocal!.lng ?? '';
    requestDateController.text = feedbacklocal!.requestDate ?? '';
    clientIdController.text = feedbacklocal!.clientId.toString();
    feedbackModelIdController.text = feedbacklocal!.feedbackModelId.toString();

    images = feedbacklocal!.gallery;
  }

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

  final ImagePicker _picker = ImagePicker();

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

  final RecordController recordController = Get.put(RecordController());

  // VoiceController? controlledVoiceMessageViewMy;
  bool _animate = false;
  bool _iShowVocal = false;

  @override
  void dispose() {
    Get.delete<ExpandableControllerFeedback>();
    Get.delete<DateController>();
    super.dispose();
  }

  // VoiceController? _voiceController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Feedback'.tr)),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GetBuilder<ExpandableControllerFeedback>(
                builder: (controller) {
                  return ReasonsSelectorFeedbackupd(
                    id: controller.selectedItem.value != null
                        ? controller.selectedItem.value!.id?.toString() ??
                            widget.feedback.feedbackModelId.toString()
                        : widget.feedback.feedbackModelId.toString(),
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              _description(),
              SizedBox(
                height: 10,
              ),
              _datePickerWidget(),
              _gallery(context),
              SizedBox(
                height: 10,
              ),
              _selectImages(),
              // if (_iShowVocal == false) selectVocaltitle(context),
              // SizedBox(
              //   height: 10,
              // ),
              // if (feedbackVoicepathB != null) vocalbefor(context),
              // SizedBox(
              //   height: 10,
              // ),
              // if (_iShowVocal == true) vocalafter(context),
              if (_compressionProgress > 0 && _compressionProgress < 100 ||
                  isCompressImage) ...[
                const SizedBox(height: 16),
                Text('Loading images:'.tr +
                    " ${_compressionProgress.toStringAsFixed(0)}%"),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: _compressionProgress / 100,
                  color: Theme.of(context).primaryColor,
                ),
              ],
              if (_compressedImages != null &&
                  _compressedImages!.isNotEmpty) ...[
                const SizedBox(height: 8),
                imageSelect(),
              ],
              _buttonUpdate(),
            ],
          ),
        ),
      ),
    );
  }

  GetBuilder<RecordController> selectVocaltitle(BuildContext context) {
    return GetBuilder<RecordController>(builder: (controllerVoice) {
      return InkWell(
        onTap: () async {
          setState(() {
            _iShowVocal = !_iShowVocal;

            // showContainers = !showContainers; // Toggle animation
          });
          if (_iShowVocal) {
            bool isGranted = await isMicrophonePermissionGranted();
            if (isGranted) {
              // await controlledVoiceMessageViewMy!.stopPlaying();
              controllerVoice.deleteRecording();
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
      );
    });
  }

  Column _buttonUpdate() {
    return Column(
      children: [
        const SizedBox(height: 20),
        isCompressImage != true
            ? GetBuilder<FeedbackController>(
                init: FeedbackController(),
                builder: (xontrolllerFeedback) {
                  return ButtonAll(
                    color: Theme.of(context).primaryColor,
                    function: _handleUpdateFeedback,
                    title: 'Update Feedback'.tr,
                    isloading: xontrolllerFeedback.isLoadingadd,
                  );
                })
            : GetBuilder<FeedbackController>(
                init: FeedbackController(),
                builder: (xontrolllerFeedback) {
                  return ButtonAll(
                    color: Theme.of(context).primaryColor,
                    function: () {},
                    title: 'Update Feedback'.tr,
                  );
                }),
      ],
    );
  }

  GridView imageSelect() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                    _compressedImages!.remove(_compressedImages![index]);
                  });
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ))
          ],
        );
      },
    );
  }

  AnimatedContainer vocalafter(BuildContext context) {
    return AnimatedContainer(
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
              color: Theme.of(context).primaryColor, // Border color
              width: 1.0, // Border width
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: GetBuilder<RecordController>(builder: (controllerVoice) {
            // controlledVoiceMessageViewMy = VoiceController(
            //   audioSrc: controllerVoice.audioPath,
            //   maxDuration:
            //       Duration(seconds: controllerVoice.audioDuration.inSeconds),
            //   isFile: true,
            //   onComplete: () {},
            //   onPause: () {},
            //   onPlaying: () {},
            //   onError: (err) {},
            // );

            return Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Container(
                    //   height: 90,
                    //   child: VoiceMessageViewMy(
                    //     activeSliderColor: Theme.of(context).primaryColor,
                    //     circlesColor: Theme.of(context).primaryColor,
                    //     controller: controlledVoiceMessageViewMy!,
                    //     innerPadding: 12,
                    //     cornerRadius: 20,
                    //     size: 50,
                    //   ),
                    // ),
                    const Spacer(),
                    controllerVoice.audioPath.isEmpty ||
                            controllerVoice.isRecording == true
                        ? GestureDetector(
                            onTap: () async {
                              bool isGranted =
                                  await isMicrophonePermissionGranted();
                              if (isGranted) {
                                setState(() => _animate = !_animate);
                                controllerVoice.toggleRecording();
                                if (await Vibration.hasVibrator() ?? false) {
                                  Vibration.vibrate(duration: 100);
                                }
                              } else {
                                setState(() => _animate = false);
                                await requestMicrophonePermission(context);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: AvatarGlow(
                                animate: _animate,
                                glowColor: Theme.of(context).primaryColor,
                                child: Material(
                                  elevation: 20.0,
                                  shape: const CircleBorder(),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.grey[100],
                                    radius: 30.0,
                                    child: Icon(
                                        controllerVoice.isRecording != true
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
                                        _iShowVocal =
                                            !_iShowVocal; // Toggle animation
                                      });
                                      // await controlledVoiceMessageViewMy!
                                      //     .stopPlaying();
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
                if (controllerVoice.audioPath.isEmpty &&
                    controllerVoice.isRecording != true)
                  IconButton(
                      onPressed: () {
                        setState(() => _iShowVocal = false);
                      },
                      icon: Icon(Icons.close)),
              ],
            );
          }),
        ),
      ),
    );
  }

  Row vocalbefor(BuildContext context) {
    return Row(
      children: [],
    );
  }

  Column _selectImages() {
    return Column(
      children: [
        InkWell(
          onTap: _selectImagesFromGallery,
          child: Row(
            children: [
              Icon(
                Icons.image_outlined,
                color: Colors.green,
              ),
              SizedBox(width: 10),
              Text("Photos".tr)
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: _takePhoto,
          child: Row(
            children: [
              Icon(
                Icons.camera_alt,
                color: Colors.blue,
              ),
              SizedBox(width: 10),
              Text("Camera".tr)
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Column _gallery(BuildContext context) {
    return Column(
      children: [
        Text(
          'Gallery'.tr,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 10),
        feedbacklocal!.gallery.isNotEmpty
            ? SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    final imagePath = images[index]['path'];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Stack(
                        children: [
                          InkWell(
                            onTap: () => showFullscreenImage(context,
                                '${dotenv.get('urlHost')}/uploads/$imagePath'),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl:
                                    '${dotenv.get('urlHost')}/uploads/$imagePath',
                                placeholder: (context, url) => Center(
                                    child: Container(
                                  decoration: StyleContainer.style1,
                                  width: 115,
                                  child: const Center(
                                    child: spinkit,
                                  ),
                                )),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  images.remove(images[index]);
                                });
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ))
                        ],
                      ),
                    );
                  },
                ),
              )
            : Text(
                'No Images available'.tr,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
      ],
    );
  }

  GetBuilder<ExpandableControllerFeedback> _datePickerWidget() {
    return GetBuilder<ExpandableControllerFeedback>(
        init: ExpandableControllerFeedback(),
        builder: (controllerexp) {
          return controllerexp.selectedItem.value != null
              ? controllerexp.selectedItem.value!.isRequestDateRequired != null
                  ? controllerexp.selectedItem.value!.isRequestDateRequired ==
                          true
                      ? DatePickerWidget()
                      : Container()
                  : Container()
              : Container();
        });
  }

  Column _description() {
    return Column(
      children: [
        GetBuilder<ExpandableControllerFeedback>(
            init: ExpandableControllerFeedback(),
            builder: (controllerExp) {
              return Row(
                children: [
                  'Description'.tr.style(fontSize: 16),
                  Text(
                    (controllerExp.selectedItem.value != null
                        ? controllerExp.selectedItem.value!.isDescRequired !=
                                null
                            ? controllerExp
                                        .selectedItem.value!.isDescRequired ==
                                    true
                                ? ' *'
                                : ''
                            : ''
                        : ''),
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              );
            }),
        SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: descController,
          decoration: InputDecoration(
            labelText: 'Description'.tr,
            border: OutlineInputBorder(),
          ),
          maxLines: 5,
          validator: (value) => AppValidator.validate(value, [
            (val) =>
                AppValidator.validateRequired(val, fieldName: 'Description'),
            // You can add more validators here if needed, e.g., for length
            (val) => AppValidator.validateLength(val,
                minLength: 5, fieldName: 'Description'),
          ]),
        ),
      ],
    );
  }

  void _handleUpdateFeedback() async {
    final controllerisreq = Get.put(ExpandableControllerFeedback());

    if (isCompressImage) {
      return;
    }
    if (controllerisreq.selectedItem.value == null) {
      showMessage(context, title: 'Select Reasons'.tr);
    } else if (controllerisreq.selectedItem.value!.isDescRequired == true) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        post();
        return;
      } else {
        showMessage(context, title: 'Please enter a description'.tr);
        return;
      }
    }
    post();
  }

  post() async {
    feedbackController.updateIsLoading(true);
    var location = await LocationService.getCurrentLocation(context);
    if (location.isPermissionGranted) {
      final List<XFile> xFiles =
          _compressedImages!.map((file) => XFile(file.path)).toList();

      await feedbackController.updateFeedbacks(
        imagesAdd: xFiles,
        beforimages: feedbackinitlanght,
        lat: location.latitude.toString(),
        lng: location.longitude.toString(),
        feedbackId: widget.feedback.id.toString(),
        lastLabel: expandableController.controllerTextEditingController!.text,
        Label: widget.feedback.label.toString(),
        desc: descController.text,
        requestDate:
            formatDate(Get.put(DateController()).selectedDate.value.toString()),
        clientId: int.parse(clientIdController.text),
        feedbackModelId: int.parse(widget.feedback.feedbackModelId.toString()),
        creatorId: widget.feedback.creatorId!,
        images: images,
      );
    }
    feedbackController.updateIsLoading(false);
  }
}
