import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/Buttons/buttonall.dart';
import '../../../../Controller/home/feedback_controller.dart';
import '../../../../Controller/home/reasons_feedback_controller.dart';
import '../../../../Controller/widgetsController/date_controller.dart';
import '../../../../Controller/widgetsController/expandable_controller.dart';
import '../../../../Model/feedback.dart';
import '../../../../Model/reason_feedback.dart';
import '../../../../Service/Location/get_location.dart';
import '../../../../Util/Date/formatDate.dart';
import '../../../../Util/Style/stylecontainer.dart';
import '../../../widgets/Date/date_picker.dart';
import '../../../widgets/flutter_spinkit.dart';
import '../../../widgets/showsnack.dart';
import 'feedback_profile_screen.dart';

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

  @override
  void dispose() {
    Get.delete<ExpandableControllerFeedback>();
    Get.delete<DateController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Feedback')),
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
              ReasonsSelectorFeedbackupd(
                  id: widget.feedback.feedbackModelId.toString()),

              const SizedBox(
                height: 20,
              ),
              // _buildTextField(
              //     descController, 'Description', 'Enter a description',
              //     maxLines: 3),
              TextFormField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                onSaved: (value) {
                  // desc = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
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
              const Text(
                'Gallery',
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
                      'No Images available',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
              const SizedBox(height: 20),
              GetBuilder<FeedbackController>(
                  init: FeedbackController(),
                  builder: (xontrolllerFeedback) {
                    return ButtonAll(
                      function: _handleUpdateFeedback,
                      title: 'Update Feedback',
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
      showMessage(context, title: 'Select Reasons');
    } else if (controllerisreq.selectedItem.value!.isDescRequired == true) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        post();
        return;
      } else {
        print("object");
      }
    }
  }

  post() async {
    await feedbackController
        .updateFeedback(
            feedbackId: widget.feedback.id.toString(),
            lastLabel:
                expandableController.controllerTextEditingController!.text,
            Label: widget.feedback.label.toString(),
            desc: descController.text,
            requestDate: formatDate(
                Get.put(DateController()).selectedDate.value.toString()),
            clientId: int.parse(clientIdController.text),
            feedbackModelId:
                int.parse(widget.feedback.feedbackModelId.toString()),
            creatorId: widget.feedback.creatorId!,
            images: images)
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
    Get.put(ExpandableControllerFeedback()).intiItme(int.parse(widget.id));

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
                    ? 'Select Reasons'
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
                      child: Text(
                        item.label!,
                        style:
                            const TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }),

          // Show a TextField if "autre" is selected
          Obx(() {
            if (expandableController.selectedItem.value?.label == 'autre' ||
                id == "1") {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller:
                      expandableController.controllerTextEditingController,
                  decoration: const InputDecoration(
                    labelText: 'Please specify',
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
