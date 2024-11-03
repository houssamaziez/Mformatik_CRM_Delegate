import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img; // For image compression
import 'package:mformatic_crm_delegate/App/Controller/home/feedback_controller.dart';
import 'package:mformatic_crm_delegate/App/Controller/widgetsController/expandable_controller.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/showsnack.dart';
import '../../../../Controller/widgetsController/date_controller.dart';
import '../../../../Service/Location/get_location.dart';
import '../../../../Util/Date/formatDate.dart';
import '../../../widgets/Date/date_picker.dart';
import '../../../widgets/Dialog/showExitConfirmationDialog.dart';
import 'widgets/reason_selector_feedback.dart';

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
  String desc = '';
  int reasonId = 0;
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  double? lat;
  double? lng;
  DateTime? requestDate;
  double _compressionProgress = 0.0;
  List<File>? _compressedImages = [];

  Future<File> _compressImage(XFile file) async {
    final bytes = await file.readAsBytes();
    final img.Image? image = img.decodeImage(bytes);

    final img.Image resized = img.copyResize(image!, width: 500);
    final compressedBytes = img.encodeJpg(resized, quality: 85);

    final compressedImageFile = File('${file.path}_compressed.jpg');
    await compressedImageFile.writeAsBytes(compressedBytes);

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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<ExpandableControllerFeedback>();
    Get.delete<DateController>();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controllerisreq = Get.put(ExpandableControllerFeedback());
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
              TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'Description'.tr,
                  alignLabelWithHint: true, // لتعيين العنوان في الأعلى

                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                onSaved: (value) {
                  desc = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description'.tr;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Selected Images'.tr,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  IconButton(
                      onPressed: _takePhoto,
                      icon: Icon(
                        Icons.camera,
                        color: Theme.of(context).primaryColor,
                      )),
                  const SizedBox(width: 8),
                  IconButton(
                      onPressed: _selectImagesFromGallery,
                      color: Theme.of(context).primaryColor,
                      icon: Icon(
                        Icons.image,
                      )),
                ],
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
                            if (widget.missionID != null) {
                              showExitConfirmationDialog(context,
                                  onPressed: () async {
                                Get.back();
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
                                    }
                                  } else {
                                    post(controllercreateFeedback, location);
                                    return;
                                  }
                                }
                              },
                                  details:
                                      'Are you sure to complete the Mission?'
                                          .tr,
                                  title: 'Confirmation'.tr);
                            } else {
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
                                        title: 'Please enter a description'.tr);
                                  }
                                } else {
                                  post(controllercreateFeedback, location);
                                  return;
                                }
                              }
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
  }

  post(
      FeedbackController controllercreateFeedback, LocationDataModel location) {
    final List<XFile> xFiles =
        _compressedImages!.map((file) => XFile(file.path)).toList();

    controllercreateFeedback.addFeedback(
      label: Get.put(ExpandableControllerFeedback())
          .controllerTextEditingController!
          .text,
      desc: desc,
      lat: location.latitude.toString(),
      lng: location.longitude.toString(),
      requestDate:
          formatDate(Get.put(DateController()).selectedDate.value.toString()),
      clientId: widget.clientID,
      missionId: widget.missionID,
      feedbackModelId:
          Get.put(ExpandableControllerFeedback()).selectedItem.value!.id!,
      images: xFiles,
    );
  }
}
