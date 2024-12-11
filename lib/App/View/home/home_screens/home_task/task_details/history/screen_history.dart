import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timelines/timelines.dart';

import '../../../../../../Model/task.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: Timeline.builder(
          itemCount: historyList.length,
          itemBuilder: (context, index) {
            final history = historyList[index];
            final statusInfo = taskStatusEnumString[history.statusId] ??
                {'label': 'Unknown', 'icon': Icons.help};
            final statusText = statusInfo['label'];
            final statusIcon = statusInfo['icon'];
            final statusColor = getStatusColortask(history.statusId);

            return TimelineTile(
              nodeAlign: TimelineNodeAlign.start,
              contents: Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white,
                elevation: 3,
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
                        color: getStatusColortask(
                            historyList[index - 1].statusId)),
                endConnector: index == historyList.length - 1
                    ? null
                    : SolidLineConnector(
                        color: getStatusColortask(historyList[index].statusId)),
              ),
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
