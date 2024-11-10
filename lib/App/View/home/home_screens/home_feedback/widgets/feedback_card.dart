import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/stylecontainer.dart';

import '../../../../../Model/feedback.dart';
import '../../../../../Util/Route/Go.dart';
import '../feedback_details/feedback_profile_screen.dart';

class FeedbackCard extends StatelessWidget {
  final FeedbackMission feedback;
  final int index;
  const FeedbackCard({Key? key, required this.feedback, required this.index})
      : super(key: key);

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
          decoration: StyleContainer.style1,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${index + 1}- " + ("${feedback.label?.toString()}") ??
                            '',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      feedback.desc!.isEmpty
                          ? Container()
                          : const SizedBox(height: 6),
                      Text(
                        feedback.desc ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      feedback.desc!.isEmpty
                          ? Container()
                          : const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.person, color: Colors.grey, size: 18),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              "Client: ${feedback.client!.fullName}",
                              style: const TextStyle(
                                color: Color.fromARGB(255, 37, 37, 37),
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.circle,
                              color: feedback.missionId == null
                                  ? Colors.red
                                  : Colors.green,
                              size: 16),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              "Status".tr +
                                  ": " +
                                  "${(feedback.missionId == null ? "With Out Mission".tr : "With Mission".tr)}",
                              style: TextStyle(
                                color: feedback.missionId == null
                                    ? Colors.red
                                    : Colors.green,
                                fontSize: 13,
                              ),
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
                            "Date:".tr +
                                " ${feedback.createdAt?.split('T')[0]}",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 37, 37, 37),
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
                            "Updated Date :".tr +
                                " ${feedback.updatedAt?.split('T')[0]}",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 37, 37, 37),
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
