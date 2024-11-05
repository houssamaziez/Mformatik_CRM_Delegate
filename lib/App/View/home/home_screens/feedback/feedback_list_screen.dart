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

  void showDateRangeDialog(BuildContext context) {
    final CompanyController companyController = Get.put(CompanyController());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Row(
              children: [
                Text(
                  'Select Date Range'.tr,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                Spacer(),
              ],
            ),
            content: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDateSelection(
                      context,
                      'Start Date'.tr,
                      _startDate,
                      () async {
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
                    ),
                    const SizedBox(height: 20),
                    _buildDateSelection(
                      context,
                      'End Date'.tr,
                      _endDate,
                      () async {
                        DateTime? pickedEndDate = await showDatePicker(
                          context: context,
                          initialDate: _endDate ?? DateTime.now(),
                          firstDate: DateTime(2024),
                          lastDate: DateTime.now(),
                        );

                        if (pickedEndDate != null &&
                            pickedEndDate != _endDate) {
                          setState(() {
                            _endDate = pickedEndDate;
                            _endDateText =
                                _endDate!.toLocal().toString().split(' ')[0];
                          });
                        }
                      },
                    ),
                    Tooltip(
                      message: 'Reset Dates',
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _startDate = null;
                            _endDate = null;
                          });
                          Get.put(FeedbackController()).fetchFeedbacks(
                              companyController.selectCompany!.id.toString(),
                              Get.put(AuthController()).user!.id.toString(),
                              endingDate: _endDate == null
                                  ? ""
                                  : formatDate(_endDate!
                                      .toLocal()
                                      .toString()
                                      .split(' ')[0]),
                              startingDate: _startDate == null
                                  ? ""
                                  : formatDate(_startDate!
                                      .toLocal()
                                      .toString()
                                      .split(' ')[0]));

                          Navigator.of(context).pop(); // Close the dialog
                        },
                        icon: Icon(
                          Icons.restore_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  'Cancel'.tr,
                  style: TextStyle(color: Colors.redAccent),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: Text(
                    'OK'.tr,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
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
    _startDate = null;
    _endDate = null;
    _startDateText = '';
    _endDateText = '';
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
    // Get.delete<FeedbackController>(force: true);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Feedbacks".tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showDateRangeDialog(context);
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
                      _startDate = null;
                      _endDate = null;
                      _startDateText = '';
                      _endDateText = '';
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

Widget _buildDateSelection(
    BuildContext context, String label, DateTime? date, Function onPressed) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      const SizedBox(height: 8),
      TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.grey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () => onPressed(),
        child: Center(
          child: Text(
            date != null
                ? date.toLocal().toString().split(' ')[0]
                : 'Select $label'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 14,
            ),
          ),
        ),
      ),
    ],
  );
}
