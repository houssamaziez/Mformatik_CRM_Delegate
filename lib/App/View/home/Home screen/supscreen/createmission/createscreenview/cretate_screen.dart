import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/reasons_controller.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/Item_selector.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';
import '../../../../../../Controller/home/missions_controller.dart';

class CreateMissionScreen extends StatefulWidget {
  final int clientID;

  const CreateMissionScreen({super.key, required this.clientID});
  @override
  _CreateMissionScreenState createState() => _CreateMissionScreenState();
}

class _CreateMissionScreenState extends State<CreateMissionScreen> {
  final _formKey = GlobalKey<FormState>();
  final MissionsController missionsController = Get.put(MissionsController());

  // Form fields
  String label = '';
  String desc = '';
  int reasonId = 0;
  List<String> items = [
    "item 1",
    "item 2",
    "item 3",
    "item 4",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Mission'),
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

              // Client ID field

              // Responsible ID field

              const SizedBox(height: 32),

              // Submit button
              GetBuilder<MissionsController>(
                  init: MissionsController(),
                  builder: (controllercreateMission) {
                    return ElevatedButton(
                      onPressed: controllercreateMission.isLoading
                          ? null
                          : () {
                              print(widget.clientID);
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                controllercreateMission.createMission(
                                  desc: desc,
                                  clientId: widget.clientID,
                                  context: context,
                                );
                              }
                            },
                      child: controllercreateMission.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Create Mission'),
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
    return GetBuilder<ReasonsController>(
      init: ReasonsController(),
      builder: (controller) {
        // Check if loading is in progress
        if (controller.isLoading) {
          return Center(child: spinkit); // Use a loading indicator widget
        } else {
          // Ensure there are reasons available
          if (controller.reasons.isEmpty) {
            return Center(
              child: Text(
                'No reasons available', // Display a message when no reasons are found
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            );
          }

          return SelectReason(
            items: controller.reasons,
            title: 'Select Reasons',
          );
        }
      },
    );
  }
}
