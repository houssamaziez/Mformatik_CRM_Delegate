import 'package:flutter/material.dart';
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/extension_padding.dart';

import '../../../../../../Model/mission.dart';
import '../../../../../../Util/Style/stylecontainer.dart';
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
          MissionProfileScreen(mission: mission),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: _getCardColor(mission.isSuccessful).withOpacity(0.2),
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Image.asset(
                "assets/icons/mission.png",
                height: 50,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mission.label,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (mission.desc != null && mission.desc!.isNotEmpty)
                    Text(
                      mission.desc!,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  const SizedBox(height: 12),
                  Text(
                    'Created by: ${mission.creatorUsername}',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Display status with updated design
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Status: ${_getStatusLabel(mission.statusId)}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(mission.statusId),
                        ),
                      ),
                      Text(
                        '${_formatDate(mission.createdAt.toString())}',
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ).paddingOnly(left: 8, right: 8, top: 10),
    );
  }

  // Helper method to get card background color based on isSuccessful
  Color _getCardColor(bool? isSuccessful) {
    if (isSuccessful == true) {
      return const Color.fromARGB(255, 121, 255, 125); // Color for Successful
    } else if (isSuccessful == false) {
      return Colors.orange; // Color for Pending
    }
    return const Color.fromARGB(255, 196, 196, 196); // Color for Unknown
  }

  // Helper method to get status label based on statusId
  String _getStatusLabel(int statusId) {
    switch (statusId) {
      case 1:
        return 'Created';
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
