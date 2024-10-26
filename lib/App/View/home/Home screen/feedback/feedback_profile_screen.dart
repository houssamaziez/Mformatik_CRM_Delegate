import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';
import '../../../../Controller/home/feedback_controller.dart';
import '../../../../Model/feedback.dart';

class FeedbackDetailScreen extends StatefulWidget {
  final String feedbackId;

  FeedbackDetailScreen({Key? key, required this.feedbackId}) : super(key: key);

  @override
  State<FeedbackDetailScreen> createState() => _FeedbackDetailScreenState();
}

class _FeedbackDetailScreenState extends State<FeedbackDetailScreen> {
  final FeedbackController feedbackControllerr = Get.put(FeedbackController());
  @override
  void initState() {
    feedbackControllerr.getFeedbackById(widget.feedbackId);

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Fetch the feedback details when the screen is built

    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback Details'),
      ),
      body: GetBuilder<FeedbackController>(
          init: FeedbackController(),
          builder: (feedbackController) {
            if (feedbackController.isLoadingprofile) {
              return Center(child: spinkit);
            }

            // Check if feedback is found
            if (feedbackController.feedbackprofile == null) {
              return Center(child: Text('Feedback not found.'));
            }

            // Get the specific feedback item

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feedbackController.feedbackprofile!.label ?? 'No Title',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  SizedBox(height: 16),
                  Text(
                    feedbackController.feedbackprofile!.desc! ??
                        'No Description',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 16),
                  // Text(
                  //   'Rating: ${feedback.feedbackModelId ?? 'No Rating'}',
                  //   style: TextStyle(fontSize: 18, color: Colors.grey),
                  // ),
                  SizedBox(height: 8),
                  Text(
                    'Date: ${feedbackController.feedbackprofile!.createdAt ?? 'No Date'}',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Optionally, you can add a feature to edit feedback
                      // Get.to(EditFeedbackScreen(feedbackId: feedback.id));
                    },
                    child: Text('Edit Feedback'),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
