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
import 'widgets/feedback_card.dart';

class FeedbackScreen extends StatefulWidget {
  FeedbackScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final FeedbackController feedbackController = Get.put(FeedbackController());
  final CompanyController companyController = Get.put(CompanyController());

  @override
  void initState() {
    // Delay the call to fetchFeedbacks until after the widget has been built.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.put(FeedbackController()).fetchFeedbacks(
        companyController.selectCompany!.id.toString(),
        Get.put(AuthController()).user!.id.toString(),
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<FeedbackController>(force: true);

    super.dispose();
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
