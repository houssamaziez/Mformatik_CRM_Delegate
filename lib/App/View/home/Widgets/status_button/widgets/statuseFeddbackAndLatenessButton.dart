
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/Style/style_text.dart';

import '../../../../../Controller/home/feedback/feedback_controller.dart';
import '../../../../../Util/Route/Go.dart';
import '../../../../../Util/Style/stylecontainer.dart';
import '../../../../widgets/Containers/container_blue.dart';
import '../../../../widgets/flutter_slider.dart';
import '../../../../widgets/flutter_spinkit.dart';
import '../../../home_screens/home_feedback/feedback_filter/feedback_list_screen_filter.dart';

Expanded statuseFeddbackAndLatenessButton(
    BuildContext context, Color Function(int value) getSliderColor) {
  return Expanded(
      flex: 3,
      child: GetBuilder<FeedbackController>(
          init: FeedbackController(),
          builder: (missionsController) {
            return missionsController.isLoading == false
                ? Container(
                    decoration: StyleContainer.style1,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 5.0, right: 4, top: 8, bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Statistics Feedback".tr,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                    fontSize: 12),
                              ),
                              const Spacer(),
                              // Text(
                              //   "All".tr +
                              //       "(" +
                              //       missionsController.feedbackslength
                              //           .toString() +
                              //       ")",
                              //   style: TextStyle(
                              //       fontWeight: FontWeight.w500,
                              //       fontSize: 12,
                              //       color: Theme.of(context).primaryColor),
                              // ),
                              const SizedBox(
                                width: 10,
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                              height: 24,
                              width: double.infinity,
                              child: containerwithblue(
                                context,
                                color: const Color.fromARGB(255, 199, 199, 199),
                                widget: Row(
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Go.to(
                                            context,
                                            FeedbackScreenFilter(
                                              isItLinkedToAMission: false,
                                            ));
                                      },
                                      child: Row(
                                        children: [
                                          const CircleAvatar(
                                            radius: 4,
                                            backgroundColor: Color(0XffD12525),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "With Out Mission".tr +
                                                " ${missionsController.feedbacksWithOutMission}",
                                            style:
                                                const TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    InkWell(
                                      onTap: () {
                                        Go.to(
                                            context,
                                            FeedbackScreenFilter(
                                              isItLinkedToAMission: true,
                                            ));
                                      },
                                      child: Row(
                                        children: [
                                          const CircleAvatar(
                                            radius: 5,
                                            backgroundColor: Color(0Xff26931D),
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            "With Mission".tr +
                                                " ${missionsController.feedbacksWithMission}",
                                            style:
                                                const TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              )),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            "Percentage".tr,
                            style: const TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 12),
                          ),
                          InkWell(
                            onTap: () {
                              Go.to(
                                  context,
                                  FeedbackScreenFilter(
                                    isItLinkedToAMission: true,
                                  ));
                            },
                            child: SizedBox(
                              height: 24,
                              child: Row(
                                children: [
                                  flutterSlider(
                                      getSliderColor,
                                      missionsController.feedbackslength
                                          .toDouble(),
                                      missionsController.feedbacksWithMission
                                          .toDouble(),
                                      Colors.green),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  missionsController.feedbacksWithMission == 0
                                      ? 0.toString().style()
                                      : ((missionsController
                                                      .feedbacksWithMission *
                                                  100) /
                                              missionsController
                                                  .feedbackslength)
                                          .toStringAsFixed(2)
                                          .style(),
                                  "%".style(),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Go.to(
                                  context,
                                  FeedbackScreenFilter(
                                    isItLinkedToAMission: true,
                                  ));
                            },
                            child: InkWell(
                              onTap: () {
                                Go.to(
                                    context,
                                    FeedbackScreenFilter(
                                      isItLinkedToAMission: false,
                                    ));
                              },
                              child: SizedBox(
                                height: 24,
                                child: Row(
                                  children: [
                                    flutterSlider(
                                        getSliderColor,
                                        missionsController.feedbackslength
                                            .toDouble(),
                                        missionsController
                                            .feedbacksWithOutMission
                                            .toDouble(),
                                        Colors.red),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    missionsController
                                                .feedbacksWithOutMission ==
                                            0
                                        ? 0.toString().style()
                                        : ((missionsController
                                                        .feedbacksWithOutMission *
                                                    100) /
                                                missionsController
                                                    .feedbackslength)
                                            .toStringAsFixed(2)
                                            .style(),
                                    "%".style(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const Spacer()
                        ],
                      ),
                    ),
                  )
                : Container(
                    decoration: StyleContainer.style1,
                    child: const Center(child: spinkit));
          }));
}
