import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Model/mission.dart';

class MissionProfileScreen extends StatelessWidget {
  final Mission mission;

  const MissionProfileScreen({Key? key, required this.mission})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Mission Details'.tr),
        centerTitle: true,
        backgroundColor: theme.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildMissionHeader(context),
            const SizedBox(height: 16),
            _buildMissionInfoSection('Mission Label'.tr, mission.label,
                Icons.label, theme.primaryColor),
            _buildMissionStatusSection(theme),
            _buildMissionInfoSection(
                'Mission Description'.tr,
                mission.desc ?? 'No description available'.tr,
                Icons.description,
                theme.primaryColor),
            _buildMissionInfoSection('Creator Username'.tr,
                mission.creatorUsername, Icons.person, theme.primaryColor),
            _buildMissionInfoSection(
                'Creator Role ID'.tr,
                mission.creatorRoleId.toString(),
                Icons.account_circle,
                theme.primaryColor),
            _buildMissionInfoSection(
                'Editor Username'.tr,
                mission.editorUsername ?? 'No editor assigned'.tr,
                Icons.edit,
                theme.primaryColor),
            _buildMissionInfoSection(
                'Editor Role ID'.tr,
                mission.editorRoleId?.toString() ?? 'N/A',
                Icons.account_circle,
                theme.primaryColor),
            _buildMissionInfoSection(
                'Client ID'.tr,
                mission.clientId.toString(),
                Icons.business,
                theme.primaryColor),
            _buildMissionInfoSection(
                'Responsible ID'.tr,
                mission.responsibleId.toString(),
                Icons.person,
                theme.primaryColor),
            _buildMissionInfoSection('Reason ID'.tr,
                mission.reasonId.toString(), Icons.help, theme.primaryColor),
            _buildMissionInfoSection(
                'Created At'.tr,
                mission.createdAt.toString(),
                Icons.date_range,
                theme.primaryColor),
            if (mission.updatedAt != null)
              _buildMissionInfoSection(
                  'Updated At'.tr,
                  mission.updatedAt.toString(),
                  Icons.update,
                  theme.primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionHeader(BuildContext context) {
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

  Widget _buildMissionStatusSection(ThemeData theme) {
    // Set the statusId to 1 for the example (CREATED)
    int statusId = 1;
    String statusLabel = _getStatusLabel(statusId);
    Color statusColor = _getStatusColor(statusId);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Icon(
            mission.isSuccessful == true ? Icons.check_circle : Icons.pending,
            color: mission.isSuccessful == true ? Colors.green : Colors.orange,
          ),
          title: Text(
            'Status'.tr,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: theme.primaryColor),
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

  String _getStatusLabel(int statusId) {
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

  Color _getStatusColor(int statusId) {
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
}
