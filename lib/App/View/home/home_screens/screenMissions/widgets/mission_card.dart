import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:mformatic_crm_delegate/App/Util/Date/formatDate.dart';
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';
import 'package:mformatic_crm_delegate/App/Util/Style/stylecontainer.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/extension_padding.dart';

import '../../../../../Model/mission.dart';
import '../profile_mission.dart';

class MissionCard extends StatelessWidget {
  final Mission mission;

  const MissionCard({Key? key, required this.mission}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Go.to(
          context,
          MissionProfileScreen(missionId: mission.id),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 10),
        child: Container(
          decoration: StyleContainer.style1,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            mission.label!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          if (mission.desc != null && mission.desc!.isNotEmpty)
                            Text(
                              mission.desc!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(Icons.person,
                                  color: Color.fromARGB(255, 37, 37, 37),
                                  size: 18),
                              const SizedBox(width: 4),
                              Text(
                                'Created by:'.tr +
                                    " ${mission.creatorUsername}",
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 37, 37, 37),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          // Display status with updated design
                          Row(
                            children: [
                              Icon(Icons.circle,
                                  color: _getStatusColor(mission.statusId!),
                                  size: 14),
                              const SizedBox(width: 4),
                              Text(
                                'Status:'.tr +
                                    " ${getStatusLabel(mission.statusId!)}",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: _getStatusColor(mission.statusId!),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),

                          Row(
                            children: [
                              Icon(Icons.person_pin,
                                  color: Colors.black, size: 18),
                              const SizedBox(width: 4),
                              Text(
                                "Client: ${mission.client!.fullName}",
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
                              Icon(Icons.date_range,
                                  color: Color.fromARGB(255, 37, 37, 37),
                                  size: 18),
                              const SizedBox(width: 4),
                              Text(
                                "Date: ${formatDate(mission.createdAt.toString())}",
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
                              Icon(Icons.date_range,
                                  color: Colors.black, size: 18),
                              const SizedBox(width: 4),
                              Text(
                                "Updated Date :".tr +
                                    "${formatDate(mission.updatedAt.toString())}",
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 37, 37, 37),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
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

  // Helper method to get card background color based on isSuccessful
  Color _getCardColor(bool? isSuccessful) {
    if (isSuccessful == true) {
      return const Color.fromARGB(255, 196, 196, 196); // Color for Successful
    } else if (isSuccessful == false) {
      return Colors.orange; // Color for Pending
    }
    return const Color.fromARGB(255, 196, 196, 196); // Color for Unknown
  }

  // Helper method to get color based on statusId
  Color _getStatusColor(int statusId) {
    switch (statusId) {
      case 1:
        return Colors.blue; // Color for Created
      case 2:
        return Colors.orange; // Color for In Progress
      case 3:
        return Colors.green; // Color for Completed
      case 4:
        return Colors.red; // Color for Canceled
      default:
        return Colors.grey; // Color for Unknown status
    }
  }

  // Helper method to format the date
  String _formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
  }
}

// Helper method to get status label based on statusId
String getStatusLabel(int statusId) {
  switch (statusId) {
    case 1:
      return 'New';
    case 2:
      return 'In Progress';
    case 3:
      return 'Completed';
    case 4:
      return 'Canceled';
    default:
      return 'Unknown Status';
  }
}
