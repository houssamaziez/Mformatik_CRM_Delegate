import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';
import '../../../../../../Model/client.dart';
import '../createscreenview/cretate_screen.dart';

class ClientProfileScreen extends StatelessWidget {
  final Client client;

  const ClientProfileScreen({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(client.fullName ?? 'Client Profile'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Go.to(
            context,
            CreateMissionScreen(
              clientID: client.id,
            ));
      }),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Client Basic Information
              _buildProfileHeader(client),
              const SizedBox(height: 20),
              // Contact Details Section
              _buildContactSection(client),
              const SizedBox(height: 20),
              // Business Information
              _buildBusinessDetailsSection(client),
              const SizedBox(height: 20),
              // Additional Client Info
              _buildOtherDetails(client),
              SizedBox(
                height: 20,
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
        CircleAvatar(
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
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Client ID: ${client.localId}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactSection(Client client) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildContactRow(Icons.phone, 'Phone', client.phone ?? 'N/A'),
          _buildContactRow(Icons.email, 'Email', client.email ?? 'N/A'),
          _buildContactRow(
              Icons.location_on, 'Address', client.address ?? 'N/A'),
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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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

  Widget _buildBusinessDetailsSection(Client client) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Business Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildInfoRow('Sold:', client.sold),
            _buildInfoRow('Potential:', client.potential),
            _buildInfoRow('Turnover:', client.turnover),
            _buildInfoRow('Cashing In:', client.cashingIn),
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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Other Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Region: ${client.region ?? 'N/A'}',
                style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Client Since: ${client.createdAt}',
                style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
