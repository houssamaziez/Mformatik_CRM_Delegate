import 'dart:convert';

import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Model/user.dart';
import 'package:http/http.dart' as http;
import 'package:mformatic_crm_delegate/App/RouteEndPoint/EndPoint.dart';
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';

import '../../auth/auth_controller.dart';

class ControllerPerson extends GetxController {
  var persons = <Person>[].obs;
  Person? observator;
  Person? responsable;
  var isLoading = true.obs;
  var offset = 0.obs; // Initial offset
  final int limit = 10; // Number of items per page

  Future<void> fetchPersons({int? offsetValue, String? fullName}) async {
    try {
      persons.clear();
      offset.value = 0;
      isLoading(true);
      update();
      final currentOffset = offsetValue ?? offset.value;
      update();
      final response = await http.get(
        Uri.parse(Endpoint.apiPersons).replace(
          queryParameters: {
            'offset': currentOffset.toString(), // Add offset
            'limit': limit.toString(), // Add limit
            'isItForAssigne': true.toString(),
            'attributes[]': ['id', 'firstName', 'lastName'],
          },
        ),
        headers: {"x-auth-token": token.read("token").toString()},
      );
      print("-----------------------------");
      print(json.decode(response.body));
      print("-----------------------------");

      if (response.statusCode == 200) {
        List<dynamic> responseData = json.decode(response.body);

        if (responseData.isNotEmpty) {
          persons.addAll(
              responseData.map((client) => Person.fromJson(client)).toList());
          update();
          update();

          // Update the offset for the next request
          offset.value += limit;
        }
      } else {
        persons.clear();
        update();
        throw Exception('Failed to load clients');
      }
    } catch (e) {
      persons.clear();
      update();
      print('Error: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchClientsaddOffset({
    int? offsetValue,
  }) async {
    try {
      isLoading(true);
      update();
      final currentOffset = offsetValue ?? offset.value;
      update();

      final response = await http.get(
        Uri.parse(Endpoint.apiPersons).replace(
          queryParameters: {
            'offset': currentOffset.toString(),
            'limit': limit.toString(),
            'isItForAssigne': true.toString(),
            'attributes[]': ['id', 'firstName', 'lastName'],
          },
        ),
        headers: {"x-auth-token": token.read("token").toString()},
      );
      print(json.decode(response.body));
      if (response.statusCode == 200) {
        List<dynamic> responseData = json.decode(response.body);

        // Check if there are more clients to fetch
        if (responseData.isNotEmpty) {
          // Append the new clients to the existing list

          persons.addAll(
              responseData.map((client) => Person.fromJson(client)).toList());
          update();
          update();

          offset.value += limit;
        }
      } else {
        persons.clear();
        update();
        throw Exception('Failed to load clients');
      }
    } catch (e) {
      persons.clear();
      update();
      print('Error: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> search({required String fullName}) async {
    persons.clear();

    try {
      isLoading(true);
      update();
      // If no offset is passed, use the current offset value
      // Create a base map for query parameters
      Map<String, dynamic> queryParams = {
        'limit': '20', // Set limit to 20
        'attributes[]': ['id', 'firstName', 'lastName'],
      };

      // Conditionally add 'fullName' to the queryParams map
      if (fullName.isNotEmpty) {
        queryParams['search'] = fullName;
      }
      final response = await http.get(
        Uri.parse(Endpoint.apiPersons).replace(
          queryParameters: queryParams,
        ),
        headers: {"x-auth-token": token.read("token").toString()},
      );
      print(json.decode(response.body));
      if (response.statusCode == 200) {
        List<dynamic> responseData = json.decode(response.body);

        // Check if there are more clients to fetch
        if (responseData.isNotEmpty) {
          // Append the new clients to the existing list
          persons.clear();

          persons.addAll(
              responseData.map((client) => Person.fromJson(client)).toList());
          update();

          // Update the offset for the next request
          offset.value += limit;
        }
      } else {
        persons.clear();
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
    persons.clear(); // Clear the current clients list
    await fetchPersons(fullName: ''); // Fetch the first page of clients
    update();
  }

  selectPersont(tag, Person person) {
    if (tag == "Responsable") {
      responsable = person;
      update();
      Go.back(Get.context);
    } else {
      observator = person;
      update();
      Go.back(Get.context);
    }
  }

  closePerson(tag) {
    if (tag == "Responsable") {
      responsable = null;
      update();
    } else {
      observator = null;
      update();
    }
  }
}
