import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import '../../../../Controller/home/feedback_controller.dart';
import '../../../../Controller/home/reasons_feedback_controller.dart';
import '../../../../Controller/widgetsController/expandable_controller.dart';
import '../../../../Model/feedback.dart';
import '../../../../Model/reason_feedback.dart';
import '../../../../Service/Location/get_location.dart';
import '../../../../Util/Style/stylecontainer.dart';
import '../../../widgets/flutter_spinkit.dart';
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
  }

  @override
  void dispose() {
    Get.delete<ExpandableControllerFeedback>();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Feedback')),
      body: SingleChildScrollView(
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
            _buildTextField(
                descController, 'Description', 'Enter a description',
                maxLines: 3),

            _buildTextField(
                requestDateController, 'Request Date', 'YYYY-MM-DD'),
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
                      itemCount: feedbacklocal!.gallery.length,
                      itemBuilder: (context, index) {
                        final imagePath = feedbacklocal!.gallery[index]['path'];
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
                                      feedbacklocal!.gallery.remove(imagePath);
                                    });
                                  },
                                  icon: const Icon(Icons.delete))
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
            ElevatedButton(
              onPressed: _handleUpdateFeedback,
              child: const Text('Update Feedback'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
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
    if (labelController.text.isEmpty || descController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all required fields',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    var location = await getCurrentLocation();
    if (location.isPermissionGranted == true) {
      await feedbackController
          .updateFeedback(
        feedbackId: widget.feedback.id.toString(),
        lastLabel: expandableController.controllerTextEditingController!.text,
        Label: widget.feedback.label.toString(),
        desc: descController.text,
        lat: location.latitude.toString(),
        lng: location.longitude.toString(),
        requestDate: requestDateController.text,
        clientId: int.parse(clientIdController.text),
        feedbackModelId: int.parse(widget.feedback.feedbackModelId.toString()),
        creatorId: widget.feedback.creatorId!,
      )
          .then((success) {
        getCurrentLocation();
      });
    } else {}
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
