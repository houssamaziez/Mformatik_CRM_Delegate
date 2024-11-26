import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/reasons_mission_controller.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/Item_selector.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/showsnack.dart';
import '../../../../../Controller/home/missions_controller.dart';
import '../../../../../Controller/home/reasons_feedback_controller.dart';
import '../../../../../Controller/widgetsController/expandable_controller.dart';
import '../../../../../Service/AppValidator/AppValidator.dart';

class CreateMissionScreen extends StatefulWidget {
  final int clientID;

  const CreateMissionScreen({super.key, required this.clientID});
  @override
  _CreateMissionScreenState createState() => _CreateMissionScreenState();
}

class _CreateMissionScreenState extends State<CreateMissionScreen> {
  final _formKey = GlobalKey<FormState>();
  final MissionsController missionsController = Get.put(MissionsController());
  TextEditingController? controller = TextEditingController();
  // Form fields
  String label = '';
  String desc = '';
  int reasonId = 0;
  @override
  void dispose() {
    Get.delete<ExpandableControllerd>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Mission'.tr),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Label field
              const SizedBox(height: 16),
              ReasonsSelector(),
              const SizedBox(height: 16),

              // Description field
              TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'Description'.tr,
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                maxLength: 250,
                onSaved: (value) {
                  desc = value!;
                },
                validator: (value) => AppValidator.validate(value, [
                  (val) => AppValidator.validateRequired(val,
                      fieldName: 'Description'),
                  // You can add more validators here if needed, e.g., for length
                  (val) => AppValidator.validateLength(val,
                      minLength: 5, fieldName: 'Description'),
                ]),
              ),

              const SizedBox(height: 32),

              GetBuilder<MissionsController>(
                  init: MissionsController(),
                  builder: (controllercreateMission) {
                    return ElevatedButton(
                      onPressed: controllercreateMission.isLoading
                          ? null
                          : () {
                              print(widget.clientID);
                              ExpandableControllerd controllerzx =
                                  Get.put(ExpandableControllerd());
                              if (controllerzx.selectedItem.value == null) {
                                showMessage(context,
                                    title: 'Select Reasons'.tr);
                              } else {
                                if (controllerzx.selectedItem.value!.id == 1) {}

                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();

                                  controllercreateMission.createMission(
                                      desc: desc,
                                      clientId: widget.clientID,
                                      context: context,
                                      text: controller!.text);
                                }
                              }
                            },
                      child: controllercreateMission.isLoading
                          ? spinkit
                          : Text('Create Mission'.tr),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class ReasonsSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReasonsMissionController>(
      init: ReasonsMissionController(),
      builder: (controller) {
        // Check if loading is in progress
        if (controller.isLoading) {
          return Center(child: spinkit); // Use a loading indicator widget
        } else {
          // Ensure there are reasons available
          if (controller.reasons.isEmpty) {
            return Center(
              child: Text(
                'No reasons available'
                    .tr, // Display a message when no reasons are found
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            );
          }

          return SelectReasdon(
            items: controller.reasons,
            title: 'Select Reasons'.tr,
          );
        }
      },
    );
  }
}
