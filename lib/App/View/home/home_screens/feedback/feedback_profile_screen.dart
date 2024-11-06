import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/Style/style_text.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/stylecontainer.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/refresh.dart';
import 'package:mformatic_crm_delegate/App/View/home/home_screens/screenMissions/mission_details/profile_mission.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/Buttons/buttonall.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';
import '../../../../Controller/home/feedback_controller.dart';
import '../../../../Model/feedback.dart';
import '../../../widgets/Containers/container_blue.dart';
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
    if (date == null) return 'No Date Available'.tr;
    final DateTime parsedDate = DateTime.parse(date);
    return DateFormat('yyyy-MM-dd').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback Details'.tr),
      ),
      body: GetBuilder<FeedbackController>(
        init: FeedbackController(),
        builder: (controller) {
          if (controller.isLoadingprofile) {
            return const Center(child: spinkit);
          }
          if (controller.feedbackprofile == null) {
            return Center(child: Text('Feedback not found.'.tr));
          }
          final feedback = controller.feedbackprofile!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Description
                Text(
                  feedback.label ?? 'No Title'.tr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  feedback.desc ?? 'No Description available'.tr,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                // Date and Location
                feedback.requestDate == null
                    ? Container()
                    : Row(
                        children: [
                          Icon(Icons.date_range,
                              color: Theme.of(context).primaryColor),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'Request Date:'.tr +
                                  " ${formatDate(feedback.requestDate)}",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                const SizedBox(height: 10),
                const SizedBox(height: 20),
                // Creator Information

                _buildContactSection("Client".tr, feedback.client!),
                const SizedBox(height: 10),
                if (feedback.missionId != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: InkWell(
                      onTap: () {
                        if (feedback.missionId != null) {
                          Go.to(
                              context,
                              MissionProfileScreen(
                                  missionId: feedback.missionId!));
                        }
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border:
                                Border.all(color: Colors.grey.withOpacity(0.2)),
                          ),
                          child: ListTile(
                            title: "This feedback has a mission."
                                .tr
                                .style(fontSize: 15),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                            ),
                          )),
                    ),
                  ),

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
                        ))
                    : Text(
                        'No Images available'.tr,
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                const SizedBox(height: 20),

                // Edit Button
                Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: Text('Edit Feedback'.tr),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
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
          ).addRefreshIndicator(
              onRefresh: () =>
                  feedbackController.getFeedbackById(widget.feedbackId));
        },
      ),
    );
  }

  Widget _buildContactSection(title, Clientfeedback client) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: Color.fromARGB(255, 48, 48, 48).withOpacity(0.2)),
        ),
        child: ListTile(
          title: Text(
            title.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Icon(Icons.person,
                      color: Color.fromARGB(255, 48, 48, 48), size: 18),
                  const SizedBox(width: 4),
                  Text(
                    "Full Name".tr + " ${client.fullName}",
                    style: const TextStyle(
                      color: Color.fromARGB(255, 48, 48, 48),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Icon(Icons.phone,
                      color: Color.fromARGB(255, 48, 48, 48), size: 18),
                  const SizedBox(width: 4),
                  Text(
                    "Tel :".tr +
                        " ${(client.tel == null || client.tel == "" ? 'N/A' : client.tel)}",
                    style: const TextStyle(
                      color: Color.fromARGB(255, 48, 48, 48),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Icon(Icons.phone_android_rounded,
                      color: Color.fromARGB(255, 48, 48, 48), size: 18),
                  const SizedBox(width: 4),
                  Text(
                    "Phone :".tr +
                        " ${(client.phone == null || client.phone == "" ? 'N/A' : client.phone)}",
                    style: const TextStyle(
                      color: Color.fromARGB(255, 48, 48, 48),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Icon(Icons.home,
                      color: Color.fromARGB(255, 48, 48, 48), size: 18),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      "Address :".tr +
                          " ${(client.address == "" ? 'N/A' : client.address)}",
                      style: const TextStyle(
                        color: Color.fromARGB(255, 48, 48, 48),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              _buildBusinessDetailsSection(context, client)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent),
          const SizedBox(width: 12),
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessDetailsSection(
    context,
    Clientfeedback client,
  ) {
    return containerwithblue(
      context,
      widget: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Business Information'.tr,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildInfoRow('Sold:'.tr, client.sold!),
            _buildInfoRow('Potential:'.tr, client.potential!),
            _buildInfoRow('Turnover:'.tr, client.turnover!),
            _buildInfoRow('Cashing In:'.tr, client.cashingIn!),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            value.isNotEmpty ? value : 'N/A',
            style: TextStyle(fontSize: 16, color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionInfoSection(
      String title, String content, IconData icon, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: ListTile(
          leading: Icon(icon, color: iconColor),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
          subtitle: Text(content),
        ),
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
