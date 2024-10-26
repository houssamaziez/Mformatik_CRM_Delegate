// feedback_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/company_controller.dart';
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/refresh.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';

import '../../../../Controller/auth/auth_controller.dart';
import '../../../../Controller/home/feedback_controller.dart';
import '../../../../Model/feedback.dart';
import 'feedback_profile_screen.dart';

class FeedbackScreen extends StatefulWidget {
  FeedbackScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final FeedbackController feedbackController =
      Get.put(FeedbackController(), permanent: true);
  final CompanyController companyController = Get.put(CompanyController());

  @override
  void initState() {
    feedbackController.fetchFeedbacks(
        companyController.selectCompany!.id.toString(),
        Get.put(AuthController()).user!.id.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Feedbacks"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (feedbackController.isLoading.value) {
                return const Center(child: spinkit);
              }
              if (feedbackController.feedbacks.isEmpty) {
                return const Center(child: Text("No feedback available."));
              }
              return ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                controller: feedbackController.scrollController,
                itemCount: feedbackController.feedbacks.length + 1,
                itemBuilder: (context, index) {
                  if (index < feedbackController.feedbacks.length) {
                    return FeedbackCard(
                        feedback: feedbackController.feedbacks[index]);
                  } else if (feedbackController.isLoading.value) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else {
                    return Container(); // Empty container for end of list
                  }
                },
              ).addRefreshIndicator(
                onRefresh: () => feedbackController.fetchFeedbacks(
                    companyController.selectCompany!.id.toString(),
                    Get.put(AuthController()).user!.id.toString(),
                    isreafrach: true),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class FeedbackCard extends StatelessWidget {
  final FeedbackMission feedback;

  const FeedbackCard({Key? key, required this.feedback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: InkWell(
        onTap: () {
          Go.to(
              context,
              FeedbackDetailScreen(
                feedbackId: feedback.id.toString(),
              ));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 4), // Shadow position
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset(
                    "assets/icons/satisfaction.png",
                    height: 40,
                    width: 40,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feedback.label?.toString() ?? '',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        feedback.desc ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.person, color: Colors.grey, size: 18),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              "Client: ${feedback.clientFullName}",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.account_circle,
                              color: Colors.grey, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            "Created by: ${feedback.creatorUsername}",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.date_range, color: Colors.grey, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            "Date: ${feedback.createdAt?.split('T')[0]}",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
