import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img; // For image compression
import 'package:mformatic_crm_delegate/App/Controller/home/feedback_controller.dart';
import 'package:mformatic_crm_delegate/App/Controller/widgetsController/expandable_controller.dart';
import 'package:mformatic_crm_delegate/App/Model/reason_feedback.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';
import '../../../../Controller/home/reasons_feedback_controller.dart';
import '../../../../Service/Location/get_location.dart';

class CreateFeedBackScreen extends StatefulWidget {
  final int clientID;
  final int missionID;
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
  double _compressionProgress = 0.0; // Track compression progress

  Future<File> _compressImage(XFile file) async {
    final bytes = await file.readAsBytes();
    final img.Image? image = img.decodeImage(bytes);

    // Resize the image with a clearer resolution and moderate dimensions
    final img.Image resized = img.copyResize(image!, width: 500);

    // Compress the image to reduce the file size
    final compressedBytes =
        img.encodeJpg(resized, quality: 85); // Adjust quality as needed

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

        // Update progress after each image is compressed
        setState(() {
          _compressionProgress = ((i + 1) / pickedFiles.length) * 100;
        });
      }
      setState(() {
        _compressedImages = compressedFiles;
        _compressionProgress = 0.0; // Reset progress after completion
      });
    }
  }

  @override
  void dispose() {
    Get.delete<ExpandableControllerFeedback>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              var location = await getCurrentLocation();

                              // Convert List<File> to List<XFile>
                              final List<XFile> xFiles = _compressedImages!
                                  .map((file) => XFile(file.path))
                                  .toList();

                              controllercreateFeedback.addFeedback(
                                label: Get.put(ExpandableControllerFeedback())
                                    .controllerTextEditingController!
                                    .text,
                                desc: desc,
                                lat: location.latitude.toString(),
                                lng: location.longitude.toString(),
                                requestDate: '01/01/2022',
                                clientId: widget.clientID,
                                missionId: widget.missionID,
                                feedbackModelId:
                                    Get.put(ExpandableControllerFeedback())
                                        .selectedItem
                                        .value!
                                        .id!,
                                images: xFiles, // Pass the XFile list
                              );
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
}

class ReasonsSelectorFeedback extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReasonsFeedbackController>(
      init: ReasonsFeedbackController(),
      builder: (controller) {
        if (controller.isLoading) {
          return Center(child: spinkit);
        } else if (controller.reasons.isEmpty) {
          return const Center(
            child: Text(
              'No reasons available',
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          );
        }

        return SelectReason(
          items: controller.reasons,
          title: 'Select Reasons',
        );
      },
    );
  }
}

class SelectReason extends StatelessWidget {
  final List<FeedbackReason> items;
  final String title;

  SelectReason({
    Key? key,
    required this.items,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ExpandableControllerFeedback expandableController =
        Get.put(ExpandableControllerFeedback());

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Obx(() {
            return ExpansionTile(
              key: Key(expandableController.selectedItem.value?.label ?? ''),
              title: Text(
                expandableController.selectedItem.value == null
                    ? 'Select Reasons'
                    : expandableController.selectedItem.value!.label!,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              trailing: Icon(
                expandableController.isExpanded.value
                    ? Icons.arrow_drop_up
                    : Icons.arrow_drop_down,
                color: Theme.of(context).primaryColor,
              ),
              initiallyExpanded: expandableController.isExpanded.value,
              onExpansionChanged: (expanded) {
                expandableController.toggleExpanded();
              },
              children: items.map((item) {
                return GestureDetector(
                  onTap: () {
                    expandableController.selectItem(item);
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 16.0),
                      child: Text(
                        item.label!,
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }),
          // Show a TextField if "autre" is selected
          Obx(() {
            if (expandableController.selectedItem.value?.label == 'autre') {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller:
                      expandableController.controllerTextEditingController,
                  decoration: InputDecoration(
                    labelText: 'Please specify',
                    border: OutlineInputBorder(),
                  ),
                ),
              );
            }
            return SizedBox.shrink(); // Returns an empty widget if not needed
          }),
        ],
      ),
    );
  }
}
