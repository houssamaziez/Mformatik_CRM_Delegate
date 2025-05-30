import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/Containers/container_blue.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../../Model/client.dart';
import '../home_feedback/create_feedback/cretate_screen.dart';
import '../home_mission/createmission/cretate_screen.dart';

class ClientProfileScreen extends StatelessWidget {
  final Client client;

  const ClientProfileScreen({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(client.fullName ?? 'Client Profile'.tr),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).primaryColor,
        label: Text(
          "Actions".tr,
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(
          Icons.menu,
          color: Colors.white,
        ),
        onPressed: () {
          _showActionSheet(context);
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Client Basic Information
              // _buildProfileHeader(client),
              // const SizedBox(height: 20),
              // Contact Details Section
              _buildContactSection(client),
              const SizedBox(height: 20),
              // Business Information
              _buildBusinessDetailsSection(context, client),
              const SizedBox(height: 20),
              // Additional Client Info
              _buildOtherDetails(client),
              const SizedBox(
                height: 80,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(Client client) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.person, size: 40, color: Colors.white),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                client.fullName ?? 'N/A',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              // Text(
              //   'Client ID: ${client.localId}',
              //   style: TextStyle(
              //     fontSize: 16,
              //     color: Colors.grey[700],
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactSection(Client client) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Details'.tr,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          InkWell(
              onTap: () => client.tel != null
                  ? launchUrlString("tel://${client.tel}")
                  : null,
              child:
                  _buildContactRow(Icons.phone, 'Tel'.tr, client.tel ?? 'N/A')),
          InkWell(
              onTap: () => client.phone != null
                  ? launchUrlString("tel://${client.phone}")
                  : null,
              child: _buildContactRow(Icons.phone_android_rounded, 'Phone'.tr,
                  client.phone ?? 'N/A')),
          _buildContactRow(Icons.email, 'Email'.tr, client.email ?? 'N/A'),
          _buildContactRow(
              Icons.location_on, 'Address'.tr, client.address ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent),
          const SizedBox(width: 12),
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessDetailsSection(
    context,
    Client client,
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
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            value.isNotEmpty ? value : 'N/A',
            style: TextStyle(fontSize: 16, color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }

  Widget _buildOtherDetails(Client client) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Other Details'.tr,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text('Region:'.tr + " ${client.region ?? 'N/A'}",
              style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 10),
          Text('Client Since:'.tr + " ${client.createdAt}",
              style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  void _showActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              height: 5,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.add_circle, color: Colors.green),
              title: Text("Add Mission".tr),
              onTap: () {
                Get.to(() => CreateMissionScreen(clientID: client.id!));
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_circle, color: Colors.green),
              title: Text("Add Feedback".tr),
              onTap: () {
                Get.to(() => CreateFeedBackScreen(
                      clientID: client.id!,
                      missionID: null,
                      feedbackModelID: 0,
                    ));
              },
            ),
          ],
        );
      },
    );
  }
}
