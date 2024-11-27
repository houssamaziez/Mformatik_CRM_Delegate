import 'dart:io';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img; // For image compression
import 'package:mformatic_crm_delegate/App/Controller/home/feedback/feedback_controller.dart';
import 'package:mformatic_crm_delegate/App/Controller/widgetsController/expandable_controller.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/Style/style_text.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/showsnack.dart';
import 'package:vibration/vibration.dart';
// import 'package:voice_message_package/voice_message_package.dart';
import '../../../../../Controller/RecordController.dart';
import '../../../../../Controller/widgetsController/date_controller.dart';
import '../../../../../Service/AppValidator/AppValidator.dart';
import '../../../../../Service/Location/get_location.dart';
import '../../../../../Service/permission_handler/mic_handler.dart';
import '../../../../../Util/Date/formatDate.dart';
import '../../../../Voice/screen_voice.dart';
import '../../../../widgets/Date/date_picker.dart';
import '../../../../widgets/Dialog/showExitConfirmationDialog.dart';
import '../widgets/reason_selector_feedback.dart';

class CreateFeedBackScreen extends StatefulWidget {
  final int clientID;
  final int? missionID;
  final int feedbackModelID;

  const CreateFeedBackScreen({
    super.key,
    required this.clientID,
    required this.missionID,
    required this.feedbackModelID,
  });

  @override
  _CreateFeedBackScreenState createState() => _CreateFeedBackScreenState();
}

class _CreateFeedBackScreenState extends State<CreateFeedBackScreen> {
  final FeedbackController feedbackController = Get.put(FeedbackController());
  TextEditingController? controller = TextEditingController();
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

  final RecordController recordController = Get.put(RecordController());

  // VoiceController? controlledVoiceMessageViewMy;
  bool _animate = false;
  bool _iShowVocal = false;

  @override
  void dispose() {
    // controlledVoiceMessageViewMy!.stopPlaying();
    Get.delete<ExpandableControllerFeedback>();
    Get.delete<DateController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controllerisreq = Get.put(ExpandableControllerFeedback());
    return GetBuilder<RecordController>(builder: (controllerVoice) {
      // controlledVoiceMessageViewMy = VoiceController(
      //   audioSrc: controllerVoice.audioPath,
      //   maxDuration: Duration(seconds: controllerVoice.audioDuration.inSeconds),
      //   isFile: true,
      //   onComplete: () {},
      //   onPause: () {},
      //   onPlaying: () {},
      //   onError: (err) {},
      // );

      return Scaffold(
        appBar: AppBar(
          title: Text('Create Feedback'.tr),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 16),
                ReasonsSelectorFeedback(),
                const SizedBox(height: 16),
                GetBuilder<ExpandableControllerFeedback>(
                    init: ExpandableControllerFeedback(),
                    builder: (controllerExp) {
                      return Row(
                        children: [
                          'Description'.tr.style(fontSize: 16),
                          Text(
                            (controllerExp.selectedItem.value != null
                                ? controllerExp.selectedItem.value!
                                            .isDescRequired !=
                                        null
                                    ? controllerExp.selectedItem.value!
                                                .isDescRequired ==
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
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: 'Description'.tr,
                    alignLabelWithHint: true, // لتعيين العنوان في الأعلى

                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                  maxLength: 250,
                  onSaved: (value) {},
                  validator: (value) => AppValidator.validate(value, [
                    (val) => AppValidator.validateRequired(val,
                        fieldName: 'Description'),
                    // You can add more validators here if needed, e.g., for length
                    (val) => AppValidator.validateLength(val,
                        minLength: 5, fieldName: 'Description'),
                  ]),
                ),
                GetBuilder<ExpandableControllerFeedback>(
                    init: ExpandableControllerFeedback(),
                    builder: (controllerexp) {
                      return controllerexp.selectedItem.value != null
                          ? controllerexp.selectedItem.value!
                                      .isRequestDateRequired !=
                                  null
                              ? controllerexp.selectedItem.value!
                                          .isRequestDateRequired ==
                                      true
                                  ? DatePickerWidget()
                                  : Container()
                              : Container()
                          : Container();
                    }),
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
                ],
                const SizedBox(height: 32),
                GetBuilder<FeedbackController>(
                  init: FeedbackController(),
                  builder: (controllercreateFeedback) {
                    return ElevatedButton(
                      onPressed: controllercreateFeedback.isLoadingadd
                          ? null
                          : () async {
                              if (controllerisreq.selectedItem.value == null) {
                                showMessage(context,
                                    title: 'Select Reasons'.tr);
                                return;
                              }
                              if (widget.missionID != null) {
                                showExitConfirmationDialog(context,
                                    onPressed: () async {
                                  Get.back();
                                  controllercreateFeedback
                                      .upadteisloading(true);

                                  var location =
                                      await LocationService.getCurrentLocation(
                                          context);
                                  if (location.isPermissionGranted) {
                                    if (controllerisreq.selectedItem.value ==
                                        null) {
                                      showMessage(context,
                                          title: 'Select Reasons'.tr);
                                    } else if (controllerisreq.selectedItem
                                            .value!.isDescRequired ==
                                        true) {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        post(
                                            controllercreateFeedback, location);

                                        return;
                                      }
                                    } else {
                                      post(controllercreateFeedback, location);

                                      return;
                                    }
                                  }
                                  controllercreateFeedback
                                      .upadteisloading(false);
                                },
                                    details:
                                        'Are you sure to complete the Mission?'
                                            .tr,
                                    title: 'Confirmation'.tr);
                              } else {
                                controllercreateFeedback.updateIsLoading(true);
                                var location =
                                    await LocationService.getCurrentLocation(
                                        context);
                                if (location.isPermissionGranted) {
                                  if (controllerisreq.selectedItem.value ==
                                      null) {
                                    showMessage(context,
                                        title: 'Select Reasons'.tr);
                                  } else if (controllerisreq
                                          .selectedItem.value!.isDescRequired ==
                                      true) {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();

                                      post(controllercreateFeedback, location);

                                      return;
                                    } else {
                                      showMessage(context,
                                          title:
                                              'Please enter a description'.tr);
                                    }
                                  } else {
                                    post(controllercreateFeedback, location);

                                    return;
                                  }
                                }
                                controllercreateFeedback.updateIsLoading(false);
                              }
                            },
                      child: controllercreateFeedback.isLoadingadd
                          ? spinkitwhite
                          : Text('Create Feedback'.tr),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  post(
      FeedbackController controllercreateFeedback, LocationDataModel location) {
    final List<XFile> xFiles =
        _compressedImages!.map((file) => XFile(file.path)).toList();
    controllercreateFeedback.upadteisloading(true);
    controllercreateFeedback
        .addFeedback(
            label: Get.put(ExpandableControllerFeedback())
                .controllerTextEditingController!
                .text,
            desc: controller!.text,
            lat: location.latitude.toString(),
            lng: location.longitude.toString(),
            requestDate: formatDate(
                Get.put(DateController()).selectedDate.value.toString()),
            clientId: widget.clientID,
            missionId: widget.missionID,
            feedbackModelId:
                Get.put(ExpandableControllerFeedback()).selectedItem.value!.id!,
            images: xFiles,
            path: Get.put(RecordController()).audioPath)
        .then((onValue) {
      controllercreateFeedback.upadteisloading(false);
    });
  }
}
