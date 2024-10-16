// client_controller.dart
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mformatic_crm_delegate/App/RouteEndPoint/EndPoint.dart';
import 'dart:convert';

import '../../Model/client.dart';
import '../auth/auth_controller.dart';

class ClientController extends GetxController {
  var clients = <Client>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchClients(String id) async {
    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse(Endpoint.apiCients).replace(
          queryParameters: {
            'companyId': 4.toString(),
          },
        ),
        headers: {"x-auth-token": token.read("token").toString()},
      );

      if (response.statusCode == 200) {
        List<dynamic> responseData = json.decode(response.body)['rows'];
        clients.value =
            responseData.map((client) => Client.fromJson(client)).toList();
      } else {
        throw Exception('Failed to load clients');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading(false);
    }
  }
}
