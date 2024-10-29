import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/stylecontainer.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';
import '../../../../Controller/home/feedback_controller.dart';
import '../../../../Model/feedback.dart';
import 'update_feedback_screen.dart';

class FeedbackDetailScreen extends StatefulWidget {
  final String feedbackId;

  FeedbackDetailScreen({Key? key, required this.feedbackId}) : super(key: key);

  @override
  State<FeedbackDetailScreen> createState() => _FeedbackDetailScreenState();
}

class _FeedbackDetailScreenState extends State<FeedbackDetailScreen> {
  final FeedbackController feedbackController = Get.put(FeedbackController());

  @override
  void initState() {
    // Delay the call to fetchFeedbacks until after the widget has been built.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      feedbackController.getFeedbackById(widget.feedbackId);
    });
    super.initState();
  }

  String formatDate(String? date) {
    if (date == null) return 'No Date Available';
    final DateTime parsedDate = DateTime.parse(date);
    return DateFormat('yyyy-MM-dd – kk:mm').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback Details'),
      ),
      body: GetBuilder<FeedbackController>(
        init: FeedbackController(),
        builder: (controller) {
          if (controller.isLoadingprofile) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.feedbackprofile == null) {
            return const Center(child: Text('Feedback not found.'));
          }
          final feedback = controller.feedbackprofile!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Description
                Text(
                  feedback.label ?? 'No Title',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                    color: Colors.blueGrey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  feedback.desc ?? 'No Description available',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                // Date and Location
                Row(
                  children: [
                    const Icon(Icons.date_range, color: Colors.blueGrey),
                    const SizedBox(width: 8),
                    Text(
                      'Date: ${formatDate(feedback.createdAt)}',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 20),
                // Creator Information
                const Divider(),
                const Text(
                  'Creator Information',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.blueGrey,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Username: ${feedback.creatorUsername ?? 'No Username'}',
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 10),
                // Gallery
                const Divider(),
                const Text(
                  'Gallery',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.blueGrey,
                  ),
                ),
                const SizedBox(height: 10),
                feedback.gallery.isNotEmpty
                    ? SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: feedback.gallery.length,
                          itemBuilder: (context, index) {
                            final imagePath = feedback.gallery[index]['path'];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: InkWell(
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
                            );
                          },
                        ),
                      )
                    : Text(
                        'No Images available',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                const SizedBox(height: 20),

                // Edit Button
                Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Feedback'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      Go.to(
                          context,
                          UpdateFeedbackScreen(
                            feedback: feedback,
                          ));
                      // Navigate to EditFeedbackScreen
                      // Get.to(EditFeedbackScreen(feedbackId: feedback.id));
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

void showFullscreenImage(context, String imageUrl) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.black,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: InteractiveViewer(
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.contain,
            errorWidget: (context, url, error) =>
                const Icon(Icons.error, color: Colors.white),
          ),
        ),
      ),
    ),
  );
}
