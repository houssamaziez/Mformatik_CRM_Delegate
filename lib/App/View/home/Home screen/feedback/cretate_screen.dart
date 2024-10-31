import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img; // For image compression
import 'package:mformatic_crm_delegate/App/Controller/home/feedback_controller.dart';
import 'package:mformatic_crm_delegate/App/Controller/widgetsController/expandable_controller.dart';
import 'package:mformatic_crm_delegate/App/Model/reason_feedback.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/showsnack.dart';
import '../../../../Controller/home/reasons_feedback_controller.dart';
import '../../../../Controller/widgetsController/date_controller.dart';
import '../../../../Service/Location/get_location.dart';
import '../../../../Util/Date/formatDate.dart';
import '../../../widgets/Date/date_picker.dart';
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
  List<File>? _compressedImages = [];
  double? lat;
  double? lng;
  DateTime? requestDate;
  double _compressionProgress = 0.0;

  Future<File> _compressImage(XFile file) async {
    final bytes = await file.readAsBytes();
    final img.Image? image = img.decodeImage(bytes);

    final img.Image resized = img.copyResize(image!, width: 500);
    final compressedBytes = img.encodeJpg(resized, quality: 85);

    final compressedImageFile = File('${file.path}_compressed.jpg');
    await compressedImageFile.writeAsBytes(compressedBytes);

    return compressedImageFile;
  }

  Future<void> _selectAndCompressImages() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      List<File> compressedFiles = [];
      for (int i = 0; i < pickedFiles.length; i++) {
        File compressedImage = await _compressImage(pickedFiles[i]);
        compressedFiles.add(compressedImage);

        setState(() {
          _compressionProgress = ((i + 1) / pickedFiles.length) * 100;
        });
      }
      setState(() {
        _compressedImages = compressedFiles;
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
        title: const Text('Create Feedback'),
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
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                onSaved: (value) {
                  desc = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
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
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _selectAndCompressImages,
                child: const Text('Select Images'),
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
                const SizedBox(height: 16),
                const Text('Selected Images:'),
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
                    return Image.file(
                      _compressedImages![index],
                      fit: BoxFit.cover,
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
                            var location =
                                await LocationService.getCurrentLocation(
                                    context);
                            if (location.isPermissionGranted) {
                              if (controllerisreq.selectedItem.value == null) {
                                showMessage(context, title: 'Select Reasons');
                              } else if (controllerisreq
                                      .selectedItem.value!.isDescRequired ==
                                  true) {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  post(controllercreateFeedback, location);
                                  return;
                                } else {
                                  print("object");
                                }
                              } else {
                                post(controllercreateFeedback, location);
                                return;
                              }
                            }
                          },
                    child: controllercreateFeedback.isLoadingadd
                        ? spinkitwhite
                        : const Text('Create Feedback'),
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
