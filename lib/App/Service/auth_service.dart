import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mformatic_crm_delegate/App/RouteEndPoint/EndPoint.dart';

import '../Util/app_exceptions/response_handler.dart';
import '../Util/app_exceptions/response_handler/process_response_auth.dart';

class AuthService {
  static Future<Map<String, dynamic>?> login(
      {required String username, required String password}) async {
    Uri url = Uri.parse(Endpoint.apiLogin);
    try {
      final response = await http.post(url, body: {
        "username": username.trim(),
        "password": password.trim(),
      });
      print(response.body);
      return ResponseHandlerAuth.processResponseAuth(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error during login: $e');
      }
      rethrow;
    }
  }

  static Future<Map<String, dynamic>?> fetchUserData(String token) async {
    Uri url = Uri.parse(Endpoint.apIme);
    try {
      final response = await http.get(url, headers: {
        "x-auth-token": token,
      });

      if (response.statusCode == 200) {
        return ResponseHandler.processResponse(response);
      } else {
        throw Exception('Failed to fetch user data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during fetching user data: $e');
      rethrow;
    }
  }

  static dynamic decodeResponseBody(http.Response response) {
    return jsonDecode(response.body);
  }
}
