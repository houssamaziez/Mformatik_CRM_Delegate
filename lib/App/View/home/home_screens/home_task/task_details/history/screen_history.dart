import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timelines/timelines.dart';

import '../../../../../../Model/task_models/history.dart';
import '../../widgets/getStatusColor.dart';

const taskStatusEnumString = {
  1: {'label': 'New', 'icon': Icons.fiber_new},
  2: {'label': 'Start', 'icon': Icons.play_arrow},
  3: {'label': 'Owner Respond', 'icon': Icons.person},
  4: {'label': 'Responsible Respond', 'icon': Icons.handshake},
  5: {'label': 'Responsible Close', 'icon': Icons.check},
  6: {'label': 'Close', 'icon': Icons.done},
  7: {'label': 'Canceled', 'icon': Icons.cancel},
};

class HistoryTimelineScreen extends StatelessWidget {
  final List<History> historyList;

  const HistoryTimelineScreen({super.key, required this.historyList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: Timeline.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: historyList.length,
          itemBuilder: (context, index) {
            final history = historyList[index];
            final statusInfo = taskStatusEnumString[history.statusId] ??
                {'label': 'Unknown', 'icon': Icons.help};
            final statusText = statusInfo['label'];
            final statusIcon = statusInfo['icon'];
            final statusColor = getStatusColorTask(history.statusId);

            return Stack(
              children: [
                if (index != 0)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 7,
                    ),
                    child: Container(
                      child: Transform.rotate(
                        angle: 1.2,
                        child: Text(
                          timeDifference(historyList[index - 1].createdAt,
                              historyList[index].createdAt),
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: getStatusColorTask(
                                  historyList[index - 1].statusId)),
                        ),
                      ),
                    ),
                  ),
                TimelineTile(
                  nodeAlign: TimelineNodeAlign.start,
                  contents: Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: Colors.grey,
                          )),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  statusIcon as IconData?,
                                  color: statusColor,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  statusText.toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: statusColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  color: Colors.black54,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  formatDate(history.createdAt),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  node: TimelineNode(
                    indicator: DotIndicator(
                      size: 24,
                      color: statusColor,
                      child: Tooltip(
                        message: statusText.toString(),
                        child: Icon(
                          statusIcon as IconData?,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                    startConnector: index == 0
                        ? null
                        : SolidLineConnector(
                            color: getStatusColorTask(
                                historyList[index - 1].statusId)),
                    endConnector: index == historyList.length - 1
                        ? null
                        : SolidLineConnector(
                            color: getStatusColorTask(
                                historyList[index].statusId)),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

String formatDate(DateTime dateTime) {
  try {
    return DateFormat(' yyyy-MM-dd HH:mm').format(dateTime);
  } catch (e) {
    return 'Invalid Date';
  }
}

String formatDateWithDay(DateTime dateTime) {
  try {
    return DateFormat('EEEE').format(dateTime);
  } catch (e) {
    return 'Invalid Date';
  }
}

String timeDifference(DateTime date1, DateTime date2) {
  final difference = date1.difference(date2);

  if (difference.inDays > 365) {
    return '${(difference.inDays ~/ 365)} yr';
  } else if (difference.inDays > 0) {
    return '${difference.inDays} day';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} hr';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} mnt';
  } else {
    return '${difference.inSeconds} sec';
  }
}
