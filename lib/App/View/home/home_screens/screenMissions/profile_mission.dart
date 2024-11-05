import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/missions_controller.dart';
import 'package:mformatic_crm_delegate/App/Util/Date/formatDate.dart';
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';
import 'package:mformatic_crm_delegate/App/Util/extension/refresh.dart';
import 'package:mformatic_crm_delegate/App/View/home/home_screens/feedback/feedback_profile_screen.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/flutter_spinkit.dart';

import '../../../../Model/mission.dart';
import '../../../widgets/Containers/container_blue.dart';
import '../../../widgets/Dialog/showExitConfirmationDialog.dart';
import '../feedback/cretate_screen.dart';
import 'widgets/getStatusColor.dart';
import 'widgets/getStatusLabel.dart';

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
      appBar: AppBar(
        title: Text('Mission Details'.tr),
        centerTitle: true,
        backgroundColor: theme.primaryColor,
      ),
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
                      backgroundColor: Colors.green,
                      onPressed: () async {
                        showExitConfirmationDialog(context,
                            onPressed: () async {
                          Get.back();

                          await controller.changeStatuseMission(
                              2, widget.missionId);
                        },
                            details: 'Are you sure to Start the Mission?'.tr,
                            title: 'Cnfirmation'.tr);
                      },
                      label: Text(
                        "Start Mission".tr,
                        style: TextStyle(color: Colors.white),
                      )),
                const SizedBox(
                  height: 20,
                ),
                if (mission.statusId == 2)
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
                      label: Text(
                        "Add Feedback".tr,
                        style: TextStyle(color: Colors.white),
                      )),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  _buildMissionHeader(context, mission),
                  const SizedBox(height: 16),
                  InkWell(
                    child: _buildMissionInfoSectionClient('Clinet'.tr,
                        mission.client!, Icons.person_pin, theme.primaryColor),
                  ),
                  _buildMissionStatusSection(
                      theme, mission.statusId!, controller),
                  if (mission.feedback!.id != 0)
                    InkWell(
                      onTap: () {
                        if (mission.feedback!.id != 1) {
                          Go.to(
                              context,
                              FeedbackDetailScreen(
                                  feedbackId: mission.feedback!.id.toString()));
                        }
                      },
                      child: _buildMissionInfoSection(
                          'Feedback'.tr,
                          mission.feedback!.label.toString(),
                          Icons.feed,
                          theme.primaryColor),
                    ),
                  // _buildMissionInfoSection(
                  //     'Mission Description'.tr,
                  //     mission.desc ?? 'No description available'.tr,
                  //     Icons.description,
                  //     theme.primaryColor),
                  _buildMissionInfoSection(
                      'Creator Username'.tr,
                      mission.creatorUsername!,
                      Icons.person,
                      theme.primaryColor),
                  _buildMissionInfoSection(
                      'Editor Username'.tr,
                      mission.editorUsername ?? 'No editor assigned'.tr,
                      Icons.edit,
                      theme.primaryColor),
                  _buildMissionInfoSection(
                      'Created At'.tr,
                      formatDate(mission.createdAt.toString()),
                      Icons.date_range,
                      theme.primaryColor),

                  SizedBox(
                    height: 75,
                  )
                ],
                // ignore: avoid_print
              ).addRefreshIndicator(
                  onRefresh: () => missionController.getMissionById(
                      context, widget.missionId)),
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
            mission.label!,
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

  Widget _buildBusinessDetailsSection(
    context,
    ClientMission client,
  ) {
    return containerwithblue(
      context,
      widget: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Business Information'.tr,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildInfoRow('Sold:'.tr, client.sold!),
            _buildInfoRow('Potential:'.tr, client.potential!),
            _buildInfoRow('Turnover:'.tr, client.turnover!),
            _buildInfoRow('Cashing In:'.tr, client.cashingIn!),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          Text(
            value.isNotEmpty ? value : 'N/A',
            style: TextStyle(fontSize: 13, color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionInfoSectionClient(
      String title, ClientMission client, IconData icon, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: ListTile(
          title: Text(
            title.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Icon(Icons.person, color: Colors.grey, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    "Full Name".tr + " ${client.fullName}",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Icon(Icons.phone, color: Colors.grey, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    "Tel :".tr + " ${(client.tel == "" ? 'N/A' : client.tel)}",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Icon(Icons.phone_android_rounded,
                      color: Colors.grey, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    "Phone :".tr +
                        " ${(client.phone == "" ? 'N/A' : client.phone)}",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Icon(Icons.home, color: Colors.grey, size: 18),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      "Address :".tr +
                          " ${(client.address == "" ? 'N/A' : client.address)}",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              _buildBusinessDetailsSection(context, client)
            ],
          ),
        ),
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

  Widget _buildMissionStatusSection(
      ThemeData theme, int statusId, MissionsController controller) {
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
          trailing: statusId == 2
              ? IconButton(
                  onPressed: () {
                    showExitConfirmationDialog(context, onPressed: () async {
                      Get.back();

                      await controller.changeStatuseMission(
                          1, widget.missionId);
                    },
                        details: 'Are you sure to Stop the Mission?'.tr,
                        title: 'Cnfirmation'.tr);
                  },
                  icon: Icon(
                    Icons.stop_circle_outlined,
                    color: Colors.red,
                  ))
              : statusId == 1
                  ? IconButton(
                      onPressed: () {
                        showExitConfirmationDialog(context,
                            onPressed: () async {
                          Get.back();

                          await controller
                              .changeStatuseMission(2, widget.missionId)
                              .then((onValue) {});
                        },
                            details: 'Are you sure to Start the Mission?'.tr,
                            title: 'Cnfirmation'.tr);
                      },
                      icon: Icon(
                        Icons.play_circle_outline_outlined,
                        color: Colors.green,
                      ))
                  : Container(
                      height: 4,
                      width: 4,
                    ),
        ),
      ),
    );
  }
}
