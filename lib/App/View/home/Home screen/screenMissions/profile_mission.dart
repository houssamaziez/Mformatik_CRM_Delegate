import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/missions_controller.dart';
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';

import '../../../../Model/mission.dart';
import '../../../widgets/Dialog/showExitConfirmationDialog.dart';
import '../feedback/add_feedback.dart';
import '../feedback/cretate_screen.dart';

class MissionProfileScreen extends StatefulWidget {
  final int missionId;

  MissionProfileScreen({Key? key, required this.missionId}) : super(key: key);

  @override
  State<MissionProfileScreen> createState() => _MissionProfileScreenState();
}

class _MissionProfileScreenState extends State<MissionProfileScreen> {
  final missionController = Get.put(MissionsController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      missionController.getMissionById(context, widget.missionId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Fetch mission by ID on widget build

    return Scaffold(
      body: GetBuilder<MissionsController>(
        init: MissionsController(),
        builder: (controller) {
          if (controller.isLoadingProfile) {
            return const Center(child: spinkit);
          }
          if (controller.mission == null) {
            return Center(child: Text('Mission not found'.tr));
          }
          final mission = controller.mission!;

          return Scaffold(
            floatingActionButton: Column(
              children: [
                const Spacer(),
                if (mission.statusId == 1)
                  FloatingActionButton.extended(
                      heroTag: "IN_PROGRESS", // Unique tag for the first button

                      backgroundColor: Theme.of(context).primaryColor,
                      onPressed: () async {
                        showExitConfirmationDialog(context,
                            onPressed: () async {
                          await controller.changeStatuseMission(
                              2, widget.missionId);
                          Get.back();
                        },
                            details: 'Are you sure to Start the Mission?',
                            title: 'Cnfirmation');
                      },
                      label: const Text(
                        "Start Mission",
                        style: TextStyle(color: Colors.white),
                      )),
                if (mission.statusId == 2)
                  FloatingActionButton.extended(
                      heroTag: "COMPLETED", // Unique tag for the first button

                      backgroundColor: getStatusColor(3),
                      onPressed: () async {
                        showExitConfirmationDialog(context,
                            onPressed: () async {
                          await controller.changeStatuseMission(
                              3, widget.missionId);
                          Get.back();
                        },
                            details: 'Are you sure to complete the Mission?',
                            title: 'Cnfirmation');
                      },
                      label: const Text(
                        "Completed Mission",
                        style: TextStyle(color: Colors.white),
                      )),
                const SizedBox(
                  height: 20,
                ),
                if (mission.statusId == 3)
                  FloatingActionButton.extended(
                      heroTag:
                          "addFeedback2", // Unique tag for the first button

                      backgroundColor: Theme.of(context).primaryColor,
                      onPressed: () {
                        Go.to(
                            context,
                            CreateFeedBackScreen(
                              clientID: mission.clientId,
                              feedbackModelID: 16,
                              missionID: mission.id,
                            ));
                      },
                      label: const Text(
                        "Add Feedback",
                        style: TextStyle(color: Colors.white),
                      )),
              ],
            ),
            appBar: AppBar(
              title: Text('Mission Details'.tr),
              centerTitle: true,
              backgroundColor: theme.primaryColor,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  _buildMissionHeader(context, mission),
                  const SizedBox(height: 16),
                  _buildMissionInfoSection('Mission Label'.tr, mission.label,
                      Icons.label, theme.primaryColor),
                  _buildMissionStatusSection(theme, mission.statusId),
                  _buildMissionInfoSection(
                      'Mission Description'.tr,
                      mission.desc ?? 'No description available'.tr,
                      Icons.description,
                      theme.primaryColor),
                  _buildMissionInfoSection(
                      'Creator Username'.tr,
                      mission.creatorUsername,
                      Icons.person,
                      theme.primaryColor),
                  _buildMissionInfoSection(
                      'Editor Username'.tr,
                      mission.editorUsername ?? 'No editor assigned'.tr,
                      Icons.edit,
                      theme.primaryColor),
                  _buildMissionInfoSection(
                      'Created At'.tr,
                      mission.createdAt.toString(),
                      Icons.date_range,
                      theme.primaryColor),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMissionHeader(BuildContext context, Mission mission) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            mission.label,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            mission.desc ?? 'No description available'.tr,
            style:
                theme.textTheme.titleMedium?.copyWith(color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionInfoSection(
      String title, String content, IconData icon, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: ListTile(
          leading: Icon(icon, color: iconColor),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
          subtitle: Text(content),
        ),
      ),
    );
  }

  Widget _buildMissionStatusSection(ThemeData theme, int statusId) {
    String statusLabel = getStatusLabel(statusId);
    Color statusColor = getStatusColor(statusId);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Icon(
            Icons.circle,
            color: statusColor,
          ),
          title: Text(
            'Status'.tr,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
            ),
          ),
          subtitle: Text(
            statusLabel,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

String getStatusLabel(int statusId) {
  switch (statusId) {
    case 1:
      return 'Created'.tr; // Translates to "Created"
    case 2:
      return 'In Progress'.tr; // Translates to "In Progress"
    case 3:
      return 'Completed'.tr; // Translates to "Completed"
    case 4:
      return 'Canceled'.tr; // Translates to "Canceled"
    default:
      return 'Unknown Status'.tr; // Fallback for unknown status
  }
}

Color getStatusColor(int statusId) {
  switch (statusId) {
    case 1: // CREATED
      return Colors.blue; // Color for created status
    case 2: // IN_PROGRESS
      return Colors.orange; // Color for in progress
    case 3: // COMPLETED
      return Colors.green; // Color for completed
    case 4: // CANCELED
      return Colors.red; // Color for canceled
    default:
      return Colors.grey; // Fallback color for unknown status
  }
}
