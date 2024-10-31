import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart'; // For image selection
import 'package:mformatic_crm_delegate/App/Controller/home/feedback_controller.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';

import '../../../../Service/Location/get_location.dart';

class AddFeedbackScreen extends StatefulWidget {
  final int clientID; // Client ID to associate with the feedback
  final int? missionID; // Mission ID to associate with the feedback
  final int feedbackModelID; // Feedback model ID

  const AddFeedbackScreen({
    super.key,
    required this.clientID,
    required this.missionID,
    required this.feedbackModelID,
  });

  @override
  _AddFeedbackScreenState createState() => _AddFeedbackScreenState();
}

class _AddFeedbackScreenState extends State<AddFeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final FeedbackController feedbackController = Get.put(FeedbackController());
  final ImagePicker _picker = ImagePicker(); // For image selection
  List<XFile>? _imageFiles; // Store selected images
  String label = '';
  String desc = '';
  double? lat;
  double? lng;
  DateTime? requestDate; // Store request date

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Feedback'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Label field
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Label',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  label = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a label';
                  }
                  return null;
                },
              ),
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
              const SizedBox(height: 16),

              // Latitude field

              const SizedBox(height: 16),

              // Request Date field
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Request Date',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () async {
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
                },
                validator: (value) {
                  if (requestDate == null) {
                    return 'Please select a request date';
                  }
                  return null;
                },
                controller: TextEditingController(
                    text: requestDate != null
                        ? "${requestDate!.toLocal()}".split(' ')[0]
                        : ''),
              ),
              const SizedBox(height: 16),

              // Image selection
              ElevatedButton(
                onPressed: () async {
                  // Pick multiple images
                  final List<XFile>? pickedFiles =
                      await _picker.pickMultiImage();
                  if (pickedFiles != null) {
                    setState(() {
                      _imageFiles = pickedFiles; // Save selected images
                    });
                  }
                },
                child: const Text('Select Images'),
              ),
              if (_imageFiles != null && _imageFiles!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text('Selected Images:'),
                for (var file in _imageFiles!)
                  Text(file.name), // Display selected image names
              ],
              const SizedBox(height: 32),

              // Submit button
              GetBuilder<FeedbackController>(
                init: FeedbackController(),
                builder: (controller) {
                  return ElevatedButton(
                    onPressed: controller.isLoadingadd
                        ? null
                        : () async {
                            LocationService.getCurrentLocation(context)
                                .then((location) {
                              if (location.isPermissionGranted == true) {
                                // if (_formKey.currentState!.validate()) {
                                //   _formKey.currentState!.save();
                                //   controller.addFeedback(
                                //     label: label,
                                //     desc: desc,
                                //     lat: location.latitude.toString(),
                                //     lng: location.longitude.toString(),
                                //     requestDate: '01/01/2022',
                                //     clientId: widget.clientID,
                                //     missionId: widget.missionID!,
                                //     feedbackModelId: widget.feedbackModelID,
                                //     images:
                                //         _imageFiles, // Pass the images to the controller
                                //   );
                                // }
                                print("active v auto");
                              } else {
                                print("active localisation auto");
                                // active localisation auto
                              }
                            });
                          },
                    child: controller.isLoadingadd
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Add Feedback'),
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
