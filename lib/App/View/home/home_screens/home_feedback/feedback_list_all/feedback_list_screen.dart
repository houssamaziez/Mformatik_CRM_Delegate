// feedback_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/company_controller.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/refresh.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';
import '../../../../../Controller/auth/auth_controller.dart';
import '../../../../../Controller/home/feedback/feedback_controller.dart';
import '../widgets/feedback_card.dart';
import 'sup_controller.dart';

class FeedbackScreen extends StatefulWidget {
  FeedbackScreen({Key? key, this.isItLinkedToAMission}) : super(key: key);
  final bool? isItLinkedToAMission;

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final FeedbackController feedbackController = Get.put(FeedbackController());
  final CompanyController companyController = Get.put(CompanyController());
  final SupControllerFeedbackListScreen supController =
      Get.put(SupControllerFeedbackListScreen());

  late ScrollController scrollController;

  @override
  void initState() {
    supController.cleanData();

    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    // Delay the call to fetchFeedbacks until after the widget has been built.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.put(FeedbackController()).fetchFeedbacks(
          companyController.selectCompany!.id.toString(),
          isItLinkedToAMission: widget.isItLinkedToAMission,
          Get.put(AuthController()).user!.id.toString(),
          endingDate: supController.endDateText,
          startingDate: supController.startDateText);
    });
    super.initState();
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (Get.put(FeedbackController()).offset <=
          Get.put(FeedbackController()).feedbackslength) {
        Get.put(FeedbackController()).addOffset(
            Get.put(CompanyController()).selectCompany!.id.toString(),
            Get.put(AuthController()).user!.id.toString(),
            endingDate: supController.endDateText,
            isItLinkedToAMission: widget.isItLinkedToAMission,
            startingDate: supController
                .startDateText); // Fetch more when reaching the end
      }
    }
  }

  @override
  void dispose() {
    // Get.delete<FeedbackController>(force: true);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All feedbacks".tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              supController.showDateRangeDialog(context);
            },
          ),
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: GetBuilder<FeedbackController>(
                init: FeedbackController(),
                builder: (feedbackController) {
                  if (feedbackController.isLoading.value) {
                    return const Center(child: spinkit);
                  }
                  if (feedbackController.feedbacks.isEmpty) {
                    return Center(child: Text("No feedback available.".tr));
                  }
                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: scrollController,
                    itemCount: feedbackController.feedbacks.length + 1,
                    itemBuilder: (context, index) {
                      if (index < feedbackController.feedbacks.length) {
                        return FeedbackCard(
                            index: index,
                            feedback: feedbackController.feedbacks[index]);
                      } else if (feedbackController.isLoadingoffset.value ==
                          true) {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(child: spinkit),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ).addRefreshIndicator(
                    onRefresh: () {
                      supController.cleanData();
                      return feedbackController.fetchFeedbacks(
                          companyController.selectCompany!.id.toString(),
                          Get.put(AuthController()).user!.id.toString(),
                          isreafrach: true);
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
