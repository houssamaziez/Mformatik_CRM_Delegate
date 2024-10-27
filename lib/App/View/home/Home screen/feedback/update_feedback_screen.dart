import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controller/home/feedback_controller.dart';
import '../../../../Model/feedback.dart';

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

  @override
  void initState() {
    super.initState();
    labelController.text = widget.feedback.label ?? '';
    descController.text = widget.feedback.desc ?? '';
    latController.text = widget.feedback.lat ?? '';
    lngController.text = widget.feedback.lng ?? '';
    requestDateController.text = widget.feedback.requestDate ?? '';
    clientIdController.text = widget.feedback.clientId.toString();
    feedbackModelIdController.text = widget.feedback.feedbackModelId.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Feedback')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(labelController, 'Label', 'Enter feedback label'),
            _buildTextField(
                descController, 'Description', 'Enter a description',
                maxLines: 3),
            _buildTextField(latController, 'Latitude', 'Enter latitude',
                keyboardType: TextInputType.number),
            _buildTextField(lngController, 'Longitude', 'Enter longitude',
                keyboardType: TextInputType.number),
            _buildTextField(
                requestDateController, 'Request Date', 'YYYY-MM-DD'),
            _buildTextField(clientIdController, 'Client ID', 'Enter client ID',
                keyboardType: TextInputType.number),
            _buildTextField(feedbackModelIdController, 'Feedback Model ID',
                'Enter model ID',
                keyboardType: TextInputType.number),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleUpdateFeedback,
              child: Text('Update Feedback'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
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
      padding: EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: placeholder,
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  void _handleUpdateFeedback() {
    if (labelController.text.isEmpty || descController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all required fields',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    feedbackController
        .updateFeedback(
          feedbackId: widget.feedback.id.toString(),
          label: labelController.text,
          desc: descController.text,
          lat: latController.text,
          lng: lngController.text,
          requestDate: requestDateController.text,
          clientId: int.parse(clientIdController.text),
          feedbackModelId: int.parse(feedbackModelIdController.text),
        )
        .then((success) {});
  }
}
