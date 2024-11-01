// feedback_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/company_controller.dart';
import 'package:mformatic_crm_delegate/App/Util/Date/formatDate.dart';
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/Style/style_text.dart';
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
  DateTime? _startDate;
  DateTime? _endDate;
  String _startDateText = '';
  String _endDateText = '';

  void _showDateRangeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Select Date Range'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Start Date:'),
                  TextButton(
                    onPressed: () async {
                      DateTime? pickedStartDate = await showDatePicker(
                        context: context,
                        initialDate: _startDate ?? DateTime.now(),
                        firstDate: DateTime(2024),
                        lastDate: DateTime.now(),
                      );

                      if (pickedStartDate != null &&
                          pickedStartDate != _startDate) {
                        setState(() {
                          _startDate = pickedStartDate;
                          _startDateText =
                              _startDate!.toLocal().toString().split(' ')[0];
                        });
                      }
                    },
                    child: Text(
                      _startDate != null
                          ? _startDate!.toLocal().toString().split(' ')[0]
                          : 'Select Start Date',
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('End Date:'),
                  TextButton(
                    onPressed: () async {
                      DateTime? pickedEndDate = await showDatePicker(
                        context: context,
                        initialDate: _endDate ?? DateTime.now(),
                        firstDate: DateTime(2024),
                        lastDate: DateTime.now(),
                      );

                      if (pickedEndDate != null && pickedEndDate != _endDate) {
                        setState(() {
                          _endDate = pickedEndDate;
                          _endDateText =
                              _endDate!.toLocal().toString().split(' ')[0];
                        });
                      }
                    },
                    child: Text(
                      _endDate != null
                          ? _endDate!.toLocal().toString().split(' ')[0]
                          : 'Select End Date',
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  Get.put(FeedbackController()).fetchFeedbacks(
                      companyController.selectCompany!.id.toString(),
                      Get.put(AuthController()).user!.id.toString(),
                      endingDate: _endDate == null
                          ? ""
                          : formatDate(
                              _endDate!.toLocal().toString().split(' ')[0]),
                      startingDate: _startDate == null
                          ? ""
                          : formatDate(
                              _startDate!.toLocal().toString().split(' ')[0]));

                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        });
      },
    );
  }

  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    // Delay the call to fetchFeedbacks until after the widget has been built.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.put(FeedbackController()).fetchFeedbacks(
          companyController.selectCompany!.id.toString(),
          Get.put(AuthController()).user!.id.toString(),
          endingDate: _endDateText,
          startingDate: _startDateText);
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
            endingDate: _endDateText,
            startingDate: _startDateText); // Fetch more when reaching the end
      }
    }
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
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showDateRangeDialog();
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
                    return const Center(child: Text("No feedback available."));
                  }
                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: scrollController,
                    itemCount: feedbackController.feedbacks.length + 1,
                    itemBuilder: (context, index) {
                      if (index < feedbackController.feedbacks.length) {
                        return FeedbackCard(
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
