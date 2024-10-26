import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mformatic_crm_delegate/App/RouteEndPoint/EndPoint.dart';
import 'dart:convert';

import '../../Model/client.dart';
import '../auth/auth_controller.dart';

class ClientController extends GetxController {
  var clients = <Client>[].obs;
  var isLoading = true.obs;
  var offset = 0.obs; // Initial offset
  final int limit = 10; // Number of items per page

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchClients(String id,
      {int? offsetValue, required String fullName}) async {
    try {
      isLoading(true);
      update();
      final currentOffset = offsetValue ?? offset.value;
      update();

      final response = await http.get(
        Uri.parse(Endpoint.apiCients).replace(
          queryParameters: {
            'companyId': id.toString(),
            'offset': currentOffset.toString(), // Add offset
            'limit': limit.toString(), // Add limit
          },
        ),
        headers: {"x-auth-token": token.read("token").toString()},
      );
      print(json.decode(response.body)['rows']);
      if (response.statusCode == 200) {
        List<dynamic> responseData = json.decode(response.body)['rows'];

        // Check if there are more clients to fetch
        if (responseData.isNotEmpty) {
          // Append the new clients to the existing list

          clients.addAll(
              responseData.map((client) => Client.fromJson(client)).toList());
          update();
          update();

          // Update the offset for the next request
          offset.value += limit;
        }
      } else {
        clients.clear();
        update();
        throw Exception('Failed to load clients');
      }
    } catch (e) {
      clients.clear();
      update();
      print('Error: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> search(String id, {required String fullName}) async {
    clients.clear();

    try {
      isLoading(true);
      update();
      // If no offset is passed, use the current offset value
      // Create a base map for query parameters
      Map<String, String> queryParams = {
        'companyId': id.toString(),
        'limit': '20', // Set limit to 20
      };

      // Conditionally add 'fullName' to the queryParams map
      if (fullName.isNotEmpty) {
        queryParams['fullName'] = fullName;
      }
      final response = await http.get(
        Uri.parse(Endpoint.apiCients).replace(
          queryParameters: queryParams,
        ),
        headers: {"x-auth-token": token.read("token").toString()},
      );
      print(json.decode(response.body)['rows']);
      if (response.statusCode == 200) {
        List<dynamic> responseData = json.decode(response.body)['rows'];

        // Check if there are more clients to fetch
        if (responseData.isNotEmpty) {
          // Append the new clients to the existing list
          clients.clear();

          clients.addAll(
              responseData.map((client) => Client.fromJson(client)).toList());
          update();

          // Update the offset for the next request
          offset.value += limit;
        }
      } else {
        clients.clear();
        update();
        throw Exception('Failed to load clients');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading(false);
    }
  }

  // Method to reset the client list and fetch from the beginning
  Future<void> refreshClients(String id) async {
    offset.value = 0; // Reset the offset
    clients.clear(); // Clear the current clients list
    await fetchClients(id, fullName: ''); // Fetch the first page of clients
    update();
  }
}
