import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Util/Theme/colors.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/refresh.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';

import '../../../Controller/home/missions_controller.dart';
import '../../../Model/mission.dart';
import '../../../Util/Style/stylecontainer.dart';

class MissionListScreen extends StatelessWidget {
  const MissionListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize the MissionsController
    final MissionsController controller = Get.put(MissionsController());

    // Fetch all missions when the screen is built
    controller.getAllMission(context);

    return Scaffold(
      backgroundColor: ColorsApp.white,
      appBar: AppBar(
        title: Text('Missions'.tr),
        centerTitle: true,
      ),
      body: GetBuilder<MissionsController>(
        builder: (_) {
          if (controller.isLoading) {
            // Show a loading indicator while fetching data
            return const Center(
              child: spinkit,
            );
          } else if (controller.missions == null ||
              controller.missions!.isEmpty) {
            // Show a message when there are no missions
            return Center(
              child: Text(
                'No missions available'.tr,
                style: const TextStyle(fontSize: 18),
              ),
            );
          } else {
            // Display the list of missions
            return ListView.builder(
              itemCount: controller.missions!.length,
              itemBuilder: (context, index) {
                final mission = controller.missions![index];
                return MissionCard(mission: mission);
              },
            ).addRefreshIndicator(
                onRefresh: () => controller.getAllMission(context));
          }
        },
      ),
    );
  }
}

// A separate widget for displaying individual mission cards
class MissionCard extends StatelessWidget {
  final Mission mission;

  const MissionCard({Key? key, required this.mission}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: StyleContainer.style1,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mission.label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (mission.desc != null && mission.desc!.isNotEmpty)
                Text(
                  mission.desc!,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              const SizedBox(height: 8),
              Text(
                'Creator: ${mission.creatorUsername}',
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(height: 8),
              Text(
                'Status: ${mission.isSuccessful == true ? 'Successful' : 'Pending'}',
                style: TextStyle(
                  fontSize: 12,
                  color: mission.isSuccessful == true
                      ? Colors.green
                      : Colors.orange,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Created at: ${mission.createdAt}',
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
