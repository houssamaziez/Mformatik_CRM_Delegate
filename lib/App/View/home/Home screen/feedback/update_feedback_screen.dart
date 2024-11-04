import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/Style/style_text.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/Buttons/buttonall.dart';
import '../../../../Controller/home/feedback_controller.dart';
import '../../../../Controller/home/reasons_feedback_controller.dart';
import '../../../../Controller/widgetsController/date_controller.dart';
import '../../../../Controller/widgetsController/expandable_controller.dart';
import '../../../../Model/feedback.dart';
import '../../../../Model/reason_feedback.dart';
import '../../../../Service/AppValidator/AppValidator.dart';
import '../../../../Service/Location/get_location.dart';
import '../../../../Util/Date/formatDate.dart';
import '../../../../Util/Style/stylecontainer.dart';
import '../../../widgets/Date/date_picker.dart';
import '../../../widgets/flutter_spinkit.dart';
import '../../../widgets/showsnack.dart';
import 'feedback_profile_screen.dart';
import 'package:image/image.dart' as img; // For image compression

class UpdateFeedbackScreen extends StatefulWidget {
  final FeedbackMission feedback;

  UpdateFeedbackScreen({required this.feedback});

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
  @override
  void initState() {
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

  @override
  void dispose() {
    Get.delete<ExpandableControllerFeedback>();
    Get.delete<DateController>();
    super.dispose();
  }

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
              // // if (widget.feedback.feedbackModelId == 1)
              // ReasonsSelectorFeedbackupd(
              //     id: widget.feedback.feedbackModelId.toString()),
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
              // _buildTextField(
              //     descController, 'Description', 'Enter a description',
              //     maxLines: 3),
              GetBuilder<ExpandableControllerFeedback>(
                  init: ExpandableControllerFeedback(),
                  builder: (controllerExp) {
                    return Row(
                      children: [
                        'Description'.tr.style(fontSize: 16),
                        Text(
                          (controllerExp.selectedItem.value != null
                              ? controllerExp
                                          .selectedItem.value!.isDescRequired !=
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
                controller: descController,
                decoration: InputDecoration(
                  labelText: 'Description'.tr,
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) => AppValidator.validate(value, [
                  (val) => AppValidator.validateRequired(val,
                      fieldName: 'Description'),
                  // You can add more validators here if needed, e.g., for length
                  (val) => AppValidator.validateLength(val,
                      minLength: 5, fieldName: 'Description'),
                ]),
              ),

              SizedBox(
                height: 10,
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
              Text(
                'Gallery'.tr,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.blueGrey,
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
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

              const SizedBox(height: 20),
              GetBuilder<FeedbackController>(
                  init: FeedbackController(),
                  builder: (xontrolllerFeedback) {
                    return ButtonAll(
                      function: _handleUpdateFeedback,
                      title: 'Update Feedback'.tr,
                      isloading: xontrolllerFeedback.isLoadingadd,
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, String placeholder,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: placeholder,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  void _handleUpdateFeedback() async {
    final controllerisreq = Get.put(ExpandableControllerFeedback());

    // if (labelController.text.isEmpty || descController.text.isEmpty) {
    //   Get.snackbar('Error', 'Please fill in all required fields',
    //       backgroundColor: Colors.red, colorText: Colors.white);
    //   return;
    // }

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
    final List<XFile> xFiles =
        _compressedImages!.map((file) => XFile(file.path)).toList();
    await feedbackController
        .updateFeedbacks(
      imagesAdd: xFiles,
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
    )
        .then((success) {
      LocationService.getCurrentLocation(context);
    });
  }
}

class ReasonsSelectorFeedbackupd extends StatefulWidget {
  final String id;

  const ReasonsSelectorFeedbackupd({super.key, required this.id});

  @override
  State<ReasonsSelectorFeedbackupd> createState() =>
      _ReasonsSelectorFeedbackupdState();
}

class _ReasonsSelectorFeedbackupdState
    extends State<ReasonsSelectorFeedbackupd> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Get.put(ExpandableControllerFeedback()).intiItme(int.parse(widget.id));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReasonsFeedbackController>(
      init: ReasonsFeedbackController(),
      builder: (controller) {
        if (controller.isLoading) {
          return const Center(child: spinkit);
        } else if (controller.reasons.isEmpty) {
          return Center(
            child: Text(
              'No reasons available'.tr,
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          );
        }

        return SelectReason(
          items: controller.reasons,
          title: 'Select Reasons'.tr,
          id: widget.id,
        );
      },
    );
  }
}

class SelectReason extends StatelessWidget {
  final List<FeedbackReason> items;
  final String title;
  final String id;

  SelectReason({
    Key? key,
    required this.items,
    required this.title,
    required this.id,
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
                    ? 'Select Reasons'.tr
                    : expandableController.selectedItem.value!.label!,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
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
                      child: Column(
                        children: [
                          Text(
                            item.label!,
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black),
                          ),
                          // Text(
                          //   (item.isDescRequired == true
                          //       ? "Description Required *".tr
                          //       : ""),
                          //   style: const TextStyle(
                          //       fontSize: 10, color: Colors.red),
                          // ),
                          // Text(
                          //   (item.isRequestDateRequired == true
                          //       ? "Request Date Required *"
                          //       : ""),
                          //   style: const TextStyle(
                          //       fontSize: 10, color: Colors.red),
                          // )
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }),

          // Show a TextField if "autre" is selected
          Obx(() {
            if (expandableController.selectedItem.value?.id.toString() == id &&
                id == "1") {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller:
                      expandableController.controllerTextEditingController,
                  decoration: InputDecoration(
                    labelText: 'Please specify'.tr,
                    border: OutlineInputBorder(),
                  ),
                ),
              );
            }
            return const SizedBox
                .shrink(); // Returns an empty widget if not needed
          }),
        ],
      ),
    );
  }
}
