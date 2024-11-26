import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../Controller/home/reasons_feedback_controller.dart';
import '../../../../../../Controller/widgetsController/expandable_controller.dart';
import '../../../../../../Model/reason_feedback.dart';
import '../../../../../widgets/flutter_spinkit.dart';

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

        return SelectReasonupdate(
          items: controller.reasons,
          title: 'Select Reasons'.tr,
          id: widget.id,
        );
      },
    );
  }
}

class SelectReasonupdate extends StatelessWidget {
  final List<FeedbackReason> items;
  final String title;
  final String id;

  SelectReasonupdate({
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
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }),
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
